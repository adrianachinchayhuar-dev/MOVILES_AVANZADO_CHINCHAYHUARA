import Foundation

// TODO 12: Pedir N productos con nombre, precio y stock
var inventarioNombres: [String] = [] // Arreglo para guardar los nombres de los productos
var inventarioPrecios: [Double] = [] // Arreglo para guardar los precios unitarios
var inventarioStock: [Int] = [] // Arreglo para guardar el stock disponible

print("¿Cuántos productos registrará en el inventario?") // Muestra mensaje en pantalla
let totalProductosInv = Int(readLine() ?? "") ?? 0 // Lee la cantidad total de productos a ingresar

if totalProductosInv > 0 { // Verifica que se ingrese al menos 1 producto
    for i in 1...totalProductosInv { // Bucle que se repite la cantidad de veces indicada
        print("\n--- Producto \(i) ---") // Imprime el número del producto actual
        print("Nombre:") // Solicita el nombre del producto
        let nombre = readLine() ?? "Producto Sin Nombre" // Lee el nombre o asigna valor por defecto
        
        print("Precio unitario:") // Solicita el precio del producto
        let precio = Double(readLine() ?? "") ?? 0.0 // Lee y convierte a Double o asigna 0.0
        
        print("Stock inicial:") // Solicita las unidades disponibles
        let stock = Int(readLine() ?? "") ?? 0 // Lee y convierte a Int o asigna 0
        
        inventarioNombres.append(nombre) // Agrega el nombre ingresado al arreglo
        inventarioPrecios.append(precio) // Agrega el precio ingresado al arreglo
        inventarioStock.append(stock) // Agrega el stock ingresado al arreglo
    }
}

