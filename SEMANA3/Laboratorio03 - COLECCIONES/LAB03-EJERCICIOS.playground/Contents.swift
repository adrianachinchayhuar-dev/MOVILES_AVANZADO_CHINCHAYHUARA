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


// ==========================================
// EJERCICIO 4: COMBINACIÓN DE COLECCIONES
// Desarrollado por: Adriana Chinchayhuara
// ==========================================

import Foundation

// Pide N productos con nombre, precio y stock
var precios: [String: Double] = [:]
var stocks: [String: Int] = [:]

print("¿Cuántos productos?")
let entrada = readLine() ?? ""
let n = Int(entrada) ?? 3 // Si no ingresas nada, usa 3 por defecto

if n > 0 {
    for i in 1...n {
        print("Producto \(i) - Nombre:")
        let nombre = readLine() ?? "Producto_\(i)"
        print("Precio:")
        let precio = Double(readLine() ?? "") ?? 10.0
        print("Stock:")
        let stock = Int(readLine() ?? "") ?? 2
        precios[nombre] = precio
        stocks[nombre] = stock
    }
}

// TODO: Calcular valor total (precio * stock)
// TODO: Mostrar productos con stock < 5

print("\n===== REPORTE DE INVENTARIO =====")
var valorTotalInventario: Double = 0.0

for (producto, precio) in precios {
    if let stock = stocks[producto] {
        let subtotal = precio * Double(stock)
        valorTotalInventario += subtotal
        
        let advertenciaStock = stock < 5 ? " [ALERTA: Stock bajo]" : ""
        print("\(producto): Precio: S/ \(precio) | Stock: \(stock) | Subtotal: S/ \(subtotal)\(advertenciaStock)")
    }
}

print("\nValor total del inventario: S/ \(valorTotalInventario)")

print("\n===== PRODUCTOS CON STOCK BAJO (< 5) =====")
for (producto, stock) in stocks {
    if stock < 5 {
        print("- \(producto): \(stock) unidades")
    }
}


// ==========================================
// EJERCICIO 5: CARRITO DE COMPRAS 2.0
// Desarrollado por: Adriana Chinchayhuara
// ==========================================

import Foundation

// ===== CARRITO DE COMPRAS 2.0 =====
var listaNombres: [String] = []
var listaPrecios: [Double] = []
var listaCantidades: [Int] = []

// TODO 11: Pedir productos
print("¿Cuántos productos va a comprar?")
let totalProductos = Int(readLine() ?? "") ?? 0

if totalProductos > 0 {
    for i in 1...totalProductos {
        print("\nProducto \(i) - Nombre:")
        listaNombres.append(readLine() ?? "")
        print("Precio unitario:")
        listaPrecios.append(Double(readLine() ?? "") ?? 0.0)
        print("Cantidad:")
        listaCantidades.append(Int(readLine() ?? "") ?? 0)
    }
}

// TODO 12: Calcular subtotales
var listaSubtotales: [Double] = []
for i in 0..<listaNombres.count {
    let sub = listaPrecios[i] * Double(listaCantidades[i])
    listaSubtotales.append(sub)
}

// TODO 13: Total del carrito
var totalCarrito = 0.0
for sub in listaSubtotales {
    totalCarrito += sub
}

// TODO 14: Nombre del cliente
print("\nNombre del cliente:")
let cliente = readLine() ?? ""

// TODO 15: Descuento
var descPct = 0.0
if totalCarrito >= 5000 { descPct = 0.15 }
else if totalCarrito >= 2000 { descPct = 0.10 }
else if totalCarrito >= 500 { descPct = 0.05 }

let descuento = totalCarrito * descPct
let totalConDesc = totalCarrito - descuento

// TODO 16: IGV y total
let igv = totalConDesc * 0.18
let totalFinal = totalConDesc + igv

// TODO 17: Categoría
var categoria = ""
switch Int(totalCarrito) {
case 0..<500: categoria = "Regular"
case 500..<2000: categoria = "Frecuente"
case 2000..<5000: categoria = "VIP"
default: categoria = "Premium"
}

// TODO 18: Ticket
let sep = String(repeating: "=", count: 45)
print(sep)
print("       TICKET DE COMPRA 2.0")
print("Cliente: \(cliente) (\(categoria))")
print(sep)

for i in 0..<listaNombres.count {
    print("\(listaNombres[i]) x\(listaCantidades[i])   S/. \(listaSubtotales[i])")
}

print(sep)
print("Subtotal:            S/. \(totalCarrito)")

if descPct > 0 {
    print("Descuento (\(descPct * 100)%): -S/. \(descuento)")
}

print("IGV (18%):           S/. \(igv)")
print(sep)
print("TOTAL:               S/. \(totalFinal)")
print(sep)
print("¡Gracias por su compra, \(cliente)!")
