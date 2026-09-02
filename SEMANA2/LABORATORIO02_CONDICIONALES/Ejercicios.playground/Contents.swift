import Foundation
//Docente : Juan León S.

// ===== EJERCICIO 1: CONDICIONALES =====

// --- Ejemplo (ya resuelto): ---
let nota = 15.0
if nota >= 13.0 {
    print("Aprobado con \(nota)")
} else {
    print("Desaprobado con \(nota)")
}

// --- TODO 1: Validar si una persona es mayor de edad ---
let edad = 17
if edad >= 18 {
    print("Es mayor de edad")
} else {
    print("Es menor de edad")
}

// --- TODO 2: Clasificar una nota con else if ---
let miNota = 17.0
// Categorías: Excelente (18-20), Bueno (15-17),
//              Aprobado (13-14), Desaprobado (0-12)
if miNota >= 19 {
    print("Muy bueno")
} else if miNota >= 16 {
    print("Bueno")
} else if miNota >= 13 {
    print("Aprobado")
} else {
    print("Desaprobado")
}

// --- TODO 3: Verificar si un número es positivo, negativo o cero ---
let numero = -2
// Escribe la estructura if / else if / else completa
if numero > 0 {
    print("Es positivo")
}else if numero < 0 {
    print("Es negativo")
}else {
    print("Es cero")
}


// ===== FIX: Encuentra y corrige los 3 errores =====

let temperatura = 35
if temperatura > 30 {
print("Hace calor")
} else if temperatura > 20 { // faltaba la llave
print("Clima agradable")
} else {
print("Hace frío")
}

let saldo = 100.0
let compra = 150.0
if saldo >= compra { // faltaba "=" para que el saldo sea igual a la compra
    print("Compra realizada")
} else {
    print("Saldo insuficiente: te faltan \(compra - saldo)") // se cambio a compra - saldo para tener el monto en positivo
}

let hora = 25
if hora >= 0 && hora < 12 {
    print("Buenos días")
} else if hora >= 12 && hora < 18 {
    print("Buenas tardes")
} else if hora >= 18 && hora <= 23 {
    print("Buenas noches")
} else {
    print("Hora inválida")
}


//      PREDICT: ¿Qué imprime cada bloque?

let x = 10
if x > 5 && x < 20 {
    print("Dentro del rango")
} else {
    print("Fuera del rango")
}                   // PREDICT 1: Dentro del rango

let y = 15
if y > 20 {
    print("Mayor que 20")
} else if y > 10 {
    print("Mayor que 10")
} else if y > 5 {
    print("Mayor que 5")
}                   // PREDICT 2: Mayor que 10
// ¿Por qué no imprime "Mayor que 5" también?
// porque primero pasa por orden de condicion, como cumplio y > 10 ignoro lo demas

let esLunes = true
let llueve = false
if esLunes && llueve {
    print("Lunes lluvioso")
} else if esLunes || llueve {
    print("Es lunes O llueve")
} else {
    print("Ni lunes ni llueve")
}                   // PREDICT 3: Es lunes o llueve


// ===== EJERCICIO 2: SWITCH =====
// --- Ejemplo : ---
let diaSemana = 3
switch diaSemana {
case 1: print("Lunes")
case 2: print("Martes")
case 3: print("Miércoles")
case 4: print("Jueves")
case 5: print("Viernes")
case 6: print("Sábado")
case 7: print("Domingo")
default: print("Día inválido")
}

//--- TODO 4: Clasificar nota numérica a letra ---
let notaSwitch = 16
switch notaSwitch {
case 18...20: print("A")
case 15...17: print("B")
case 13...14: print("C")
case 11...12: print("D")
case 0...10: print("F")
default: print("Nota inválida")
}

// --- TODO 5: Calculadora simple con switch ---
let num1 = 20.0
let num2 = 5.0
let operacion = "+"
switch operacion {
case "+": print("Resultado: \(num1 + num2)")
case "-": print("Resultado: \(num1 - num2)")
case "*": print("Resultado: \(num1 * num2)")
case "/":
    if num2 != 0 {
        print("Resultado: \(num1 / num2)")
    } else {
        print("Error: División por cero")
    }
// TODO: verificar que num2 no sea 0 antes de dividir

default: print("Operación no válida")
}

// --- TODO 6: Categoría de producto por precio ---
let precio = 350.0
// Categorías:  Económico (0-99), Medio (100-499),
//              Premium (500-999), Lujo (1000+)
// Usa switch con rangos para clasificar
switch precio {
case 0...99: print("Económico")
case 100...499: print("Medio")
case 500...999: print("Premium")
case 1000...: print("Lujo")
default: print("Precio inválido")
}


// PREDICT: ¿Qué imprime?
let mes = 2
switch mes {
case 1, 3, 5, 7, 8, 10, 12: print("31 días")
case 4, 6, 9, 11: print("30 días")
case 2: print("28 o 29 días")
default: print("Mes inválido")
}                       // PREDICT 4: 28 o 29 días

let letra: Character = "a"
switch letra {
case "a", "e", "i", "o", "u": print("Vocal")
default: print("Consonante")
}                       // PREDICT 5: Vocal


// ===== EJERCICIO 3: FOR-IN =====
// --- Ejemplo (ya resuelto): ---
// Imprime los números del 1 al 5:
for i in 1...5 {
print("Número: \(i)")
}

// --- TODO 7: Tabla de multiplicar del 7 ---
// Imprime: 7 x 1 = 7, 7 x 2 = 14, ... 7 x 12 = 84
for i in 1...12 {
print("7 x \(i) = \(i * 7)")
}

// --- TODO 8: Sumatoria del 1 al 100 ---
// Suma todos los números del 1 al 100
var suma = 0
for i in 1...100 {
suma = suma + i
}
print("La suma del 1 al 100 es: \(suma)") // Debe dar 5050

// --- TODO 9: Calcular el factorial de 8 ---
// Factorial: 8! = 8 × 7 × 6 × 5 × 4 × 3 × 2 × 1 = 40320
var factorial = 1
for i in 1...8 {
factorial = factorial * i
}
print("8! = \(factorial)")

// --- TODO 10: Patrón de asteriscos ---
// Imprime este patrón usando for anidados:
// *
// **
// ***
// ****
// *****
// Pista: usa String(repeating: "*", count: i)

var i: Int = 1
while i <= 5 {
    print(String(repeating: "*", count: i))
    i += 1
}


// ===== FIX: Encuentra los 2 errores =====

// Se quiere imprimir los números pares del 2 al 20:
for i in 1...20 {
    if i % 2 == 0 {         // FIX 4: ¿Imprime pares o impares?
        print(i)            // pares, se cambio a 0 el 1 en if i % 2 == ___
    }
}

// Se quiere contar del 10 al 1 (cuenta regresiva):
for i in stride(from: 10, through: 1, by: -1) { // FIX 5: ¿Cuenta hacia adelante o atrás?
    print(i)            // Cuenta hacua atras
}
// Pista: busca "stride" en Swift


// PREDICT: ¿Cuántas veces se ejecuta y qué imprime al final?

var total = 0
for i in 1...5 {
    total += i
}
print(total)    // PREDICT 6: ¿Valor? 15 ¿Cuántas iteraciones? 5 iteraciones en el que se suman

var texto = ""
for _ in 1...3 {
    texto += "Hola "
}
print(texto)    // PREDICT 7: Hola Hola Hola
// ¿Para qué sirve _ en vez de i?
// Sirve como comodin cuando no vamos a utilizar la variable dentro del bucle


// ===== EJERCICIO 4: WHILE =====

// --- Ejemplo (ya resuelto): ---
var contador = 5
while contador > 0 {
    print("Cuenta regresiva: \(contador)")
    contador -= 1 // Resta 1 en cada vuelta
}
print("¡Despegue!")

// --- TODO 11: Ahorro mensual ---
// Un alumno ahorra S/. 150 cada mes.
// ¿Cuántos meses necesita para juntar S/. 2000?
var ahorro = 0.0
var meses = 0
let meta = 2000.0
let ahorroMensual = 150.0
while ahorro < meta {
    ahorro += ahorroMensual
    meses += 1
}
print("Necesita \(meses) meses para juntar S/. \(meta)")

// --- TODO 12: División sucesiva ---
// Divide un número entre 2 repetidamente hasta que sea menor a 1
// --- TODO 12: División sucesiva ---
do {
    var numero = 1000.0
    var divisiones = 0
    while numero >= 1 {
        numero = numero / 2
        divisiones += 1
        print("División \(divisiones): \(numero)")
    }
    print("Se dividió \(divisiones) veces")
}

// --- TODO 13: Validar datos con repeat-while ---
// Simula pedir una nota hasta que sea válida (entre 0 y 20)
// Usamos valores fijos porque no podemos pedir input en Playground

// let notasIngresadas = [25, -3, 15] // NO uses esto (es array, semana 3)
// En su lugar, simula con variables:
let intento1 = 25 // Inválido: > 20
let intento2 = -3 // Inválido: < 0
let intento3 = 15 // Válido

var intentoActual = intento1
var esValido = false
var numIntento = 1

repeat {
    // TODO: Verifica si intentoActual está entre 0 y 20
    if intentoActual >= 0 && intentoActual <= 20 {
        esValido = true
        print("Nota \(intentoActual) válida en intento \(numIntento)")
    } else {
        print("Nota \(intentoActual) inválida, intento \(numIntento)")
        // Simula el siguiente intento:
        if numIntento == 1 { intentoActual = intento2 }
        if numIntento == 2 { intentoActual = intento3 }
        numIntento += 1
    }
} while !esValido


// PREDICT: ¿Cuántas veces se ejecuta cada bucle?

var a = 100
while a > 1 {
    a = a / 3
}
print(a)    // PREDICT 8: ¿Valor final? 1 ¿Cuántas vueltas? 4

var b = 0
repeat {
    b += 1
} while b < 0
print(b)    // PREDICT 9: ¿Valor? 1
// ¿Por qué repeat-while ejecuta al menos una vez?
// porque siempre ejecuta al menos una vez antes de evaluar la condicion


// ===== EJERCICIO 5: CARRITO DE COMPRAS =====
// --- Datos de productos (ya definidos): ---
let prod1 = "Laptop"
let precio1 = 3500.0
let cant1 = 1

let prod2 = "Mouse"
let precio2 = 45.50
let cant2 = 2

let prod3 = "Teclado"
let precio3 = 120.00
let cant3 = 1

let prod4 = "Monitor"
let precio4 = 890.00
let cant4 = 1

let prod5 = "USB Cable"
let precio5 = 15.00
let cant5 = 3


// --- TODO 14: Calcula el subtotal de cada producto ---
let sub1 = precio1 * Double(cant1)
let sub2 = precio2 * Double(cant2)
let sub3 = precio3 * Double(cant3)
let sub4 = precio4 * Double(cant4)
let sub5 = precio5 * Double(cant5)

// --- TODO 15: Calcula el subtotal general ---
let subtotalGeneral = sub1 + sub2 + sub3 + sub4 + sub5


// --- TODO 16: Aplica descuento según monto de compra ---
// Reglas:
// Compra >= 5000 → 15% de descuento
// Compra >= 2000 → 10% de descuento
// Compra >= 500 → 5% de descuento
// Compra < 500 → sin descuento

var porcentajeDescuento = 0.0
if subtotalGeneral >= 5000 {
    porcentajeDescuento = 0.15
} else if subtotalGeneral >= 2000 {
    porcentajeDescuento = 0.10
} else if subtotalGeneral >= 500 {
    porcentajeDescuento = 0.05
} else {
    porcentajeDescuento = 0.0
}

let descuento = subtotalGeneral * porcentajeDescuento
let subtotalConDescuento = subtotalGeneral - descuento


// --- TODO 17: Categoría de cliente según monto ---
// Usa switch con rangos para determinar la categoría:
//  0 - 499: "Regular"
//  500 - 1999: "Frecuente"
//  2000 - 4999: "VIP"
//  5000+: "Premium"

let montoParaCategoria = Int(subtotalGeneral)
var categoriaCliente = ""
switch montoParaCategoria {
case 0..<500: categoriaCliente = "Regular"
case 500..<2000: categoriaCliente = "Frecuente"
case 2000..<5000: categoriaCliente = "VIP"
default: categoriaCliente = "Premium"
}


// --- TODO 18: Calcula IGV y total ---
let igv = subtotalConDescuento * 0.18
let totalFinal = subtotalConDescuento + igv


// --- TODO 19: Imprime el ticket de compra ---
// Usa un bucle for para imprimir la línea separadora
// y print con interpolación para los datos

var separador = ""
for _ in 1...40 {
    separador += "="
    print(separador)
    print(" TICKET DE COMPRA")
    print(" Cliente: \(categoriaCliente)")
    print(separador)
    print("\(prod1) x\(cant1) S/. \(sub1)")
    print("\(prod2) x\(cant2) S/. \(sub2)")
    print("\(prod3) x\(cant3) S/. \(sub3)")
    print("\(prod4) x\(cant4) S/. \(sub4)")
    print("\(prod5) x\(cant5) S/. \(sub5)")
    // TODO: imprime los demás productos
    print(separador)
    print("Subtotal: S/. \(subtotalGeneral)")
    print("Descuento (\(porcentajeDescuento * 100)%): -S/. \(descuento)")
    print("Subtotal c/desc: S/. \(subtotalConDescuento)")
    print("IGV (18%): S/. \(igv)")
    print(separador)
    print("TOTAL: S/. \(totalFinal)")
    print(separador)
    print("¡Gracias por su compra!")
}
