import Foundation
import CoreData

// Prueba independiente del target iOS. Solo utiliza un SQLite temporal con el modelo real.
@main
struct IndicadoresResumenTests {
    static func main() throws {
        let modeloURL = URL(fileURLWithPath: CommandLine.arguments[1])
        guard let modelo = NSManagedObjectModel(contentsOf: modeloURL) else { fatalError("Modelo no encontrado") }
        for entidad in modelo.entities { entidad.managedObjectClassName = "NSManagedObject" }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("resumen-\(UUID().uuidString).sqlite")
        let coordinador = NSPersistentStoreCoordinator(managedObjectModel: modelo)
        try coordinador.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
        let escritura = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        escritura.persistentStoreCoordinator = coordinador

        func consultar() throws -> IndicadoresResumen {
            let lectura = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            lectura.persistentStoreCoordinator = coordinador
            return try IndicadoresResumen.consultar(en: lectura)
        }
        func comprobar(_ indicadores: IndicadoresResumen, productos: Int, clientes: Int,
                       registradas: Int, efectivas: Int, anuladas: Int, ingresos: String) {
            precondition(indicadores.productos == productos)
            precondition(indicadores.clientes == clientes)
            precondition(indicadores.ventasRegistradas == registradas)
            precondition(indicadores.ventasEfectivas == efectivas)
            precondition(indicadores.ventasAnuladas == anuladas)
            precondition(indicadores.ventasRegistradas == indicadores.ventasEfectivas + indicadores.ventasAnuladas)
            precondition(indicadores.ingresosEfectivos == Decimal(string: ingresos)!)
        }
        let vacio = try consultar()
        comprobar(vacio, productos: 0, clientes: 0, registradas: 0, efectivas: 0, anuladas: 0, ingresos: "0")
        precondition(vacio.ingresosFormateados == "S/ 0.00")

        let supervisor = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: escritura)
        supervisor.setValue("Supervisor", forKey: "rol")
        let vendedor = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: escritura)
        vendedor.setValue("Vendedor", forKey: "rol")
        let cliente = NSEntityDescription.insertNewObject(forEntityName: "Cliente", into: escritura)
        let producto = NSEntityDescription.insertNewObject(forEntityName: "Producto", into: escritura)
        producto.setValue(Int64(20), forKey: "stock")
        _ = NSEntityDescription.insertNewObject(forEntityName: "Producto", into: escritura)
        try escritura.save()
        comprobar(try consultar(), productos: 2, clientes: 1, registradas: 0, efectivas: 0, anuladas: 0, ingresos: "0")

        func venta(_ total: Double, anulada: Bool) -> NSManagedObject {
            let venta = NSEntityDescription.insertNewObject(forEntityName: "Venta", into: escritura)
            venta.setValue(total, forKey: "total")
            venta.setValue(anulada, forKey: "anulada")
            venta.setValue(Int64(2), forKey: "cantidad")
            venta.setValue(cliente, forKey: "cliente")
            venta.setValue(producto, forKey: "producto")
            venta.setValue(vendedor, forKey: "vendedor")
            return venta
        }
        let primera = venta(100.10, anulada: false)
        let segunda = venta(200.20, anulada: false)
        try escritura.save()
        comprobar(try consultar(), productos: 2, clientes: 1, registradas: 2, efectivas: 2, anuladas: 0, ingresos: "300.30")
        _ = venta(999, anulada: true)
        try escritura.save()
        let mixto = try consultar()
        comprobar(mixto, productos: 2, clientes: 1, registradas: 3, efectivas: 2, anuladas: 1, ingresos: "300.30")
        precondition(mixto.ingresosFormateados == "S/ 300.30")

        // Ejecuta la misma operación A8 que utiliza el Supervisor, desde otro contexto.
        try AnulacionVenta.ejecutar(coordinador: coordinador, usuarioID: supervisor.objectID,
                                   ventaID: segunda.objectID, motivo: "Prueba aislada de indicadores")
        comprobar(try consultar(), productos: 2, clientes: 1, registradas: 3, efectivas: 1, anuladas: 2, ingresos: "100.10")
        try AnulacionVenta.ejecutar(coordinador: coordinador, usuarioID: supervisor.objectID,
                                   ventaID: primera.objectID, motivo: "Todas anuladas")
        comprobar(try consultar(), productos: 2, clientes: 1, registradas: 3, efectivas: 0, anuladas: 3, ingresos: "0")

        // Confirma que el Resumen es solo lectura y que los resultados persisten al reabrir SQLite.
        let lectura = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        lectura.persistentStoreCoordinator = coordinador
        _ = try IndicadoresResumen.consultar(en: lectura)
        precondition(!lectura.hasChanges)
        for store in coordinador.persistentStores { try coordinador.remove(store) }
        let reabierto = NSPersistentStoreCoordinator(managedObjectModel: modelo)
        try reabierto.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
        let contextoReabierto = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contextoReabierto.persistentStoreCoordinator = reabierto
        comprobar(try IndicadoresResumen.consultar(en: contextoReabierto), productos: 2, clientes: 1,
                  registradas: 3, efectivas: 0, anuladas: 3, ingresos: "0")
        print("OK: sin ventas, conteos reales, activas/anuladas, ingresos, anulación A8, todas anuladas, formato, solo lectura y persistencia.")
    }
}
