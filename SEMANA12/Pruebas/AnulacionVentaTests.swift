import Foundation
import CoreData

// Ejecutar fuera del target iOS, con AnulacionVenta.swift y la ruta a Ventas.mom.
// Todos los datos de prueba se crean en SQLite temporal, nunca en la app.
@main
struct AnulacionVentaTests {
    struct Entorno {
        let coordinador: NSPersistentStoreCoordinator
        let modelo: NSManagedObjectModel
        let url: URL
        let supervisorID: NSManagedObjectID
        let vendedorID: NSManagedObjectID
        let ventaID: NSManagedObjectID
    }

    static func crear(modeloURL: URL, limitarStock: Bool = false,
                      stock: Int64 = 7, cantidad: Int64 = 3) throws -> Entorno {
        guard let modelo = NSManagedObjectModel(contentsOf: modeloURL) else { fatalError("Modelo no encontrado") }
        for entidad in modelo.entities { entidad.managedObjectClassName = "NSManagedObject" }
        if limitarStock {
            modelo.entitiesByName["Producto"]!.attributesByName["stock"]!.setValidationPredicates(
                [NSPredicate(format: "SELF <= 7")], withValidationWarnings: ["Fallo de guardado deliberado en prueba"])
        }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("anulacion-\(UUID().uuidString).sqlite")
        let coordinador = NSPersistentStoreCoordinator(managedObjectModel: modelo)
        try coordinador.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
        let contexto = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contexto.persistentStoreCoordinator = coordinador
        let supervisor = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: contexto)
        supervisor.setValue("Supervisor", forKey: "rol")
        let vendedor = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: contexto)
        vendedor.setValue("Vendedor", forKey: "rol")
        let producto = NSEntityDescription.insertNewObject(forEntityName: "Producto", into: contexto)
        producto.setValue(stock, forKey: "stock")
        let venta = NSEntityDescription.insertNewObject(forEntityName: "Venta", into: contexto)
        venta.setValue(cantidad, forKey: "cantidad")
        venta.setValue(producto, forKey: "producto")
        venta.setValue(vendedor, forKey: "vendedor")
        venta.setValue(false, forKey: "anulada")
        try contexto.save()
        return Entorno(coordinador: coordinador, modelo: modelo, url: url,
                       supervisorID: supervisor.objectID, vendedorID: vendedor.objectID, ventaID: venta.objectID)
    }

    static func comprobar(_ entorno: Entorno, anulada: Bool, stock: Int64, motivo: String?) throws {
        let contexto = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contexto.persistentStoreCoordinator = entorno.coordinador
        let venta = try contexto.existingObject(with: entorno.ventaID)
        let producto = venta.value(forKey: "producto") as! NSManagedObject
        precondition((venta.value(forKey: "anulada") as! NSNumber).boolValue == anulada)
        precondition((producto.value(forKey: "stock") as! NSNumber).int64Value == stock)
        precondition(venta.value(forKey: "motivoAnulacion") as? String == motivo)
    }

    static func esperar(_ errorEsperado: AnulacionVenta.ErrorAnulacion, _ operacion: () throws -> Void) throws {
        do { try operacion(); fatalError("La operación debía rechazarse") }
        catch let error as AnulacionVenta.ErrorAnulacion { precondition(error == errorEsperado) }
    }

    static func main() throws {
        let modeloURL = URL(fileURLWithPath: CommandLine.arguments[1])
        let entorno = try crear(modeloURL: modeloURL)
        try esperar(.sinPermiso) {
            try AnulacionVenta.ejecutar(coordinador: entorno.coordinador, usuarioID: entorno.vendedorID,
                                       ventaID: entorno.ventaID, motivo: "Prueba")
        }
        try esperar(.motivoObligatorio) {
            try AnulacionVenta.ejecutar(coordinador: entorno.coordinador, usuarioID: entorno.supervisorID,
                                       ventaID: entorno.ventaID, motivo: " \n ")
        }
        try comprobar(entorno, anulada: false, stock: 7, motivo: nil)
        try AnulacionVenta.ejecutar(coordinador: entorno.coordinador, usuarioID: entorno.supervisorID,
                                   ventaID: entorno.ventaID, motivo: "  Pedido cancelado  ")
        try comprobar(entorno, anulada: true, stock: 10, motivo: "Pedido cancelado")
        try esperar(.yaAnulada) {
            try AnulacionVenta.ejecutar(coordinador: entorno.coordinador, usuarioID: entorno.supervisorID,
                                       ventaID: entorno.ventaID, motivo: "Segundo intento")
        }
        try comprobar(entorno, anulada: true, stock: 10, motivo: "Pedido cancelado")

        // Reabrir SQLite con otro coordinador prueba persistencia fuera del contexto de escritura.
        let uri = entorno.ventaID.uriRepresentation()
        for store in entorno.coordinador.persistentStores { try entorno.coordinador.remove(store) }
        let nuevoCoordinador = NSPersistentStoreCoordinator(managedObjectModel: entorno.modelo)
        try nuevoCoordinador.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: entorno.url)
        let lectura = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        lectura.persistentStoreCoordinator = nuevoCoordinador
        let persistida = try lectura.existingObject(with: nuevoCoordinador.managedObjectID(forURIRepresentation: uri)!)
        precondition((persistida.value(forKey: "anulada") as! NSNumber).boolValue)
        precondition(persistida.value(forKey: "motivoAnulacion") as? String == "Pedido cancelado")
        precondition(((persistida.value(forKey: "producto") as! NSManagedObject).value(forKey: "stock") as! NSNumber).int64Value == 10)

        let fallo = try crear(modeloURL: modeloURL, limitarStock: true)
        do {
            try AnulacionVenta.ejecutar(coordinador: fallo.coordinador, usuarioID: fallo.supervisorID,
                                       ventaID: fallo.ventaID, motivo: "Debe revertirse")
            fatalError("Debía fallar el save")
        } catch { /* Error deliberado de validación durante save(). */ }
        try comprobar(fallo, anulada: false, stock: 7, motivo: nil)

        let limite = try crear(modeloURL: modeloURL, stock: Int64.max)
        try esperar(.stockInvalido) {
            try AnulacionVenta.ejecutar(coordinador: limite.coordinador, usuarioID: limite.supervisorID,
                                       ventaID: limite.ventaID, motivo: "Desbordamiento")
        }
        try comprobar(limite, anulada: false, stock: Int64.max, motivo: nil)
        let cantidadInvalida = try crear(modeloURL: modeloURL, cantidad: 0)
        try esperar(.stockInvalido) {
            try AnulacionVenta.ejecutar(coordinador: cantidadInvalida.coordinador, usuarioID: cantidadInvalida.supervisorID,
                                       ventaID: cantidadInvalida.ventaID, motivo: "Cantidad inválida")
        }
        try comprobar(cantidadInvalida, anulada: false, stock: 7, motivo: nil)
        print("OK: permisos, motivo, stock exacto, doble anulación, persistencia SQLite, rollback, desbordamiento y cantidad inválida.")
    }
}
