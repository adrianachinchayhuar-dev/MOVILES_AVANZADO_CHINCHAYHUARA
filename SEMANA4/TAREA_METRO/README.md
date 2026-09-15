# Metro de Lima 2026 — Simulador de Red

Simulador de consola en Swift que permite consultar las líneas del Metro de
Lima, buscar estaciones y lugares, planificar viajes con transbordo, y
calcular tarifas reales según el sistema de recaudo vigente.

## Cómo ejecutarlo

```bash
swiftc MetroLima.swift -o metro
./metro
```

Al iniciar se pide el nombre y el tipo de pasajero; ambos se pueden cambiar
después desde la opción **9**.

---

## Funcionalidades

0. Configuración inicial (al arrancar el programa)
Antes de mostrar el menú, el programa pide el nombre del usuario y su tipo 
de pasajero (adulto, escolar, universitario o adulto mayor). Estos datos 
alimentan el resto del simulador: el nombre aparece en la cabecera del menú 
y en el plan de viaje, y el tipo de pasajero determina qué tarifa se cobra 
en la opción 5. Ambos se pueden cambiar después desde la opción 9 sin perder 
el historial de viajes ya registrado.

### 1. Ver líneas y estado del servicio
Lista las 6 líneas con color, recorrido, cantidad de estaciones (o aviso de
"sin lista publicada" si no las tiene), y el sistema de pago que usan.

### 2. Ver estaciones de una línea
Muestra la lista completa de estaciones de la línea elegida, agrupadas por
ramal cuando corresponde (la Línea 4 tiene dos: el Ramal Faucett-Gambetta y
el Tronco). Al final se agrega un aviso propio de la línea:

| Línea | Aviso mostrado |
|---|---|
| L1 | Confirmación de que está en servicio |
| L2 | Aviso de que parte de la línea está en construcción, pero que esas estaciones **sí se pueden usar** en el planificador |
| L3 | Aviso de que la línea no está en servicio y los tiempos son estimados |
| L4 | Aviso de que parte está en obra y parte es trazado anunciado |
| L5 / L6 | En vez de una lista, se muestra una **ficha de corredor**: kilómetros estimados, distritos, avenidas, empalme conocido (si existe) y situación del proyecto. No se inventan nombres de estación. |

### 3. Buscar estación, lugar o distrito
Búsqueda por texto libre, con tolerancia a tildes y coincidencias
parciales. Encuentra:
- Estaciones por nombre.
- Lugares de Lima que no son estaciones (ej. "Plaza de Armas", "Larcomar",
  "Jockey Plaza"), cada uno con su alias, distancia a pie y estación más
  cercana.
- Puntos de interés registrados dentro de una estación.
- Si no hay coincidencia exacta, ofrece estaciones del mismo distrito o
  avisa si el distrito corresponde al corredor de L5/L6.

### 4. Ver conexiones entre líneas
Lista las conexiones entre líneas **declaradas explícitamente** (no
deducidas por nombre igual), con el tiempo de transbordo y si implica salir
a la calle. Incluye el caso de "28 de Julio", que existe tanto en L1 como
en L2 sin ser la misma estación — el cruce real es Gamarra (L1) con 28 de
Julio (L2), caminando.

### 5. Planificar viaje
El corazón del simulador. Pide origen, destino, día (lunes a sábado /
domingo o feriado) y hora de salida, y calcula la ruta más rápida sobre un
grafo de toda la red con el algoritmo de Dijkstra. Devuelve:
- Itinerario paso a paso: línea a tomar, sentido del tren, estaciones
  intermedias, dónde bajar y dónde transbordar.
- Tiempo total y hora de llegada estimada, con recargo de +25% en hora
  punta (06:30–09:00 y 17:00–20:00, lunes a sábado).
- Tarifa desglosada por tramo, sumando un pasaje cada vez que cambia el
  sistema de recaudo.
- Tarjetas que le faltan al usuario y aviso de saldo insuficiente, según lo
  cargado en el perfil.
- Estado del horario de cada línea usada en la ruta.
- Si el destino es un lugar (no una estación), las indicaciones finales a
  pie desde la estación hasta el lugar.
- Un bloque final **"A tener en cuenta"** si la ruta usa estaciones en
  construcción o trazado proyectado — el plan se muestra completo de todas
  formas; el aviso es informativo, no un bloqueo.

### 6. ¿Qué hay cerca de una estación?
Dado el nombre de una estación, muestra su distrito, los puntos de interés
registrados en ella y los lugares de la lista `lugaresDeLima` que la usan
como estación de referencia.

### 7. Tarifas y política de pago
Explica los dos sistemas de recaudo, sus tarifas y el costo de cada
tarjeta; aclara que la tarjeta de la Línea 1 **no sirve** en la Línea 2 (y
viceversa) y que hoy un transbordo entre ambas se paga dos veces; describe
cómo cobra el simulador (un pasaje por cada cambio de sistema) y las reglas
del medio pasaje (escolar y adulto mayor todos los días; universitario solo
de lunes a sábado).

### 8. Horarios
Horario oficial de L1 y L2 (L2 con el mismo horario que L1, sin
diferenciar por estación operativa u obra). L3 y L4 se muestran
explícitamente **sin horario oficial** por no estar en servicio. L5 y L6,
sin estaciones ni servicio. Se explica el criterio de hora punta que usa el
planificador y se aclara que ese recargo afecta el tiempo, no la tarifa.

### 9. Mi perfil y saldo
Permite cambiar nombre y tipo de pasajero, y comprar/recargar cualquiera de
las dos tarjetas. El saldo y las tarjetas compradas se usan en la opción 5
para avisar si falta comprar una tarjeta o si el saldo no alcanza.

### 10. Mis viajes de esta sesión
Historial de los viajes planificados en la opción 5, con costo y duración
de cada uno, y el total gastado.

### 11. Salir
Cierra el programa mostrando el resumen de viajes planificados y el total
gastado, si hubo alguno.

---

## Modelo de datos

- **`NivelDeDatos`**: describe qué tan firme es el dato de una estación —
  `operativa`, `enObra`, `trazadoPublicado` o `soloCorredor`. Se usa solo
  para elegir el texto del aviso; **no restringe** qué estaciones entran al
  planificador — todas las estaciones registradas son usables en la ruta,
  sin importar su nivel.
- **`SistemaDePago`**: la tarifa depende del sistema de recaudo (tarjeta
  propia de L1 o TIT), no de la línea. Evita duplicar tarifas estimadas por
  cada línea nueva.
- **`Ramal`**: una línea puede tener más de un tramo con nombre propio; hoy
  solo la Línea 4 lo usa (Ramal Faucett-Gambetta + Tronco).
- **`Conexion`**: cada transbordo entre líneas está declarado a mano, con
  su tiempo y si implica salir a la calle. No se infiere por coincidencia
  de nombres.
- **`Lugar`**: destinos de Lima que no son estaciones, con alias de
  búsqueda, distancia a pie e indicaciones desde la estación más cercana.

### Origen de los datos

| Línea | Estaciones | Fuente / estado |
|---|---|---|
| L1 | 26 | Operativa, datos reales |
| L2 | 27 | 5 operativas (Etapa 1A) + 22 confirmadas en construcción |
| L3 | 28 | Nombres anunciados oficialmente, sin obra iniciada |
| L4 | 8 + 20 | Ramal Faucett-Gambetta en obra + Tronco anunciado |
| L5 | 0 | Sin estaciones publicadas — solo ficha de corredor |
| L6 | 0 | Sin estaciones publicadas — solo ficha de corredor |

---

## Restricciones y limitaciones conocidas

- **No hay distinción entre "red de hoy" y "red proyectada".** El
  planificador siempre calcula rutas usando la red completa (L1 a L4). Si
  el resultado incluye estaciones en obra o proyectadas, se avisa al final
  del plan, pero el viaje **nunca se bloquea** por ese motivo.
- **L5 y L6 no participan del planificador de rutas** porque no tienen
  estaciones publicadas. Solo se puede consultar su ficha de corredor
  (distritos, avenidas, kilómetros estimados, empalme conocido si existe).
- **L3 y L4 no tienen horario oficial.** El simulador no inventa uno; la
  opción 8 lo indica de forma explícita para ambas.
- **La tarifa de L3 y L4 no está confirmada por la ATU.** Se usa la TIT
  (S/ 1.40 / S/ 0.70) como referencia y el plan de viaje lo marca como
  estimado.
- **La tarifa integrada entre líneas que comparten la TIT es un supuesto
  del simulador**, no una política publicada. Hoy la ATU no ha confirmado
  una integración tarifaria entre líneas del metro más allá de la propia
  TIT dentro de la Línea 2.
- **El ruteo asume una sola tarifa por sistema de recaudo cambiado**, sin
  modelar descuentos por transbordo dentro de una ventana de tiempo (como
  sí existe, por ejemplo, en el Metropolitano con sus alimentadoras).
- **Los tiempos entre estaciones son un promedio por línea**, no una
  medición estación por estación; en L3–L6 son enteramente estimados.
- **El grafo se recorre con búsqueda lineal del nodo mínimo** en lugar de
  una cola de prioridad. Es suficiente para el tamaño actual de la red
  (menos de 100 nodos) pero no escalaría bien si se agregaran muchas más
  líneas.
- **No hay persistencia.** El perfil, el saldo y el historial de viajes
  viven solo en memoria durante la ejecución; al cerrar el programa se
  pierden.
- **No hay concurrencia real ni async/await.** El programa es de consola,
  de un solo hilo, con lectura bloqueante de `readLine()`.
