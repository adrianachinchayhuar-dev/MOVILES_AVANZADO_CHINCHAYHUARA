// ==========================================
// EJERCICIO 6: GESTION DE NOTAS
// Desarrollado por: Adriana Chinchayhuara
// ==========================================

import Foundation

// TODO 8: Pedir N alumnos con nombre y 3 notas -> diccionario [String: [Double]]
var registroAlumnos: [String: [Double]] = [:] // Inicializa el diccionario vacío con clave String y valor Array de Doubles

print("¿Cuántos alumnos desea registrar?") // Solicita la cantidad de alumnos a ingresar
let cantidadAlumnos = Int(readLine() ?? "") ?? 0 // Lee la entrada, la convierte a Int o asigna 0 por defecto

if cantidadAlumnos > 0 { // Valida que la cantidad ingresada sea mayor a 0
    for i in 1...cantidadAlumnos { // Itera desde 1 hasta el total de alumnos solicitados
        print("\nNombre del alumno \(i):") // Muestra en consola el número de alumno
        let nombreAlumno = readLine() ?? "Sin Nombre" // Lee el nombre del alumno o asigna un valor genérico
        var notasAlumno: [Double] = [] // Crea un arreglo temporal para almacenar las 3 notas
        
        for n in 1...3 { // Bucle para solicitar exactamente 3 notas por alumno
            print("  Ingrese nota \(n):") // Solicita el número de nota correspondiente
            let nota = Double(readLine() ?? "") ?? 0.0 // Lee y convierte la nota a Double o asigna 0.0
            notasAlumno.append(nota) // Agrega la nota leída al arreglo de notas
        }
        
        registroAlumnos[nombreAlumno] = notasAlumno // Almacena el arreglo de notas en el diccionario usando el nombre como clave
    }
}

