// Desarrollado por: Adriana Chinchayhuara
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
