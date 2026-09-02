# Prompts Utilizados - Laboratorio 02

## Ejercicio 6: Carrito Mejorado con IA

### Prompt (estructura CTRFE):
- **CONTEXTO:** Estudio Diseño y Desarrollo de Software en Tecsup, actualmente en el curso de Programación en Móviles Avanzado. Estoy desarrollando en Swift Playgrounds dentro de la rama `ai-assisted` del Laboratorio 02.
- **TAREA:** Necesito que generes el código para potenciar el carrito de compras del Ejercicio 5 (manteniendo los 5 productos base: Laptop, Mouse, Teclado, Monitor y USB Cable), incorporando: 1) descuento del 5% por cantidad si un producto tiene 3 unidades o más, 2) cupón "DESCUENTO20" que sume un 20% adicional de rebaja sobre el subtotal, 3) envío gratis si el total supera S/. 3000 o cobro de S/. 25.00 si es menor, 4) acumulación de puntos de fidelidad (1 punto por cada S/. 100 gastados), y 5) validación que detecte precios negativos o cantidades en cero y detenga la compra con un mensaje de error.
- **RESTRICCIONES:** Usar únicamente Swift básico compatible con Playground; nada de arreglos ni estructuras avanzadas, solo variables y constantes individuales con condicionales e `if/else`, respetando la estructura del ticket original.
- **FORMATO:** Entregar código Swift totalmente funcional, comentando CADA línea de forma explicativa y mostrando el ticket final por consola.
- **EJEMPLO:**
```swift
let precio1 = 3500.0 // Declara el precio unitario del producto 1

### ¿Funcionó a la primera?
No totalmente. En la primera respuesta la IA solo usó 2 productos de ejemplo en lugar de mantener los 5 productos del Ejercicio 5. Tuve que pedirle en un segundo prompt que reutilizara la lista completa del carrito original.

### ¿La IA usó algo que no conocías?
Sí, utilizó la función `import Foundation` en lugar de `import UIKit` y aplicó conversiones explícitas como `Double(cant1)` para poder multiplicar un `Int` por un `Double` sin errores de tipo.

---



## Ejercicio 7: Juego de Adivinanza
### Prompt (Estructura CTRFE):
- **CONTEXTO:** Estudio Diseño y Desarrollo de Software en Tecsup, actualmente en el curso de Programación en Móviles Avanzado. Estoy desarrollando en Swift Playgrounds dentro de la rama `ai-assisted` del Laboratorio 02.
- **TAREA:** Generar un mini juego de adivinanza de números en Swift Playground que simule la experiencia de adivinar un número secreto. Debe incluir: 1) un número secreto fijo (ej. 42), 2) simulación de 5 intentos seguidos con variables o arreglo de prueba, 3) un bucle while para recorrer la lista de intentos, 4) evaluador condicional que imprima si el intento es "Muy alto", "Muy bajo" o "¡Correcto!", 5) contador de intentos realizados, y 6) mensaje de derrota "Perdiste. El número era: X" si agota los 5 intentos sin acertar.
- **RESTRICCIONES:** Usar únicamente sintaxis Swift básica para Playground. El bucle while debe detenerse automáticamente apenas el jugador adivine el número correcto.
- **FORMATO:** Entregar código Swift totalmente funcional, comentando CADA línea explicando la lógica de comparación y la condición de parada del bucle.
- **EJEMPLO:**
```swift
let numeroSecreto = 42 // Define la meta numérica que se debe adivinar

### ¿Funcionó a la primera?
Sí, la IA entregó el bucle while estructurado correctamente y las comparaciones indicaron con precisión "Muy alto", "Muy bajo" y el mensaje de éxito en el intento correspondiente.
### ¿La IA usó algo que no conocías?
Sí, utilizó la propiedad .count en una lista de enteros para evaluar el límite del bucle while.
