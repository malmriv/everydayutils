#Simulación: cavidad con tapa móvil, descrita por Mark Owkes em 
#"A guide to writing your first CFD solver". Traducido a R.
library(viridis)
library(rasterVis)

# Constantes
nu = 0.001 # Viscosidad cinemática 
rho = 1.0 # Densidad

# Parámetros de la simulación
N = 32 #Celdas (si la cavidad es cuadrada, si no, (nx,ny))
nx = N 
ny = N 
Lx = 1 # Longitud en dirección x
Ly = 1 # Longitud en dirección y
dt = 0.01 # Paso temporal
t_final = 0.5 # Tiempo de simulación total (en segundos)

# Índices de la red
imin = 2
imax = imin + nx - 1
jmin = 2
jmax = jmin + ny - 1

# Creamos la red
x = seq(0, Lx, length.out = nx + 1)
y = seq(0, Ly, length.out = ny + 1)

# Y la red de puntos intermedios
xm = numeric(imax - imin + 1)
ym = numeric(jmax - jmin + 1)

for (i in imin:imax) {
  xm[i - imin + 1] = 0.5 * (x[i] + x[i + 1])
}

for (j in jmin:jmax) {
  ym[j - jmin + 1] = 0.5 * (y[j] + y[j + 1])
}

# Definimos los tamaños de las celdas y sus inversos (usaremos mucho dxi y dyi)
dx = x[imin + 1] - x[imin]
dy = y[jmin + 1] - y[jmin]
dxi = 1 / dx
dyi = 1 / dy

# Número de pasos de la simulación
Nt = t_final / dt

# Reservamos todos los arrays necesarios
p = matrix(0, nrow = imax, ncol = jmax)
us = matrix(0, nrow = imax + 1, ncol = jmax + 1)
vs = matrix(0, nrow = imax + 1, ncol = jmax + 1)
R = matrix(0, nrow = imax, ncol = 1)
u = matrix(0, nrow = imax + 1, ncol = jmax + 1)
v = matrix(0, nrow = imax + 1, ncol = jmax + 1)
t = numeric(Nt)
Z = matrix(0, nrow = nx, ncol = nx) # Fill 'Z' with actual data (peaks(nx))
L = matrix(0, nrow = nx * ny, ncol = nx * ny)

# Condiciones iniciales
time = seq(0,t_final,by=dt) # Vector de tiempos
time[1] = 0 # Tiempo inicial
u_bot = 2 # Vel. inicial pared de abajo (quieta)
u_top = 2 # Vel. inicial pared de arriba (móvil)
v_lef = 0 # Vel. inicial pared izquierda (quieta)
v_rig = 0 # Vel. inicial pared derecha (quita)

# Creamos el operador laplaciano
L = matrix(0, nrow = nx * ny, ncol = nx * ny)
for(j in 1:ny) {
  for(i in 1:nx) {
    L[i+(j-1)*nx , i+(j-1)*nx] = 2 * dxi^2 + 2 * dyi^2
    ii_vec = seq(i-1,i+1,by=2)
    for(ii in ii_vec) {
      if(ii>0 & ii<=nx) L[i+(j-1)*nx, ii+(j-1)*nx] = -dxi^2
      else {L[i+(j-1)*nx, i+(j-1)*nx] = L[i+(j-1)*nx , i+(j-1)*nx]-dxi^2}
    }
    jj_vec = seq(j-1,j+1,by=2)
    for(jj in jj_vec) {
      if(jj>0 & jj<=ny) L[i+(j-1)*nx, i+(jj-1)*ny] = -dxi^2
      else {L[i+(j-1)*nx, i+(j-1)*nx] = L[i+(j-1)*nx , i+(j-1)*nx]-dxi^2}
    }
  }
}
#No sé por qué se hace esto pero la primera fila son ceros, y la entrada arriba-izqda un uno
L[1, ] = 0
L[1, 1] = 1

#Creo una barra de progreso
# Initializes the progress bar
pb = txtProgressBar(min = 0, max = length(time), style = 3, width = 50, char = "|")

#Iteramos sobre todos los pasos temporales
index = 0
for(t in time) {
  index = index+1
  setTxtProgressBar(pb, index)
  # Actualizamos el tiempo y establecemos condición de contorno (pared móvil)
  u_top[] = 2
  u_bot[] = 2
  
  #Hacemos una primera estimación de u (u_estrella en la literatura)
  for (j in jmin:jmax) {
    for (i in (imin + 1):imax) {
      A = (nu * (u[i - 1, j] - 2 * u[i, j] + u[i + 1, j]) * dxi^2 +
              nu * (u[i, j - 1] - 2 * u[i, j] + u[i, j + 1]) * dyi^2 -
              u[i, j] * (u[i + 1, j] - u[i - 1, j]) * 0.5 * dxi -
              (0.25 * (v[i - 1, j] + v[i - 1, j + 1] + v[i, j] + v[i, j + 1])) *
              (u[i, j + 1] - u[i, j - 1]) * 0.5 * dyi)
      us[i, j] = u[i, j] + dt * A
    }
  }
  
  #Hacemos una primera estimación de v (v_estrella en la literatura)
  for (j in (jmin + 1):jmax) {
    for (i in imin:imax) {
      B = (nu * (v[i - 1, j] - 2 * v[i, j] + v[i + 1, j]) * dxi^2 +
              nu * (v[i, j - 1] - 2 * v[i, j] + v[i, j + 1]) * dyi^2 -
              (0.25 * (u[i, j - 1] + u[i + 1, j - 1] + u[i, j] + u[i + 1, j])) *
              (v[i + 1, j] - v[i - 1, j]) * 0.5 * dxi -
              v[i, j] * (v[i, j + 1] - v[i, j - 1]) * 0.5 * dyi)
      vs[i, j] = v[i, j] + dt * B
    }
  }
  
  #Calculamos el vector columna del lado derecho (R) de la ecuación de presión de Poisson
  n = 0
  for (j in jmin:jmax) {
    for (i in imin:imax) {
      n = n + 1
      R[n] = -rho / dt * ((us[i + 1, j] - us[i, j]) * dxi + (vs[i, j + 1] - vs[i, j]) * dyi)
    }
  }
  
  # Resolvemos el sistema L*pv = R
  pv = solve(L, R)
  n = 0

  # Convertimos pv (vector columna) en una matriz cuadrada (p)
  p = matrix(0, nrow = imax, ncol = jmax)
  for (j in jmin:jmax) {
    for (i in imin:imax) {
      n = n + 1
      p[i, j] = pv[n]
    }
  }
  
  # Calculamos las velocidades (u, v) a partir de las primeras aproximaciones
  for (j in jmin:jmax) {
    for (i in (imin + 1):imax) {
      u[i, j] = us[i, j] - dt / rho * (p[i, j] - p[i - 1, j]) * dxi
    }
  }
  
  for (j in (jmin + 1):jmax) {
    for (i in imin:imax) {
      v[i, j] = vs[i, j] - dt / rho * (p[i, j] - p[i, j - 1]) * dyi
    }
  }
  
  # Volvemos a establecer las condiciones de contorno para la siguiente iteración
  u[, jmin - 1] = u_bot
  u[, jmax + 1] = u_top
  v[imin - 1, ] = v_lef
  v[imax + 1, ] = v_rig
  }
#Mostramos la representación de la presión como matriz y también la aproximación
#continua (las líneas de contorno asgnadas a la matriz de velocidades)
filled.contour(sqrt(u^2+v^2),main="Velocidad del fluido: tapa deslizante.",nlevels = 50,
               col=rev(viridis(50)))
image(sqrt(u^2+v^2),main="Velocidad del fluido: tapa deslizante.",
               col=rev(viridis(35)),asp=1)


