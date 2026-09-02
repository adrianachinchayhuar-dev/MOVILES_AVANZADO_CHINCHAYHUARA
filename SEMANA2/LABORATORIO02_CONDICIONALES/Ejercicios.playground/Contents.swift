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
