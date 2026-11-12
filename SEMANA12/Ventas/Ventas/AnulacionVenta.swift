import Foundation
import CoreData

// Contexto exclusivo por operación: no guarda ni revierte cambios de otras pantallas.
enum AnulacionVenta {
    enum ErrorAnulacion: LocalizedError, Equatable {
        case motivoObligatorio, sinPermiso, ventaInexistente, yaAnulada, productoInexistente, stockInvalido
        var errorDescription: String? {
            switch self {
            case .motivoObligatorio: return "Escribe un motivo de anulación."
            case .sinPermiso: return "Solo un Supervisor autenticado puede anular ventas."
            case .ventaInexistente: return "La venta ya no está disponible. Actualiza el listado."
            case .yaAnulada: return "Esta venta ya fue anulada. No se devolvió stock nuevamente."
            case .productoInexistente: return "No se puede devolver el stock porque el producto no está disponible."
            case .stockInvalido: return "No se puede devolver el stock: revisa la cantidad vendida y el stock del producto."
            }
        }
    }

    static func ejecutar(coordinador: NSPersistentStoreCoordinator, usuarioID: NSManagedObjectID,
                         ventaID: NSManagedObjectID, motivo: String) throws {
        let motivoLimpio = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !motivoLimpio.isEmpty else { throw ErrorAnulacion.motivoObligatorio }
        guard !usuarioID.isTemporaryID else { throw ErrorAnulacion.sinPermiso }
        guard !ventaID.isTemporaryID else { throw ErrorAnulacion.ventaInexistente }
        let contexto = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        contexto.persistentStoreCoordinator = coordinador
        // Un conflicto concurrente cancela toda la operación; nunca sobrescribe otro stock.
        contexto.mergePolicy = NSErrorMergePolicy
        try contexto.performAndWait {
            func consultar(_ entidad: String, _ id: NSManagedObjectID) throws -> NSManagedObject? {
                let solicitud = NSFetchRequest<NSManagedObject>(entityName: entidad)
                solicitud.predicate = NSPredicate(format: "SELF == %@", id)
                solicitud.fetchLimit = 1
                return try contexto.fetch(solicitud).first
            }
            do {
                guard let usuario = try consultar("Usuario", usuarioID),
                      usuario.value(forKey: "rol") as? String == "Supervisor" else {
                    throw ErrorAnulacion.sinPermiso
                }
                guard let venta = try consultar("Venta", ventaID) else { throw ErrorAnulacion.ventaInexistente }
                guard !((venta.value(forKey: "anulada") as? NSNumber)?.boolValue ?? false) else {
                    throw ErrorAnulacion.yaAnulada
                }
                guard let producto = venta.value(forKey: "producto") as? NSManagedObject,
                      !producto.isDeleted else { throw ErrorAnulacion.productoInexistente }
                let cantidad = (venta.value(forKey: "cantidad") as? NSNumber)?.int64Value ?? 0
                let stock = (producto.value(forKey: "stock") as? NSNumber)?.int64Value ?? -1
                let (nuevoStock, desbordamiento) = stock.addingReportingOverflow(cantidad)
                guard cantidad > 0, stock >= 0, !desbordamiento else { throw ErrorAnulacion.stockInvalido }
                venta.setValue(true, forKey: "anulada")
                venta.setValue(motivoLimpio, forKey: "motivoAnulacion")
                producto.setValue(nuevoStock, forKey: "stock")
                try contexto.save()
            } catch {
                contexto.rollback()
                throw error
            }
        }
    }
}
