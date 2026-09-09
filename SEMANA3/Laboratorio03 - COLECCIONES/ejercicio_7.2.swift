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


// TODO 13 y 14: Menú interactivo con ciclo while y reportes formateados
var opcion = 0 // Variable para controlar la opción seleccionada por el usuario

while opcion != 5 { // El ciclo se repite hasta que el usuario elija la opción 5 (Salir)
    print("\n" + String(repeating: "=", count: 40)) // Imprime una línea divisoria para dar formato
    print("        MENÚ DE GESTIÓN DE INVENTARIO") // Título del menú
    print(String(repeating: "=", count: 40)) // Imprime otra línea divisoria
    print("1) Ver inventario completo") // Opción 1 para listar todos los productos
    print("2) Buscar producto") // Opción 2 para buscar un producto específico
    print("3) Alerta de stock bajo (menor a 5)") // Opción 3 para filtrar productos con stock escaso
    print("4) Valor total del inventario") // Opción 4 para calcular la suma del valor comercial
    print("5) Salir") // Opción 5 para finalizar el programa
    print("Seleccione una opción:") // Pide la elección del usuario
    
    opcion = Int(readLine() ?? "") ?? 0 // Lee y convierte la opción ingresada a un entero
    
    switch opcion { // Evalúa la opción elegida mediante un switch
    case 1: // CASO 1: Ver inventario completo
        print("\n--- INVENTARIO COMPLETO ---") // Encabezado de la lista
        if inventarioNombres.isEmpty { // Comprueba si el inventario está vacío
            print("El inventario está vacío.") // Informa que no hay datos
        } else { // Si contiene elementos, procede a iterar
            for i in 0..<inventarioNombres.count { // Recorre todos los índices guardados
                print("[\(i + 1)] Nombre: \(inventarioNombres[i]) | Precio: S/. \(inventarioPrecios[i]) | Stock: \(inventarioStock[i]) und.") // Imprime detalles formateados
            }
        }
        
    case 2: // CASO 2: Buscar producto por nombre
        print("\nIngrese el nombre del producto a buscar:") // Pide el criterio de búsqueda
        let terminoBusqueda = (readLine() ?? "").lowercased() // Convierte el término ingresado a minúsculas
        var encontrado = false // Bandera para saber si se halló el producto
        
        for i in 0..<inventarioNombres.count { // Recorre la lista de productos
            if inventarioNombres[i].lowercased().contains(terminoBusqueda) { // Compara si el nombre coincide o contiene el texto
                print("-> Hallado: \(inventarioNombres[i]) - Precio: S/. \(inventarioPrecios[i]) - Stock: \(inventarioStock[i]) und.") // Muestra los detalles del producto hallado
                encontrado = true // Cambia la bandera a verdadero
            }
        }
        if !encontrado { // Si la bandera permanece en falso
            print("No se encontró ningún producto con ese nombre.") // Notifica que no hubo coincidencias
        }
        
    case 3: // CASO 3: Stock bajo
        print("\n--- PRODUCTOS CON STOCK BAJO (< 5) ---") // Encabezado de alerta
        var hayStockBajo = false // Bandera para indicar si existen productos en estado crítico
        
        for i in 0..<inventarioNombres.count { // Recorre los elementos guardados
            if inventarioStock[i] < 5 { // Evalúa si la cantidad en stock es menor a 5
                print("⚠ Alerta: \(inventarioNombres[i]) tiene solo \(inventarioStock[i]) unidades disponibles.") // Muestra alerta formateada
                hayStockBajo = true // Marca que se encontró al menos un caso de stock bajo
            }
        }
        if !hayStockBajo { // Si la bandera sigue en falso
            print("Todos los productos tienen un stock adecuado (5 o más unidades).") // Informa estado saludable
        }
        
    case 4: // CASO 4: Valor total del inventario
        var valorTotal = 0.0 // Variable acumuladora para el importe total
        for i in 0..<inventarioNombres.count { // Recorre los arreglos en paralelo
            let subtotalProducto = inventarioPrecios[i] * Double(inventarioStock[i]) // Multiplica precio unitario por el stock
            valorTotal += subtotalProducto // Suma el valor obtenido al acumulador
        }
        print("\n--- VALOR COMERCIAL TOTAL ---") // Encabezado de cálculo
        print("El valor total estimado del inventario es: S/. \(valorTotal)") // Imprime la suma acumulada

    case 5: // CASO 5: Salir del menú
        print("\nSaliendo del sistema de inventario... ¡Hasta luego!") // Mensaje de despedida

    default: // En caso de ingresar un número no listado
        print("\nOpción no válida. Por favor, ingrese un número del 1 al 5.") // Notifica error de selección
    }
}

