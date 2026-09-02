import Foundation

// ==========================================
// ===== EJERCICIO 6: CARRITO MEJORADO ======
// ==========================================

// --- Datos de los 5 productos base del Ejercicio 5 ---
let prod1 = "Laptop" // Declara el nombre del primer producto
let precio1 = 3500.0 // Declara el precio unitario de la Laptop
let cant1 = 1 // Declara la cantidad a comprar de la Laptop

let prod2 = "Mouse" // Declara el nombre del segundo producto
let precio2 = 45.50 // Declara el precio unitario del Mouse
let cant2 = 2 // Declara la cantidad a comprar del Mouse

let prod3 = "Teclado" // Declara el nombre del tercer producto
let precio3 = 120.00 // Declara el precio unitario del Teclado
let cant3 = 1 // Declara la cantidad a comprar del Teclado

let prod4 = "Monitor" // Declara el nombre del cuarto producto
let precio4 = 890.00 // Declara el precio unitario del Monitor
let cant4 = 1 // Declara la cantidad a comprar del Monitor

let prod5 = "USB Cable" // Declara el nombre del quinto producto
let precio5 = 15.00 // Declara el precio unitario del Cable USB
let cant5 = 3 // Declara la cantidad a comprar del Cable USB (Aplica descuento por cantidad)

let cuponIngresado = "DESCUENTO20" // Variable con el código del cupón ingresado por el cliente

// --- REGLA 5: Validación de precios negativos o cantidades <= 0 ---
if precio1 < 0 || precio2 < 0 || precio3 < 0 || precio4 < 0 || precio5 < 0 || cant1 <= 0 || cant2 <= 0 || cant3 <= 0 || cant4 <= 0 || cant5 <= 0 { // Valida si hay errores en los datos
    print("[ERROR] Existen precios negativos o cantidades iguales a cero. Procesamiento cancelado.") // Notifica el error en consola
} else { // Si todos los precios y cantidades son válidos, ejecuta el cálculo de la compra
    
    // --- REGLA 1: Descuento del 5% si la cantidad es >= 3 por producto ---
    var sub1 = precio1 * Double(cant1) // Calcula el subtotal inicial del producto 1
    if cant1 >= 3 { sub1 -= sub1 * 0.05 } // Resta el 5% al producto 1 si lleva 3 o más unidades
    
    var sub2 = precio2 * Double(cant2) // Calcula el subtotal inicial del producto 2
    if cant2 >= 3 { sub2 -= sub2 * 0.05 } // Resta el 5% al producto 2 si lleva 3 o más unidades
    
    var sub3 = precio3 * Double(cant3) // Calcula el subtotal inicial del producto 3
    if cant3 >= 3 { sub3 -= sub3 * 0.05 } // Resta el 5% al producto 3 si lleva 3 o más unidades
    
    var sub4 = precio4 * Double(cant4) // Calcula el subtotal inicial del producto 4
    if cant4 >= 3 { sub4 -= sub4 * 0.05 } // Resta el 5% al producto 4 si lleva 3 o más unidades
    
    var sub5 = precio5 * Double(cant5) // Calcula el subtotal inicial del producto 5
    if cant5 >= 3 { sub5 -= sub5 * 0.05 } // Resta el 5% al producto 5 (USB Cable) por llevar 3 unidades

    // --- Subtotal General ---
    let subtotalGeneral = sub1 + sub2 + sub3 + sub4 + sub5 // Suma los subtotales de los 5 productos

    // --- Descuento por monto general (Lógica del Ejercicio 5) ---
    var porcentajeDescuento = 0.0 // Define la variable para el porcentaje según el monto acumulado
    if subtotalGeneral >= 5000 { // Evalúa si la compra es mayor o igual a 5000 soles
        porcentajeDescuento = 0.15 // Asigna 15% de descuento
    } else if subtotalGeneral >= 2000 { // Evalúa si la compra es mayor o igual a 2000 soles
        porcentajeDescuento = 0.10 // Asigna 10% de descuento
    } else if subtotalGeneral >= 500 { // Evalúa si la compra es mayor o igual a 500 soles
        porcentajeDescuento = 0.05 // Asigna 5% de descuento
    } else { // Si la compra es menor a 500 soles
        porcentajeDescuento = 0.0 // No aplica descuento por monto general
    } // Cierra la estructura condicional de descuentos generales

    let descuentoMonto = subtotalGeneral * porcentajeDescuento // Calcula el monto del descuento general
    var subtotalConDescuento = subtotalGeneral - descuentoMonto // Resta el descuento al subtotal general

    // --- REGLA 2: Cupón de descuento adicional (20%) ---
    var descuentoCupon = 0.0 // Inicializa la variable para el descuento del cupón
    if cuponIngresado == "DESCUENTO20" { // Valida si el cliente escribió el cupón correcto
        descuentoCupon = subtotalConDescuento * 0.20 // Calcula el 20% adicional sobre el subtotal acumulado
        subtotalConDescuento -= descuentoCupon // Aplica el descuento del cupón al monto acumulado
    } // Cierra la validación del cupón

    // --- Categoría del cliente mediante Switch (Lógica del Ejercicio 5) ---
    let montoParaCategoria = Int(subtotalGeneral) // Convierte el subtotal a entero para usar rangos
    var categoriaCliente = "" // Variable para guardar el nombre de la categoría del cliente
    switch montoParaCategoria { // Inicia el switch con el monto entero
    case 0..<500: categoriaCliente = "Regular" // Categoría Regular para montos entre 0 y 499
    case 500..<2000: categoriaCliente = "Frecuente" // Categoría Frecuente para montos entre 500 y 1999
    case 2000..<5000: categoriaCliente = "VIP" // Categoría VIP para montos entre 2000 y 4999
    default: categoriaCliente = "Premium" // Categoría Premium para montos desde 5000 a más
    } // Cierra la estructura switch

    // --- Impuestos y Envío ---
    let igv = subtotalConDescuento * 0.18 // Calcula el 18% del IGV sobre el subtotal acumulado
    let totalPrevioEnvio = subtotalConDescuento + igv // Suma el subtotal final con el IGV

    // --- REGLA 3: Envío Gratis si supera S/. 3000 ---
    let costoEnvio: Double // Variable para almacenar la tarifa del envío
    if totalPrevioEnvio > 3000.0 { // Comprueba si el costo supera los 3000 soles
        costoEnvio = 0.0 // Aplica envío gratuito
    } else { // Si el total previo es de 3000 o menos
        costoEnvio = 25.00 // Cobra tarifa fija de 25 soles
    } // Cierra la evaluación del envío

    let totalFinal = totalPrevioEnvio + costoEnvio // Suma el envío para obtener el monto definitivo

    // --- REGLA 4: Puntos de fidelidad (1 punto x cada S/. 100 de compra) ---
    let puntosGanados = Int(totalFinal / 100.0) // Obtiene los puntos dividiendo entre 100 y descartando decimales

    // --- Impresión del Ticket con Bucle (Lógica del Ejercicio 5) ---
    var separador = "" // Crea la variable para construir la línea separadora
    for _ in 1...40 { // Ejecuta el bucle 40 veces para formar la línea de división
        separador += "=" // Concatena el signo igual en cada iteración
    } // Cierra el bucle del separador

    print(separador) // Imprime la línea separadora superior
    print(" TICKET DE COMPRA - MEJORADO CON IA") // Imprime el encabezado principal del ticket
    print(" Cliente: \(categoriaCliente)") // Imprime la categoría asignada al cliente
    print(separador) // Imprime línea divisora
    print("\(prod1) x\(cant1) S/. \(sub1)") // Imprime la Laptop y su subtotal
    print("\(prod2) x\(cant2) S/. \(sub2)") // Imprime el Mouse y su subtotal
    print("\(prod3) x\(cant3) S/. \(sub3)") // Imprime el Teclado y su subtotal
    print("\(prod4) x\(cant4) S/. \(sub4)") // Imprime el Monitor y su subtotal
    print("\(prod5) x\(cant5) S/. \(sub5) (Incluye 5% desc. x3 unid)") // Imprime el Cable USB con aviso del descuento
    print(separador) // Imprime línea divisora
    print("Subtotal General: S/. \(subtotalGeneral)") // Imprime el subtotal sin descuentos
    print("Descuento Monto (\(porcentajeDescuento * 100)%): -S/. \(descuentoMonto)") // Imprime el descuento por monto
    if descuentoCupon > 0 { print("Descuento Cupón (20%): -S/. \(descuentoCupon)") } // Imprime el descuento por cupón si aplica
    print("IGV (18%): S/. \(igv)") // Imprime el valor del IGV calculated
    print("Costo de Envío: S/. \(costoEnvio)") // Imprime el costo de envío asignado
    print(separador) // Imprime línea divisora
    print("TOTAL A PAGAR: S/. \(totalFinal)") // Imprime la suma final total a pagar
    print("Puntos Ganados: \(puntosGanados) pts") // Imprime los puntos de fidelidad acumulados
    print(separador) // Imprime línea divisora inferior
    print("¡Gracias por su compra!") // Imprime el mensaje de despedida
} // Cierra el bloque principal de ejecución


// ==========================================
// ===== EJERCICIO 7: JUEGO ADIVINANZA ======
// ==========================================

let numeroSecreto = 42 // Establece el número clave que el jugador debe descubrir
let intentos = [20, 50, 40, 45, 42] // Define la secuencia de los 5 intentos simulados

var indice = 0 // Inicializa el puntero para recorrer la lista de intentos
var adivino = false // Controla el estado del juego indicando si acertó o no
var contadorIntentos = 0 // Almacena el número total de intentos realizados

while indice < intentos.count && !adivino { // Se ejecuta mientras queden intentos en el arreglo y no haya acertado
    let intentoActual = intentos[indice] // Extrae el número del intento correspondiente al índice actual
    contadorIntentos += 1 // Incrementa en 1 la cantidad de intentos consumidos
    
    print("Intento \(contadorIntentos): Probando con \(intentoActual)...") // Imprime el intento en curso
    
    if intentoActual == numeroSecreto { // Compara si el intento es idéntico al número secreto
        print("¡Correcto! Adivinaste el número en \(contadorIntentos) intento(s).") // Mensaje de éxito si acierta
        adivino = true // Cambia la bandera a true para salir del bucle
    } else if intentoActual < numeroSecreto { // Evalúa si el intento es inferior al número buscado
        print(" -> Muy bajo.") // Informa que la pista requiere un valor mayor
    } else { // Entra aquí cuando el intento es superior al número secreto
        print(" -> Muy alto.") // Informa que la pista requiere un valor menor
    } // Cierra las comparaciones condicionales
    
    indice += 1 // Avanza al siguiente elemento del arreglo de intentos
} // Cierra la ejecución del bucle while

if !adivino { // Verifica si el bucle terminó sin haber adivinado
    print("Perdiste. El número era: \(numeroSecreto)") // Notifica la derrota al agotar los intentos
} // Cierra la verificación final de derrota
