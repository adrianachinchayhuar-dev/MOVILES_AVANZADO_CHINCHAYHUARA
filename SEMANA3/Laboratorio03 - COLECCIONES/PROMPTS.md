# Prompts – Lab 03

## Docente: Juan Leon – Tecsup
## Estudiante: Adriana Chinchayhuara
## Herramienta: Gemini

## Ejercicio 6 – Gestión de notas

### Prompt (CTRFE):
* **CONTEXTO:** Soy estudiante del curso de desarrollo de aplicaciones para iOS en Tecsup y estoy en la semana 3 aprendiendo colecciones en Swift.
* **TAREA:** Necesito que me ayudes a programar una solución en Swift para gestionar las notas de un grupo de estudiantes. Para que no sea confuso, vamos a dividir el código en 3 partes secuenciales:
  1. *Parte 1:* Pide la cantidad N de alumnos. Por cada uno, solicita su nombre y 3 notas guardando la información en un diccionario `[String: [Double]]`.
  2. *Parte 2:* Calcula el promedio de cada estudiante y clasifícalo usando un `switch` en (Excelente, Bueno, Aprobado o Desaprobado). Muestra también las estadísticas generales del grupo: el promedio del salón, la nota más alta, la nota más baja y el porcentaje total de aprobados.
  3. *Parte 3:* Toma los datos de los alumnos y ordénalos por su promedio de mayor a menor para imprimirlos en consola de forma ordenada.
* **RESTRICCIONES:** Solo puedo usar lo que he aprendido hasta la semana 3 (arreglos, diccionarios, ciclos y estructuras de control). No utilices estructuras `struct`, clases `class` ni funciones personalizadas.
* **FORMATO:** Dame el código en bloques separados para cada parte y asegúrate de incluir un comentario explicativo en CADA línea de código.
* **EJEMPLO:** `var registroAlumnos: [String: [Double]] = [:] // Creo un diccionario para guardar los nombres y sus notas`

---

## Ejercicio 7 – Inventario con menú

### Prompt (CTRFE):
* **CONTEXTO:** Soy estudiante de iOS en Tecsup (semana 3) y estoy haciendo una práctica de consola sobre control de flujo y colecciones en Swift.
* **TAREA:** Quiero construir un programa interactivo para gestionar un inventario de productos. Por favor divídelo en 2 partes:
  1. *Parte 1:* Solicita la cantidad N de productos a ingresar y pide el nombre, precio y stock de cada uno, guardando los datos en arreglos individuales.
  2. *Parte 2:* Crea un menú interactivo dentro de un bucle `while` controlado por un `switch` que se repita hasta presionar la opción 5. Las opciones son: 1) Ver inventario completo, 2) Buscar producto por nombre, 3) Alerta de productos con stock bajo (menor a 5 unidades), 4) Calcular el valor total comercial del inventario y 5) Salir.
* **RESTRICCIONES:** Usa únicamente arreglos simples y estructuras `while` o `switch`. No uses `struct`, `class` ni diccionarios avanzados.
* **FORMATO:** Entrégame el código dividido en esas 2 partes con un comentario explicativo al final de CADA línea de código.
* **EJEMPLO:** `while opcion != 5 { // Mantengo el menú activo mientras no elija la opción de salir`
