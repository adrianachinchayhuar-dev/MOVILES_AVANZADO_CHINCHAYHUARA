// Desarrollado por: [TU NOMBRE]
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
