import Foundation
import CoreData

struct IndicadoresResumen {
    let productos: Int
    let clientes: Int
    let ventasRegistradas: Int
    let ventasEfectivas: Int
    let ventasAnuladas: Int
    let ingresosEfectivos: Decimal

    var ingresosFormateados: String {
        let formato = NumberFormatter()
        formato.locale = Locale(identifier: "es_PE")
        formato.numberStyle = .decimal
        formato.minimumFractionDigits = 2
        formato.maximumFractionDigits = 2
        return "S/ " + (formato.string(from: NSDecimalNumber(decimal: ingresosEfectivos)) ?? "0.00")
    }

    // Solo lectura. Dos conteos y una consulta de las columnas necesarias de Venta.
    // Registradas, efectivas, anuladas e ingresos se obtienen en la misma pasada.
    static func consultar(en contexto: NSManagedObjectContext) throws -> IndicadoresResumen {
        let productos = try contexto.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "Producto"))
        let clientes = try contexto.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "Cliente"))
        let solicitud = NSFetchRequest<NSDictionary>(entityName: "Venta")
        solicitud.resultType = .dictionaryResultType
        solicitud.propertiesToFetch = ["anulada", "total"]
        let filas = try contexto.fetch(solicitud)
        var efectivas = 0
        var anuladas = 0
        var ingresos: Decimal = 0
        for fila in filas {
            // El valor por defecto de anulada en el modelo es false.
            if (fila["anulada"] as? NSNumber)?.boolValue ?? false {
                anuladas += 1
            } else {
                efectivas += 1
                let numero = fila["total"] as? NSNumber ?? 0
                guard numero.doubleValue.isFinite,
                      let importe = Decimal(string: numero.stringValue, locale: Locale(identifier: "en_US_POSIX")),
                      !importe.isNaN else {
                    throw NSError(domain: "IndicadoresResumen", code: 1,
                                  userInfo: [NSLocalizedDescriptionKey: "Una venta contiene un total inválido."])
                }
                ingresos += importe
            }
        }
        return IndicadoresResumen(productos: productos, clientes: clientes,
            ventasRegistradas: filas.count, ventasEfectivas: efectivas,
            ventasAnuladas: anuladas, ingresosEfectivos: ingresos)
    }
}
