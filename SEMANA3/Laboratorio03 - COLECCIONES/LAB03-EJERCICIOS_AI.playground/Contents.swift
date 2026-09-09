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

// TODO 9: Promedio por alumno y clasificación con switch
var promediosPorAlumno: [String: Double] = [:] // Diccionario auxiliar para almacenar los promedios de cada alumno

for (alumno, notas) in registroAlumnos { // Itera sobre cada par clave-valor del diccionario de registro
    let sumaNotas = notas.reduce(0, +) // Suma todos los elementos del arreglo de notas
    let promedio = sumaNotas / Double(notas.count) // Calcula el promedio dividiendo entre el total de notas
    promediosPorAlumno[alumno] = promedio // Guarda el promedio calculado asociado al nombre del alumno
    
    var clasificacion = "" // Variable para almacenar el estado/categoría del alumno
    switch promedio { // Evalúa la nota promedio en diferentes rangos
    case 18.0...20.0: // Rango de excelencia
        clasificacion = "Excelente" // Asigna la categoría Excelente
    case 14.0..<18.0: // Rango para buen desempeño
        clasificacion = "Bueno" // Asigna la categoría Bueno
    case 11.0..<14.0: // Rango aprobatorio mínimo
        clasificacion = "Aprobado" // Asigna la categoría Aprobado
    default: // Para notas menores a 11.0
        clasificacion = "Desaprobado" // Asigna la categoría Desaprobado
    }
    print("Alumno: \(alumno) - Promedio: \(promedio) - Estado: \(clasificacion)") // Imprime la información procesada
}

// TODO 10: Estadísticas generales (Promedio general, nota más alta/baja, % aprobados)
var sumaPromedios = 0.0 // Acumulador para la suma de todos los promedios
var notaMasAlta = -1.0 // Variable para rastrear la nota más alta encontrada
var notaMasBaja = 21.0 // Variable para rastrear la nota más baja encontrada
var conteoAprobados = 0 // Contador de alumnos aprobados (promedio >= 11.0)

for (_, notas) in registroAlumnos { // Recorre únicamente los arreglos de notas del diccionario
    for nota in notas { // Itera sobre cada nota individual
        if nota > notaMasAlta { notaMasAlta = nota } // Actualiza la nota más alta si la actual la supera
        if nota < notaMasBaja { notaMasBaja = nota } // Actualiza la nota más baja si la actual es menor
    }
}

for (_, promedio) in promediosPorAlumno { // Recorre todos los promedios del grupo
    sumaPromedios += promedio // Acumula el promedio al total
    if promedio >= 11.0 { conteoAprobados += 1 } // Incrementa el contador si el promedio es aprobatorio
}

let totalEstudiantes = Double(promediosPorAlumno.count) // Obtiene el total de alumnos procesados
let promedioGeneral = totalEstudiantes > 0 ? (sumaPromedios / totalEstudiantes) : 0.0 // Calcula el promedio general del grupo
let porcentajeAprobados = totalEstudiantes > 0 ? (Double(conteoAprobados) / totalEstudiantes) * 100.0 : 0.0 // Calcula el porcentaje de aprobados

print("\n--- ESTADÍSTICAS GENERALES ---") // Encabezado de sección
print("Promedio General del grupo: \(promedioGeneral)") // Imprime el promedio global
print("Nota más alta registrada: \(notaMasAlta)") // Imprime la nota más alta
print("Nota más baja registrada: \(notaMasBaja)") // Imprime la nota más baja
print("Porcentaje de aprobados: \(porcentajeAprobados)%") // Imprime el porcentaje final


// TODO 11: Ordenar por promedio de mayor a menor
let alumnosOrdenados = promediosPorAlumno.sorted { $0.value > $1.value } // Ordena la colección por el valor del promedio en orden descendente

print("\n--- ALUMNOS ORDENADOS POR PROMEDIO ---") // Encabezado de sección
for (posicion, item) in alumnosOrdenados.enumerated() { // Itera obteniendo el índice y el par (alumno, promedio)
    print("\(posicion + 1). \(item.key): \(item.value)") // Muestra la posición, nombre y promedio ordenado
}
