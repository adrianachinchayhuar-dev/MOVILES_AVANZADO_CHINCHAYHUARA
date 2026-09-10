import Foundation

// MARK: - Modelo de datos

enum LineaMetro: Int, CaseIterable {
    case l1 = 1, l2, l3, l4, l5, l6

    var nombre: String { "Línea \(rawValue)" }

    var color: String {
        switch self {
        case .l1: return "Verde"
        case .l2: return "Amarillo"
        case .l3: return "Celeste"
        case .l4: return "Rojo"
        case .l5: return "Rosa"
        case .l6: return "Violeta"
        }
    }

    var estado: String {
        switch self {
        case .l1, .l2: return "En servicio"
        case .l3, .l4, .l5, .l6: return "Proyectada / en planificación"
        }
    }

    var recorrido: String {
        switch self {
        case .l1: return "San Juan de Lurigancho <-> Villa El Salvador"
        case .l2: return "Callao <-> Ate Vitarte"
        case .l3: return "Comas <-> Santiago de Surco"
        case .l4: return "Ate Vitarte <-> Callao"
        case .l5: return "Santiago de Surco <-> Villa El Salvador"
        case .l6: return "Los Olivos <-> Santiago de Surco"
        }
    }
}

struct Estacion {
    let nombre: String
    let distrito: String
    let puntosDeInteres: [String]
}

