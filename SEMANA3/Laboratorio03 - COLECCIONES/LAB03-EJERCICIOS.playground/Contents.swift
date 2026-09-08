// ==========================================
// EJERCICIO 1: ARRAYS
// Desarrollado por: Adriana Chinchayhuara
// ==========================================
import Foundation

// ===== TODO1: Registro de 5 alumnos =====
var alumnos: [String] = []

for i in 1...5 {
    print("Nombre del alumno \(i): ")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}

print("Alumnos: \(alumnos)")


// ===== TODO2: Buscar un alumno =====
print("Buscar alumno: ")
let buscar = readLine() ?? ""

if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}


// ===== TODO3: Notas con clasificación =====
var notasClase: [Double] = []

for i in 1...5 {
    print("Nota del alumno \(i): ")
    let input = readLine() ?? ""
    let n = Double(input) ?? 0.0
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota
    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

if !notasClase.isEmpty {
    let promedio = sumaNotas / Double(notasClase.count)
    print("Promedio: \(promedio)")
}

print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)")



// ===== FIX: 3 errores =====

var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Uva") // FIX 1: Se debe agregar un String, no un Int (7), ya que el arreglo es de tipo [String].

var colores = ["Rojo", "Azul", "Verde"] // FIX 2: Se debe cambiar 'let' a 'var' para poder modificar el arreglo con .append().
colores.append("Amarillo")

let numeros = [10, 20, 30, 40, 50]
print(numeros[4]) // FIX 3: El índice 5 está fuera de rango (Out of bounds). Los índices van de 0 a 4; para ver el último elemento usamos [4] o [numeros.count - 1].


var lista = [1, 2, 3, 4, 5]
lista.remove(at: 0) // Quita el 1, queda [2, 3, 4, 5]
lista.append(6)      // Agrega el 6 al final, queda [2, 3, 4, 5, 6]

print(lista)       // PREDICT 1: [2, 3, 4, 5, 6]
print(lista.count) // PREDICT 2: 5

var nombres = ["Ana", "Carlos", "Beto"]
print(nombres.sorted()) // PREDICT 3: ["Ana", "Beto", "Carlos"]
print(nombres)          // PREDICT 4: ["Ana", "Carlos", "Beto"]



// ==========================================
// EJERCICIO 2: DICCIONARIOS
// Desarrollado por: Adriana Chinchayhuara
// ==========================================

import Foundation

// ===== TODO 4: Catálogo de productos =====
var productos: [String: Double] = [:]
for i in 1...4 {
    print("Producto \(i) - Nombre:")
    let nombre = readLine() ?? ""
    print("Precio:")
    let precio = Double(readLine() ?? "") ?? 0
    productos[nombre] = precio
}

// ===== TODO 5: Mostrar catálogo =====
print("===== CATÁLOGO =====")
for (nombre, precio) in productos {
    print("\(nombre): S/. \(precio)")
}

// ===== TODO 6: Valor total =====
var valorTotal = 0.0
for (_, precio) in productos {
    valorTotal += precio
}
print("Valor total: S/. \(valorTotal)")

// ===== TODO 7: Buscar producto =====
print("Buscar producto:")
let buscarProd = readLine() ?? ""
if let precioEncontrado = productos[buscarProd] {
    print("\(buscarProd) cuesta S/. \(precioEncontrado)")
} else {
    print("Producto no encontrado")
}


// ===== ANALYZE =====

var edades: [String: Int] = ["Ana": 20, "Luis": 22, "María": 19]
var mayores: [String] = []
for (nombre, edad) in edades {
    if edad >= 21 {
        mayores.append(nombre)
    }
}
print("Mayores de 21: \(mayores)")

// ANALYZE 1:
// ¿Qué hace?: Filtra el diccionario llamado 'edades' recorriendo cada persona dentro del diccionario y guarda en el arreglo 'mayores' solo los nombres de quienes tienen 21 años o más.
// ¿Qué imprime?: En este caso imprime a los que son mayores de 21: ["Luis"]



// ==========================================
// EJERCICIO 3: SETS (CONJUNTOS)
// Desarrollado por: Adriana Chinchayhuara
// ==========================================

import Foundation

// ===== TODO 8: Eliminar duplicados =====
var misNumeros: [Int] = []
for i in 1...8 {
    print("Número \(i):")
    let n = Int(readLine() ?? "") ?? 0
    misNumeros.append(n)
}

print("Con duplicados: \(misNumeros)")
let sinDuplicados = Array(Set(misNumeros)).sorted()
print("Sin duplicados: \(sinDuplicados)")


// ===== TODO 9: Comparar asistencia =====
// Pide 4 nombres lunes, 4 martes
// Muestra: ambos días, solo lunes, solo martes

var lunes: Set<String> = []
print("\n===== ASISTENCIA LUNES =====")
for i in 1...4 {
    print("Nombre \(i):")
    let nombre = readLine() ?? ""
    lunes.insert(nombre)
}

var martes: Set<String> = []
print("\n===== ASISTENCIA MARTES =====")
for i in 1...4 {
    print("Nombre \(i):")
    let nombre = readLine() ?? ""
    martes.insert(nombre)
}

let ambosDias = lunes.intersection(martes)
let soloLunes = lunes.subtracting(martes)
let soloMartes = martes.subtracting(lunes)

print("\n===== RESULTADOS =====")
print("Ambos días: \(ambosDias)")
print("Solo lunes: \(soloLunes)")
print("Solo martes: \(soloMartes)")



// ===== PREDICT (5-6-7-8) =====

let a: Set = [1, 2, 3, 4, 5]
let b: Set = [4, 5, 6, 7, 8]

print(a.intersection(b))     // PREDICT 5: [4, 5] - Retorna los elementos presentes en ambos conjuntos
print(a.union(b).count)      // PREDICT 6: 8 - Unifica ambos conjuntos sin repetir elementos (1 al 8) y cuenta el total
print(a.subtracting(b))     // PREDICT 7: [1, 2, 3] - Toma los elementos de 'a' y remueve los que también están en 'b'

var repetidos: Set = ["A", "B", "A", "C", "B"]
print(repetidos.count)       // PREDICT 8: 3 - El Set elimina duplicados automáticamente, dejando solo ["A", "B", "C"]
