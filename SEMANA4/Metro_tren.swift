import Foundation

// MARK: - Modelo de datos

enum NivelDeDatos: Int, Comparable {
    case operativa = 0
    case enObra = 1
    case trazadoPublicado = 2
    case soloCorredor = 3

    static func < (a: NivelDeDatos, b: NivelDeDatos) -> Bool { a.rawValue < b.rawValue }

    var etiqueta: String {
        switch self {
        case .operativa:         return "En servicio"
        case .enObra:            return "Confirmada, en construcción"
        case .trazadoPublicado:  return "Anunciada oficialmente, sin obra iniciada"
        case .soloCorredor:      return "Corredor definido, sin estaciones publicadas"
        }
    }

    /// Aviso que se agrega AL FINAL del plan de viaje (nunca lo bloquea).
    var avisoDeViaje: String? {
        switch self {
        case .operativa:
            return nil
        case .enObra:
            return "Parte del recorrido usa estaciones ya confirmadas y en construcción. "
                 + "La ruta y los nombres son correctos, pero esas estaciones todavía no abren al público."
        case .trazadoPublicado:
            return "Parte del recorrido usa estaciones con nombre oficial anunciado cuya obra aún no empieza. "
                 + "Los tiempos son una proyección."
        case .soloCorredor:
            return "Esta línea aún no tiene estaciones publicadas."
        }
    }
}

enum DiaDeViaje {
    case lunesASabado
    case domingoOFeriado

    var nombre: String {
        switch self {
        case .lunesASabado:    return "lunes a sábado"
        case .domingoOFeriado: return "domingo o feriado"
        }
    }
}

enum TipoPasajero: CaseIterable {
    case adulto
    case escolar
    case universitario
    case adultoMayor

    var nombre: String {
        switch self {
        case .adulto:         return "Adulto"
        case .escolar:        return "Escolar (medio pasaje)"
        case .universitario:  return "Universitario / instituto (medio pasaje)"
        case .adultoMayor:    return "Adulto mayor (tarifa reducida)"
        }
    }

    var nota: String? {
        switch self {
        case .universitario:
            return "El medio pasaje universitario aplica de lunes a sábado. Domingos y feriados se cobra tarifa adulto."
        case .escolar:
            return "Requiere acreditación escolar vigente."
        case .adultoMayor:
            return "Requiere acreditación de edad."
        default:
            return nil
        }
    }
}

/// La tarifa NO depende de la línea, depende del sistema de recaudo.
enum SistemaDePago: Hashable {
    case tarjetaLinea1
    case tarjetaInteroperable   // TIT

    var nombre: String {
        switch self {
        case .tarjetaLinea1:        return "Tarjeta propia de la Línea 1"
        case .tarjetaInteroperable: return "Tarjeta Interoperable de Transporte (TIT)"
        }
    }

    var nombreCorto: String {
        switch self {
        case .tarjetaLinea1:        return "Tarjeta L1"
        case .tarjetaInteroperable: return "TIT"
        }
    }

    var costoDeLaTarjeta: Double {
        switch self {
        case .tarjetaLinea1:        return 5.00
        case .tarjetaInteroperable: return 7.50
        }
    }

    var tarifaAdulto: Double {
        switch self {
        case .tarjetaLinea1:        return 1.50
        case .tarjetaInteroperable: return 1.40
        }
    }

    var tarifaReducida: Double {
        switch self {
        case .tarjetaLinea1:        return 0.75
        case .tarjetaInteroperable: return 0.70
        }
    }

    func tarifa(para pasajero: TipoPasajero, dia: DiaDeViaje) -> Double {
        switch pasajero {
        case .adulto:
            return tarifaAdulto
        case .escolar, .adultoMayor:
            return tarifaReducida
        case .universitario:
            return dia == .lunesASabado ? tarifaReducida : tarifaAdulto
        }
    }
}

struct Estacion {
    let nombre: String
    let distrito: String
    let estado: NivelDeDatos
    var puntosDeInteres: [String] = []
}

/// Una línea puede tener más de un ramal (caso real: Línea 4).
struct Ramal {
    let nombre: String
    let estaciones: [Estacion]
}

/// Para L5 y L6: lo que sí se sabe, sin inventar estaciones.
struct Corredor {
    let kilometrosEstimados: Double
    let distritos: [String]
    let avenidas: [String]
    let empalmeConocido: String?
    let situacion: String
}

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

    var recorrido: String {
        switch self {
        case .l1: return "Villa El Salvador <-> Bayóvar (San Juan de Lurigancho)"
        case .l2: return "Puerto del Callao <-> Municipalidad de Ate"
        case .l3: return "El Álamo (Comas) <-> Pedro Miotta (Surco)"
        case .l4: return "Gambetta / Venezuela (Callao) <-> Mercado Santa Anita"
        case .l5: return "Parque Reducto (Miraflores) <-> Villa (Chorrillos / VES)"
        case .l6: return "Los Olivos <-> Surco"
        }
    }

    /// Nivel de datos de la línea en su conjunto (el de su estación menos avanzada).
    var nivel: NivelDeDatos {
        switch self {
        case .l1: return .operativa
        case .l2: return .operativa      // opera parcialmente
        case .l3: return .trazadoPublicado
        case .l4: return .enObra         // el ramal ya está en obra
        case .l5, .l6: return .soloCorredor
        }
    }

    var sistemaDePago: SistemaDePago {
        switch self {
        case .l1: return .tarjetaLinea1
        default:  return .tarjetaInteroperable
        }
    }

    /// Solo L1 y L2 tienen tarifa publicada. Las demás usan la TIT como referencia.
    var tarifaEstaConfirmada: Bool {
        return self == .l1 || self == .l2
    }

    var minutosPorEstacion: Double {
        switch self {
        case .l1: return 2.1   // 26 estaciones, ~54 min extremo a extremo
        case .l2: return 1.8   // subterránea, trenes automáticos
        case .l3: return 2.0   // 28 estaciones, ~56 min proyectados
        case .l4: return 2.0
        case .l5, .l6: return 2.0
        }
    }

    // Horario. L1 abre 05:00 de lunes a sábado y 05:30 domingos y feriados;
    // cierra 22:00 todos los días. L2 opera en horario similar.
    func aperturaEnMinutos(_ dia: DiaDeViaje) -> Int? {
        switch self {
        case .l1, .l2:
            return dia == .lunesASabado ? 5 * 60 : 5 * 60 + 30
        case .l3, .l4, .l5, .l6:
            return nil
        }
    }

    func cierreEnMinutos(_ dia: DiaDeViaje) -> Int? {
        switch self {
        case .l1, .l2:           return 22 * 60
        case .l3, .l4, .l5, .l6: return nil
        }
    }

    var horarioEsOficial: Bool { self == .l1 || self == .l2 }

    var corredor: Corredor? {
        switch self {
        case .l5:
            return Corredor(
                kilometrosEstimados: 14,
                distritos: ["Miraflores", "Barranco", "Chorrillos", "Villa El Salvador"],
                avenidas: ["Av. República de Panamá", "Circuito de playas / Costa Verde"],
                empalmeConocido: "Nacería en la estación Parque Reducto de la Línea 3",
                situacion: "Prevista en la red básica. Aún no se inician los estudios de diseño "
                         + "ni existe anuncio oficial de licitación."
            )
        case .l6:
            return Corredor(
                kilometrosEstimados: 32,
                distritos: ["Comas", "Independencia", "Los Olivos", "San Martín de Porres",
                            "Magdalena", "San Isidro", "Miraflores", "Surco"],
                avenidas: ["Av. Túpac Amaru", "Av. Los Alisos", "Av. Universitaria",
                           "Av. Bertolotto", "Av. Pérez Araníbar", "Av. Angamos", "Av. Primavera"],
                empalmeConocido: nil,
                situacion: "Presentada en 2014 como iniciativa privada. En evaluación del MTC."
            )
        default:
            return nil
        }
    }
}

/// Conexión explícita entre dos estaciones. NO se deduce por nombre igual:
struct Conexion {
    let lineaA: LineaMetro
    let ramalA: Int
    let estacionA: String
    let lineaB: LineaMetro
    let ramalB: Int
    let estacionB: String
    let minutos: Double
    let salirALaCalle: Bool
    let descripcion: String
}

/// Un destino de Lima que no necesariamente es una estación.
struct Lugar {
    let nombre: String
    let alias: [String]
    let categoria: String
    let distrito: String
    let estacion: String
    let linea: LineaMetro
    let metros: Int
    let indicaciones: String
    var conexionAdicional: String? = nil
}


// MARK: - Datos de la red

let redDelMetro: [LineaMetro: [Ramal]] = [

    // ---------- LÍNEA 1 — 26 estaciones, todas operativas ----------
 
    .l1: [
        Ramal(nombre: "Línea 1", estaciones: [
            Estacion(nombre: "Villa El Salvador", distrito: "Villa El Salvador", estado: .operativa,
                     puntosDeInteres: ["Parque Industrial de Villa El Salvador"]),
            Estacion(nombre: "Parque Industrial", distrito: "Villa El Salvador", estado: .operativa),
            Estacion(nombre: "Pumacahua", distrito: "Villa El Salvador", estado: .operativa),
            Estacion(nombre: "Villa María", distrito: "Villa María del Triunfo", estado: .operativa),
            Estacion(nombre: "María Auxiliadora", distrito: "San Juan de Miraflores", estado: .operativa,
                     puntosDeInteres: ["Hospital María Auxiliadora"]),
            Estacion(nombre: "San Juan", distrito: "San Juan de Miraflores", estado: .operativa),
            Estacion(nombre: "Atocongo", distrito: "San Juan de Miraflores", estado: .operativa,
                     puntosDeInteres: ["Open Plaza Atocongo"]),
            Estacion(nombre: "Jorge Chávez", distrito: "Santiago de Surco", estado: .operativa),
            Estacion(nombre: "Ayacucho", distrito: "Santiago de Surco", estado: .operativa),
            Estacion(nombre: "Cabitos", distrito: "Santiago de Surco", estado: .operativa),
            Estacion(nombre: "Angamos", distrito: "Surquillo", estado: .operativa,
                     puntosDeInteres: ["Mercado de Surquillo"]),
            Estacion(nombre: "San Borja Sur", distrito: "San Borja", estado: .operativa),
            Estacion(nombre: "La Cultura", distrito: "San Borja", estado: .operativa,
                     puntosDeInteres: ["Museo de la Nación", "Biblioteca Nacional del Perú",
                                       "Gran Teatro Nacional"]),
            Estacion(nombre: "Arriola", distrito: "La Victoria", estado: .operativa),
            Estacion(nombre: "Gamarra", distrito: "La Victoria", estado: .operativa,
                     puntosDeInteres: ["Emporio Comercial de Gamarra"]),
            Estacion(nombre: "Miguel Grau", distrito: "La Victoria", estado: .operativa,
                     puntosDeInteres: ["Estación Grau del Metropolitano"]),
            Estacion(nombre: "El Ángel", distrito: "El Agustino", estado: .operativa),
            Estacion(nombre: "Presbítero Maestro", distrito: "Cercado de Lima", estado: .operativa,
                     puntosDeInteres: ["Cementerio Presbítero Maestro"]),
            Estacion(nombre: "Caja de Agua", distrito: "San Juan de Lurigancho", estado: .operativa),
            Estacion(nombre: "Pirámide del Sol", distrito: "San Juan de Lurigancho", estado: .operativa),
            Estacion(nombre: "Los Jardines", distrito: "San Juan de Lurigancho", estado: .operativa),
            Estacion(nombre: "Los Postes", distrito: "San Juan de Lurigancho", estado: .operativa),
            Estacion(nombre: "San Carlos", distrito: "San Juan de Lurigancho", estado: .operativa),
            Estacion(nombre: "San Martín", distrito: "San Juan de Lurigancho", estado: .operativa),
            Estacion(nombre: "Santa Rosa", distrito: "San Juan de Lurigancho", estado: .operativa),
            Estacion(nombre: "Bayóvar", distrito: "San Juan de Lurigancho", estado: .operativa,
                     puntosDeInteres: ["Mercado Bayóvar"]),
        ])
    ],

    // ---------- LÍNEA 2 — 27 estaciones. 5 operativas, 22 en obra ----------
    .l2: [
        Ramal(nombre: "Línea 2", estaciones: [
            Estacion(nombre: "Puerto del Callao", distrito: "Callao", estado: .enObra,
                     puntosDeInteres: ["Puerto del Callao"]),
            Estacion(nombre: "Buenos Aires", distrito: "Callao", estado: .enObra),
            Estacion(nombre: "Juan Pablo II", distrito: "Callao", estado: .enObra),
            Estacion(nombre: "Insurgentes", distrito: "Callao", estado: .enObra),
            Estacion(nombre: "Carmen de La Legua", distrito: "Carmen de la Legua-Reynoso", estado: .enObra),
            Estacion(nombre: "Óscar R. Benavides", distrito: "Cercado de Lima", estado: .enObra),
            Estacion(nombre: "San Marcos", distrito: "Cercado de Lima", estado: .enObra,
                     puntosDeInteres: ["Universidad Nacional Mayor de San Marcos"]),
            Estacion(nombre: "Elio", distrito: "Cercado de Lima", estado: .enObra),
            Estacion(nombre: "La Alborada", distrito: "Cercado de Lima", estado: .enObra),
            Estacion(nombre: "Tingo María", distrito: "Breña", estado: .enObra,
                     puntosDeInteres: ["Hospital Santa Rosa"]),
            Estacion(nombre: "Parque Murillo", distrito: "Breña", estado: .enObra),
            Estacion(nombre: "Plaza Bolognesi", distrito: "Cercado de Lima", estado: .enObra,
                     puntosDeInteres: ["Plaza Bolognesi"]),
            Estacion(nombre: "Estación Central", distrito: "Cercado de Lima", estado: .enObra,
                     puntosDeInteres: ["Centro Histórico de Lima", "Plaza San Martín",
                                       "Estación Central del Metropolitano"]),
            Estacion(nombre: "Manco Cápac", distrito: "La Victoria", estado: .enObra,
                     puntosDeInteres: ["Plaza Manco Cápac"]),
            Estacion(nombre: "Cangallo", distrito: "La Victoria", estado: .enObra),
            Estacion(nombre: "28 de Julio", distrito: "La Victoria", estado: .enObra,
                     puntosDeInteres: ["Emporio Comercial de Gamarra"]),
            Estacion(nombre: "Nicolás Ayllón", distrito: "La Victoria", estado: .enObra),
            Estacion(nombre: "San Juan de Dios", distrito: "El Agustino", estado: .enObra),
            Estacion(nombre: "Circunvalación", distrito: "El Agustino", estado: .enObra),
            Estacion(nombre: "Evitamiento", distrito: "Ate", estado: .operativa),
            Estacion(nombre: "Óvalo Santa Anita", distrito: "Santa Anita", estado: .operativa),
            Estacion(nombre: "Colectora Industrial", distrito: "Santa Anita", estado: .operativa),
            Estacion(nombre: "Hermilio Valdizán", distrito: "Santa Anita", estado: .operativa),
            Estacion(nombre: "Mercado Santa Anita", distrito: "Santa Anita", estado: .operativa,
                     puntosDeInteres: ["Mercado Mayorista de Santa Anita"]),
            Estacion(nombre: "Vista Alegre", distrito: "Ate", estado: .enObra),
            Estacion(nombre: "Prolongación Javier Prado", distrito: "Ate", estado: .enObra),
            Estacion(nombre: "Municipalidad de Ate", distrito: "Ate", estado: .enObra,
                     puntosDeInteres: ["Municipalidad de Ate"]),
        ])
    ],

    // ---------- LÍNEA 3 — 28 estaciones anunciadas ----------
    .l3: [
        Ramal(nombre: "Línea 3", estaciones: [
            Estacion(nombre: "El Álamo", distrito: "Comas", estado: .trazadoPublicado),
            Estacion(nombre: "Huandoy", distrito: "Comas", estado: .trazadoPublicado),
            Estacion(nombre: "2 de Octubre", distrito: "Comas", estado: .trazadoPublicado),
            Estacion(nombre: "Villa Sol", distrito: "Los Olivos", estado: .trazadoPublicado),
            Estacion(nombre: "Naranjal", distrito: "Los Olivos", estado: .trazadoPublicado,
                     puntosDeInteres: ["Terminal Naranjal del Metropolitano"]),
            Estacion(nombre: "Carlos Izaguirre", distrito: "Los Olivos", estado: .trazadoPublicado),
            Estacion(nombre: "Tomás Valle", distrito: "Los Olivos", estado: .trazadoPublicado),
            Estacion(nombre: "Bartolomé de las Casas", distrito: "Independencia", estado: .trazadoPublicado),
            Estacion(nombre: "José Granda", distrito: "San Martín de Porres", estado: .trazadoPublicado),
            Estacion(nombre: "Caquetá", distrito: "Rímac", estado: .trazadoPublicado,
                     puntosDeInteres: ["Mercado Caquetá"]),
            Estacion(nombre: "Tacna", distrito: "Cercado de Lima", estado: .trazadoPublicado,
                     puntosDeInteres: ["Plaza Mayor de Lima", "Jirón de la Unión",
                                       "Catedral de Lima", "Palacio de Gobierno"]),
            Estacion(nombre: "Garcilaso de la Vega", distrito: "Cercado de Lima", estado: .trazadoPublicado,
                     puntosDeInteres: ["Plaza San Martín", "Centro Cívico"]),
            Estacion(nombre: "Estación Central", distrito: "Cercado de Lima", estado: .trazadoPublicado,
                     puntosDeInteres: ["Estadio Nacional", "Estación Central del Metropolitano"]),
            Estacion(nombre: "Parque de la Reserva", distrito: "Cercado de Lima", estado: .trazadoPublicado,
                     puntosDeInteres: ["Circuito Mágico del Agua"]),
            Estacion(nombre: "Museo de Historia Natural", distrito: "Jesús María", estado: .trazadoPublicado,
                     puntosDeInteres: ["Museo de Historia Natural"]),
            Estacion(nombre: "César Canevaro", distrito: "Lince", estado: .trazadoPublicado),
            Estacion(nombre: "Conde de San Isidro", distrito: "San Isidro", estado: .trazadoPublicado),
            Estacion(nombre: "Andrés Aramburú", distrito: "San Isidro", estado: .trazadoPublicado),
            Estacion(nombre: "Huaca Pucllana", distrito: "Miraflores", estado: .trazadoPublicado,
                     puntosDeInteres: ["Huaca Pucllana"]),
            Estacion(nombre: "Parque Central de Miraflores", distrito: "Miraflores", estado: .trazadoPublicado,
                     puntosDeInteres: ["Parque Kennedy", "Iglesia La Virgen Milagrosa",
                                       "Larcomar", "Malecón de Miraflores"]),
            Estacion(nombre: "Parque Reducto", distrito: "Miraflores", estado: .trazadoPublicado,
                     puntosDeInteres: ["Parque Reducto N.º 2"]),
            Estacion(nombre: "República de Panamá", distrito: "Surquillo", estado: .trazadoPublicado),
            Estacion(nombre: "Juana Alarco", distrito: "Miraflores", estado: .trazadoPublicado),
            Estacion(nombre: "Cabitos", distrito: "Santiago de Surco", estado: .trazadoPublicado),
            Estacion(nombre: "Alejandro Velasco", distrito: "Santiago de Surco", estado: .trazadoPublicado),
            Estacion(nombre: "Las Gardenias", distrito: "Santiago de Surco", estado: .trazadoPublicado),
            Estacion(nombre: "Los Héroes", distrito: "Santiago de Surco", estado: .trazadoPublicado),
            Estacion(nombre: "Pedro Miotta", distrito: "San Juan de Miraflores", estado: .trazadoPublicado),
        ])
    ],

    // ---------- LÍNEA 4 — ramal en obra (8) + tronco anunciado (20) ----------
    .l4: [
        Ramal(nombre: "Ramal Faucett-Gambetta", estaciones: [
            Estacion(nombre: "Gambetta", distrito: "Callao", estado: .enObra),
            Estacion(nombre: "Canta Callao", distrito: "Callao", estado: .enObra),
            Estacion(nombre: "Bocanegra", distrito: "Callao", estado: .enObra),
            Estacion(nombre: "Aeropuerto", distrito: "Callao", estado: .enObra,
                     puntosDeInteres: ["Aeropuerto Internacional Jorge Chávez"]),
            Estacion(nombre: "El Olivar", distrito: "Callao", estado: .enObra),
            Estacion(nombre: "Quilca", distrito: "Callao", estado: .enObra),
            Estacion(nombre: "Morales Duárez", distrito: "Callao", estado: .enObra),
            Estacion(nombre: "Carmen de La Legua", distrito: "Carmen de la Legua-Reynoso", estado: .enObra),
        ]),
        Ramal(nombre: "Tronco Línea 4", estaciones: [
            Estacion(nombre: "Venezuela", distrito: "San Miguel", estado: .trazadoPublicado),
            Estacion(nombre: "Rafael Escardó", distrito: "San Miguel", estado: .trazadoPublicado),
            Estacion(nombre: "Pando", distrito: "San Miguel", estado: .trazadoPublicado,
                     puntosDeInteres: ["Pontificia Universidad Católica del Perú"]),
            Estacion(nombre: "José de Sucre", distrito: "San Miguel", estado: .trazadoPublicado,
                     puntosDeInteres: ["Plaza San Miguel"]),
            Estacion(nombre: "Brasil", distrito: "Pueblo Libre", estado: .trazadoPublicado,
                     puntosDeInteres: ["Museo Nacional de Arqueología"]),
            Estacion(nombre: "Felipe Salaverry", distrito: "Jesús María", estado: .trazadoPublicado,
                     puntosDeInteres: ["Campo de Marte", "Hospital del Niño"]),
            Estacion(nombre: "Guillermo Prescott", distrito: "San Isidro", estado: .trazadoPublicado),
            Estacion(nombre: "Las Palmeras", distrito: "San Isidro", estado: .trazadoPublicado),
            Estacion(nombre: "Conde de San Isidro", distrito: "San Isidro", estado: .trazadoPublicado,
                     puntosDeInteres: ["El Olivar de San Isidro"]),
            Estacion(nombre: "Rivera Navarrete", distrito: "San Isidro", estado: .trazadoPublicado,
                     puntosDeInteres: ["Centro financiero de San Isidro"]),
            Estacion(nombre: "Pablo Carriquiry", distrito: "San Isidro", estado: .trazadoPublicado),
            Estacion(nombre: "La Cultura", distrito: "San Borja", estado: .trazadoPublicado,
                     puntosDeInteres: ["Museo de la Nación"]),
            Estacion(nombre: "San Luis", distrito: "San Borja", estado: .trazadoPublicado),
            Estacion(nombre: "Monterrico", distrito: "Santiago de Surco", estado: .trazadoPublicado,
                     puntosDeInteres: ["Jockey Plaza", "Universidad de Lima"]),
            Estacion(nombre: "Manuel Olguín", distrito: "Santiago de Surco", estado: .trazadoPublicado),
            Estacion(nombre: "Los Frutales", distrito: "Ate", estado: .trazadoPublicado),
            Estacion(nombre: "La Molina", distrito: "La Molina", estado: .trazadoPublicado),
            Estacion(nombre: "Santa Patricia", distrito: "La Molina", estado: .trazadoPublicado),
            Estacion(nombre: "Mayorazgo", distrito: "Ate", estado: .trazadoPublicado),
            Estacion(nombre: "Mercado Santa Anita", distrito: "Santa Anita", estado: .trazadoPublicado,
                     puntosDeInteres: ["Mercado Mayorista de Santa Anita"]),
        ])
    ],

    // L5 y L6 no tienen estaciones publicadas
    .l5: [],
    .l6: [],
]

// Conexiones declaradas una por una. Nunca se deducen por nombre igual.
let conexiones: [Conexion] = [

    Conexion(lineaA: .l1, ramalA: 0, estacionA: "Gamarra",
             lineaB: .l2, ramalB: 0, estacionB: "28 de Julio",
             minutos: 8, salirALaCalle: true,
             descripcion: "Conexión a pie por el Emporio de Gamarra (aprox. 400 m). No es un andén compartido."),

    Conexion(lineaA: .l2, ramalA: 0, estacionA: "Carmen de La Legua",
             lineaB: .l4, ramalB: 0, estacionB: "Carmen de La Legua",
             minutos: 4, salirALaCalle: false,
             descripcion: "Estación compartida: el ramal de la Línea 4 empalma aquí con la Línea 2."),

    Conexion(lineaA: .l2, ramalA: 0, estacionA: "Estación Central",
             lineaB: .l3, ramalB: 0, estacionB: "Estación Central",
             minutos: 5, salirALaCalle: false,
             descripcion: "Estación compartida L2/L3, con transbordo al Metropolitano."),

    Conexion(lineaA: .l1, ramalA: 0, estacionA: "Cabitos",
             lineaB: .l3, ramalB: 0, estacionB: "Cabitos",
             minutos: 5, salirALaCalle: false,
             descripcion: "Estación compartida entre la Línea 1 y la Línea 3."),

    Conexion(lineaA: .l3, ramalA: 0, estacionA: "Conde de San Isidro",
             lineaB: .l4, ramalB: 1, estacionB: "Conde de San Isidro",
             minutos: 5, salirALaCalle: false,
             descripcion: "Estación compartida entre la Línea 3 y el tronco de la Línea 4."),

    Conexion(lineaA: .l1, ramalA: 0, estacionA: "La Cultura",
             lineaB: .l4, ramalB: 1, estacionB: "La Cultura",
             minutos: 5, salirALaCalle: false,
             descripcion: "Estación compartida entre la Línea 1 y el tronco de la Línea 4."),

    Conexion(lineaA: .l2, ramalA: 0, estacionA: "Mercado Santa Anita",
             lineaB: .l4, ramalB: 1, estacionB: "Mercado Santa Anita",
             minutos: 5, salirALaCalle: false,
             descripcion: "Terminal este del tronco de la Línea 4, compartida con la Línea 2."),
]

// Mantiene las conexiones manuales existentes y además
// detecta estaciones con el mismo nombre en diferentes líneas.

func conexionesCompletas() -> [Conexion] {
    
    // Empezamos con las conexiones que ya estaban declaradas.
    var resultado = conexiones
    
    // Recorremos todas las líneas registradas.
    for lineaA in LineaMetro.allCases {
        
        guard let ramalesA = redDelMetro[lineaA] else { continue }
        
        for (ramalA, ramal) in ramalesA.enumerated() {
            
            for estacionA in ramal.estaciones {
                
                // Buscamos la misma estación en las demás líneas.
                for lineaB in LineaMetro.allCases {
                    
                    // Evitamos comparar una línea consigo misma.
                    if lineaA == lineaB {
                        continue
                    }
                    
                    guard let ramalesB = redDelMetro[lineaB] else { continue }
                    
                    for (ramalB, ramalBActual) in ramalesB.enumerated() {
                        
                        for estacionB in ramalBActual.estaciones {
                            
                            // Comparamos nombres normalizados.
                            if normalizar(estacionA.nombre) == normalizar(estacionB.nombre) {
                                
                                // Evitamos duplicar la misma conexión.
                                let yaExiste = resultado.contains {
                                    (
                                        $0.lineaA == lineaA &&
                                        $0.ramalA == ramalA &&
                                        normalizar($0.estacionA) == normalizar(estacionA.nombre) &&
                                        $0.lineaB == lineaB &&
                                        $0.ramalB == ramalB &&
                                        normalizar($0.estacionB) == normalizar(estacionB.nombre)
                                    )
                                    ||
                                    (
                                        $0.lineaA == lineaB &&
                                        $0.ramalA == ramalB &&
                                        normalizar($0.estacionA) == normalizar(estacionB.nombre) &&
                                        $0.lineaB == lineaA &&
                                        $0.ramalB == ramalA &&
                                        normalizar($0.estacionB) == normalizar(estacionA.nombre)
                                    )
                                }
                                
                                if !yaExiste {
                                    resultado.append(
                                        Conexion(
                                            lineaA: lineaA,
                                            ramalA: ramalA,
                                            estacionA: estacionA.nombre,
                                            lineaB: lineaB,
                                            ramalB: ramalB,
                                            estacionB: estacionB.nombre,
                                            minutos: 3,
                                            salirALaCalle: false,
                                            descripcion: "Conexión automática detectada porque ambas líneas tienen una estación con el mismo nombre."
                                        )
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    return resultado
}

// Lugares de Lima que no son estaciones. Cada uno apunta a la estación más cercana.
let lugaresDeLima: [Lugar] = [

    Lugar(nombre: "Plaza Mayor de Lima", alias: ["plaza de armas", "palacio de gobierno", "catedral de lima", "centro de lima"],
          categoria: "Turismo", distrito: "Cercado de Lima",
          estacion: "Tacna", linea: .l3, metros: 600,
          indicaciones: "Sal por la Av. Tacna y camina hacia el este por el Jirón de la Unión, unas 6 cuadras.",
          conexionAdicional: "Hoy se llega con el Metropolitano (estación Jr. de la Unión)."),

    Lugar(nombre: "Parque Kennedy", alias: ["miraflores", "parque central de miraflores", "parque del amor"],
          categoria: "Turismo", distrito: "Miraflores",
          estacion: "Parque Central de Miraflores", linea: .l3, metros: 150,
          indicaciones: "La estación queda bajo el parque.",
          conexionAdicional: "Hoy: L1 hasta Angamos + Corredor Azul o taxi (~20 min adicionales)."),

    Lugar(nombre: "Larcomar", alias: ["larco mar", "malecon de miraflores", "acantilado"],
          categoria: "Turismo", distrito: "Miraflores",
          estacion: "Parque Central de Miraflores", linea: .l3, metros: 1100,
          indicaciones: "Camina por la Av. Larco hacia el mar, unos 12 minutos."),

    Lugar(nombre: "Huaca Pucllana", alias: ["huaca pullana", "pucllana"],
          categoria: "Turismo", distrito: "Miraflores",
          estacion: "Huaca Pucllana", linea: .l3, metros: 300,
          indicaciones: "Salida directa hacia la calle General Borgoño."),

    Lugar(nombre: "Circuito Mágico del Agua", alias: ["parque de la reserva", "circuito magico", "fuentes de agua"],
          categoria: "Turismo", distrito: "Cercado de Lima",
          estacion: "Parque de la Reserva", linea: .l3, metros: 200,
          indicaciones: "Salida frente a la Av. Petit Thouars."),

    Lugar(nombre: "Estadio Nacional", alias: ["estadio", "estadio nacional del peru"],
          categoria: "Deporte", distrito: "Cercado de Lima",
          estacion: "Estación Central", linea: .l3, metros: 400,
          indicaciones: "Salida hacia la Av. José Díaz.",
          conexionAdicional: "Hoy: Metropolitano hasta Estación Central."),

    Lugar(nombre: "Emporio Comercial de Gamarra", alias: ["gamarra", "emporio", "ropa gamarra"],
          categoria: "Comercio", distrito: "La Victoria",
          estacion: "Gamarra", linea: .l1, metros: 100,
          indicaciones: "Salida directa al Jr. Gamarra."),

    Lugar(nombre: "Jockey Plaza", alias: ["jockey", "centro comercial jockey"],
          categoria: "Comercio", distrito: "Santiago de Surco",
          estacion: "Monterrico", linea: .l4, metros: 400,
          indicaciones: "Salida hacia la Av. Javier Prado Este.",
          conexionAdicional: "Hoy: L1 hasta Angamos y luego corredor por Av. Angamos / Javier Prado."),

    Lugar(nombre: "Aeropuerto Internacional Jorge Chávez", alias: ["aeropuerto", "jorge chavez", "lap", "vuelo"],
          categoria: "Transporte", distrito: "Callao",
          estacion: "Aeropuerto", linea: .l4, metros: 200,
          indicaciones: "La estación del ramal de la Línea 4 conecta directamente con el terminal.",
          conexionAdicional: "Hoy solo se llega por vía superficial (Airport Express, taxi o combi)."),

    Lugar(nombre: "Museo de la Nación", alias: ["museo de la nacion", "gran teatro nacional", "biblioteca nacional"],
          categoria: "Cultura", distrito: "San Borja",
          estacion: "La Cultura", linea: .l1, metros: 250,
          indicaciones: "Salida directa a la Av. Javier Prado Este."),

    Lugar(nombre: "Universidad Nacional Mayor de San Marcos", alias: ["san marcos", "unmsm", "ciudad universitaria"],
          categoria: "Educación", distrito: "Cercado de Lima",
          estacion: "San Marcos", linea: .l2, metros: 300,
          indicaciones: "Salida hacia la Av. Venezuela, frente a la puerta principal."),

    Lugar(nombre: "Pontificia Universidad Católica del Perú", alias: ["pucp", "catolica", "universidad catolica"],
          categoria: "Educación", distrito: "San Miguel",
          estacion: "Pando", linea: .l4, metros: 500,
          indicaciones: "Salida hacia la Av. Universitaria."),

    Lugar(nombre: "Universidad de Lima", alias: ["ulima", "universidad de lima"],
          categoria: "Educación", distrito: "Santiago de Surco",
          estacion: "Monterrico", linea: .l4, metros: 700,
          indicaciones: "Camina por la Av. Javier Prado hacia el este."),

    Lugar(nombre: "Hospital María Auxiliadora", alias: ["maria auxiliadora", "hospital del sur"],
          categoria: "Salud", distrito: "San Juan de Miraflores",
          estacion: "María Auxiliadora", linea: .l1, metros: 200,
          indicaciones: "Salida directa a la Av. Miguel Iglesias."),

    Lugar(nombre: "Mercado Mayorista de Santa Anita", alias: ["gran mercado mayorista", "mercado santa anita", "la parada"],
          categoria: "Comercio", distrito: "Santa Anita",
          estacion: "Mercado Santa Anita", linea: .l2, metros: 300,
          indicaciones: "Salida hacia la Av. La Cultura."),

    Lugar(nombre: "Plaza San Martín", alias: ["plaza san martin", "jiron de la union"],
          categoria: "Turismo", distrito: "Cercado de Lima",
          estacion: "Garcilaso de la Vega", linea: .l3, metros: 350,
          indicaciones: "Salida hacia la Av. Nicolás de Piérola."),

    Lugar(nombre: "El Olivar de San Isidro", alias: ["el olivar", "bosque el olivar"],
          categoria: "Turismo", distrito: "San Isidro",
          estacion: "Conde de San Isidro", linea: .l3, metros: 400,
          indicaciones: "Camina por la Av. Conde de la Vega hacia el bosque."),

    Lugar(nombre: "Centro financiero de San Isidro", alias: ["san isidro", "distrito financiero", "javier prado san isidro"],
          categoria: "Trabajo", distrito: "San Isidro",
          estacion: "Rivera Navarrete", linea: .l4, metros: 200,
          indicaciones: "Salida directa a la Av. Rivera Navarrete."),

    Lugar(nombre: "Campo de Marte", alias: ["campo de marte", "jesus maria"],
          categoria: "Turismo", distrito: "Jesús María",
          estacion: "Felipe Salaverry", linea: .l4, metros: 350,
          indicaciones: "Salida hacia la Av. Salaverry."),

    Lugar(nombre: "Open Plaza Atocongo", alias: ["atocongo", "open plaza"],
          categoria: "Comercio", distrito: "San Juan de Miraflores",
          estacion: "Atocongo", linea: .l1, metros: 150,
          indicaciones: "Salida directa al centro comercial."),

    Lugar(nombre: "Terminal Naranjal del Metropolitano", alias: ["naranjal", "terminal norte"],
          categoria: "Transporte", distrito: "Los Olivos",
          estacion: "Naranjal", linea: .l3, metros: 100,
          indicaciones: "Transbordo directo al Metropolitano."),

    Lugar(nombre: "Plaza San Miguel", alias: ["plaza san miguel", "san miguel"],
          categoria: "Comercio", distrito: "San Miguel",
          estacion: "José de Sucre", linea: .l4, metros: 300,
          indicaciones: "Salida hacia la Av. La Marina."),
]


// MARK: - Utilidades

func normalizar(_ texto: String) -> String {
    texto.trimmingCharacters(in: .whitespacesAndNewlines)
         .folding(options: .diacriticInsensitive, locale: Locale(identifier: "es_PE"))
         .lowercased()
         .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
}

func soles(_ monto: Double) -> String { String(format: "S/ %.2f", monto) }

/// Rellena con espacios a la derecha para alinear columnas en consola.
func rellenar(_ texto: String, _ ancho: Int) -> String {
    texto.count >= ancho ? texto : texto + String(repeating: " ", count: ancho - texto.count)
}

func minutosATexto(_ minutos: Double) -> String { String(format: "%.0f min", minutos.rounded()) }

func horaATexto(_ minutos: Int) -> String {
    let m = ((minutos % 1440) + 1440) % 1440
    return String(format: "%02d:%02d", m / 60, m % 60)
}

func textoAMinutos(_ texto: String) -> Int? {
    let partes = texto.split(separator: ":")
    guard partes.count == 2,
          let h = Int(partes[0]), let m = Int(partes[1]),
          (0...23).contains(h), (0...59).contains(m) else { return nil }
    return h * 60 + m
}

/// Hora punta: 06:30–09:00 y 17:00–20:00 de lunes a sábado.
func factorDeCongestion(_ minutosDelDia: Int, dia: DiaDeViaje) -> Double {
    guard dia == .lunesASabado else { return 1.0 }
    let punta = (minutosDelDia >= 390 && minutosDelDia <= 540)
             || (minutosDelDia >= 1020 && minutosDelDia <= 1200)
    return punta ? 1.25 : 1.0
}

func separador(_ titulo: String) {
    print("\n" + String(repeating: "=", count: 62))
    print("  " + titulo.uppercased())
    print(String(repeating: "=", count: 62))
}

func pausa() {
    print("\n(Presiona Enter para continuar)")
    _ = readLine()
}

// MARK: - Perfil del Usuario

struct ViajeRegistrado {
    let origen: String
    let destino: String
    let costo: Double
    let minutos: Double
    let hora: String
}

final class Perfil {
    var nombre: String = "Pasajero"
    var tipoPasajero: TipoPasajero = .adulto
    var tarjetas: Set<SistemaDePago> = []
    var saldo: [SistemaDePago: Double] = [:]
    var historial: [ViajeRegistrado] = []
    
    // Saldo actual de una tarjeta
    func saldoDe(_ sistema: SistemaDePago) -> Double { saldo[sistema] ?? 0 }
    
    // Recarga de saldo
    func recargar(_ sistema: SistemaDePago, monto: Double) {
        tarjetas.insert(sistema)
        saldo[sistema] = saldoDe(sistema) + monto
    }
    
    // Descuenta dinero de una tarjeta
    @discardableResult
        func cobrar(_ sistema: SistemaDePago, monto: Double) -> Bool {

            let saldoActual = saldoDe(sistema)

            // Verificamos que tenga suficiente saldo.
            guard saldoActual >= monto else {
                return false
            }

            // Descontamos el importe del viaje.
            saldo[sistema] = saldoActual - monto

            return true
        }
    
    // Total gastado durante esta sesión
    var totalGastado: Double { historial.reduce(0) { $0 + $1.costo } }
}
nonisolated(unsafe) let perfil = Perfil()

// MARK: - Grafo y ruteo (Dijkstra)

struct Nodo: Hashable {
    let linea: LineaMetro
    let ramal: Int
    let indice: Int
}

struct Arista {
    let destino: Nodo
    let minutos: Double
    let esTransbordo: Bool
    let descripcion: String
}

func estacionDe(_ nodo: Nodo) -> Estacion {
    redDelMetro[nodo.linea]![nodo.ramal].estaciones[nodo.indice]
}

func ramalDe(_ nodo: Nodo) -> Ramal {
    redDelMetro[nodo.linea]![nodo.ramal]
}

/// Construye el grafo con todas las estaciones registradas y aplica el factor de hora punta.
/// Las estaciones en obra/proyectadas NO se eliminan: se usan para simular la red futura.
func construirGrafo(factor: Double) -> [Nodo: [Arista]] {
    var grafo: [Nodo: [Arista]] = [:]

    func agregar(_ a: Nodo, _ b: Nodo, _ minutos: Double, _ transbordo: Bool, _ texto: String) {
        grafo[a, default: []].append(Arista(destino: b, minutos: minutos,
                                            esTransbordo: transbordo, descripcion: texto))
        grafo[b, default: []].append(Arista(destino: a, minutos: minutos,
                                            esTransbordo: transbordo, descripcion: texto))
    }

    // Tramos entre estaciones consecutivas
    for (linea, ramales) in redDelMetro {
        for (r, ramal) in ramales.enumerated() {
            for i in 0..<ramal.estaciones.count {
                let nodo = Nodo(linea: linea, ramal: r, indice: i)
                if grafo[nodo] == nil {
                    grafo[nodo] = []
                }
                guard i + 1 < ramal.estaciones.count else { continue }
                agregar(nodo,
                        Nodo(linea: linea, ramal: r, indice: i + 1),
                        linea.minutosPorEstacion * factor,
                        false, "")
            }
        }
    }

    // Transbordos declarados
    for c in conexionesCompletas() {
        guard let iA = indiceDe(c.estacionA, linea: c.lineaA, ramal: c.ramalA),
              let iB = indiceDe(c.estacionB, linea: c.lineaB, ramal: c.ramalB) else { continue }
        let nA = Nodo(linea: c.lineaA, ramal: c.ramalA, indice: iA)
        let nB = Nodo(linea: c.lineaB, ramal: c.ramalB, indice: iB)
        agregar(nA, nB, c.minutos, true, c.descripcion)
    }

    return grafo
}

func indiceDe(_ nombre: String, linea: LineaMetro, ramal: Int) -> Int? {
    guard let ramales = redDelMetro[linea], ramal < ramales.count else { return nil }
    let objetivo = normalizar(nombre)
    return ramales[ramal].estaciones.firstIndex { normalizar($0.nombre) == objetivo }
}

/// Todos los nodos que corresponden a un nombre de estación.
func nodosDe(estacion nombre: String) -> [Nodo] {
    var resultado: [Nodo] = []
    let objetivo = normalizar(nombre)
    for (linea, ramales) in redDelMetro {
        for (r, ramal) in ramales.enumerated() {
            for (i, est) in ramal.estaciones.enumerated() where normalizar(est.nombre) == objetivo {
                resultado.append(Nodo(linea: linea, ramal: r, indice: i))
            }
        }
    }
    return resultado
}

struct Ruta {
    let nodos: [Nodo]
    let aristas: [Arista]
    let minutos: Double
}

func rutaMasRapida(desde origenes: [Nodo], hasta destinos: [Nodo],
                   grafo: [Nodo: [Arista]]) -> Ruta? {

    var distancia: [Nodo: Double] = [:]
    var previo: [Nodo: (Nodo, Arista)] = [:]
    var pendientes: Set<Nodo> = Set(grafo.keys)

    for o in origenes where grafo[o] != nil { distancia[o] = 0 }
    guard !distancia.isEmpty else { return nil }

    let metas = Set(destinos.filter { grafo[$0] != nil })
    guard !metas.isEmpty else { return nil }

    while !pendientes.isEmpty {
        // Grafo pequeño (< 100 nodos): búsqueda lineal del mínimo es suficiente.
        var actual: Nodo? = nil
        var mejor = Double.infinity
        for n in pendientes {
            if let d = distancia[n], d < mejor { mejor = d; actual = n }
        }
        guard let u = actual else { break }
        pendientes.remove(u)

        if metas.contains(u) {
            var camino: [Nodo] = [u]
            var pasos: [Arista] = []
            var cursor = u
            while let (anterior, arista) = previo[cursor] {
                camino.append(anterior)
                pasos.append(arista)
                cursor = anterior
            }
            return Ruta(nodos: camino.reversed(), aristas: pasos.reversed(), minutos: mejor)
        }

        for arista in grafo[u] ?? [] {
            let nueva = mejor + arista.minutos
            if nueva < (distancia[arista.destino] ?? .infinity) {
                distancia[arista.destino] = nueva
                previo[arista.destino] = (u, arista)
            }
        }
    }
    return nil
}

// MARK: - Tramos, tarifa y presentación del plan

struct Tramo {
    let linea: LineaMetro
    let ramal: Int
    let desde: Int
    let hasta: Int
    let minutos: Double

    var estaciones: [Estacion] {
        let lista = redDelMetro[linea]![ramal].estaciones
        return desde <= hasta ? Array(lista[desde...hasta])
                              : Array(lista[hasta...desde]).reversed()
    }

    var sentido: String {
        let lista = redDelMetro[linea]![ramal].estaciones
        return hasta > desde ? lista.last!.nombre : lista.first!.nombre
    }

    var cantidadDeEstaciones: Int { abs(hasta - desde) }
}

func dividirEnTramos(_ ruta: Ruta) -> (tramos: [Tramo], transbordos: [Arista]) {
    var tramos: [Tramo] = []
    var transbordos: [Arista] = []

    var inicio = ruta.nodos[0]
    var acumulado = 0.0

    for (i, arista) in ruta.aristas.enumerated() {
        let siguiente = ruta.nodos[i + 1]
        if arista.esTransbordo {
            let fin = ruta.nodos[i]
            tramos.append(Tramo(linea: inicio.linea, ramal: inicio.ramal,
                                desde: inicio.indice, hasta: fin.indice, minutos: acumulado))
            transbordos.append(arista)
            inicio = siguiente
            acumulado = 0
        } else {
            acumulado += arista.minutos
        }
    }
    let fin = ruta.nodos.last!
    tramos.append(Tramo(linea: inicio.linea, ramal: inicio.ramal,
                        desde: inicio.indice, hasta: fin.indice, minutos: acumulado))
    return (tramos, transbordos)
}

// Calcula cuántas estaciones faltan en TODO el recorrido
func estacionesRestantes(
    tramos: [Tramo],
    tramoActual: Int
) -> Int {

    guard tramoActual < tramos.count else {
        return 0
    }

    var total = 0

    // Recorremos desde el tramo actual
    // hasta el último tramo.
    for i in tramoActual..<tramos.count {

        total += tramos[i].cantidadDeEstaciones
    }

    return total
}

struct ResultadoTarifa {
    let total: Double
    let cobros: [(sistema: SistemaDePago, monto: Double, motivo: String)]
    let hayEstimados: Bool
    let tarjetasNecesarias: Set<SistemaDePago>
}

/// Se cobra al ingresar y cada vez que se cambia de sistema de recaudo.
func calcularTarifa(tramos: [Tramo], pasajero: TipoPasajero, dia: DiaDeViaje) -> ResultadoTarifa {
    var cobros: [(SistemaDePago, Double, String)] = []
    var tarjetas: Set<SistemaDePago> = []
    var estimado = false
    var anterior: SistemaDePago? = nil

    for tramo in tramos {
        let sistema = tramo.linea.sistemaDePago
        tarjetas.insert(sistema)
        if !tramo.linea.tarifaEstaConfirmada { estimado = true }

        if anterior == nil {
            cobros.append((sistema, sistema.tarifa(para: pasajero, dia: dia),
                           "Ingreso a \(tramo.linea.nombre) con \(sistema.nombreCorto)"))
        } else if anterior != sistema {
            cobros.append((sistema, sistema.tarifa(para: pasajero, dia: dia),
                           "Cambio de sistema: entras a \(tramo.linea.nombre) con \(sistema.nombreCorto)"))
        }
        anterior = sistema
    }

    let total = cobros.reduce(0) { $0 + $1.1 }
    return ResultadoTarifa(total: total,
                           cobros: cobros.map { (sistema: $0.0, monto: $0.1, motivo: $0.2) },
                           hayEstimados: estimado,
                           tarjetasNecesarias: tarjetas)
}

// MARK: - Búsqueda de Destinos

enum Destino {
    case estacion(String)
    case lugar(Lugar)

    var titulo: String {
        switch self {
        case .estacion(let n): return "Estación \(n)"
        case .lugar(let l):    return "\(l.nombre) (\(l.distrito))"
        }
    }

    var estacionObjetivo: String {
        switch self {
        case .estacion(let n): return n
        case .lugar(let l):    return l.estacion
        }
    }
}

func buscarDestinos(_ texto: String) -> [Destino] {
    let q = normalizar(texto)
    guard !q.isEmpty else { return [] }
    var resultado: [Destino] = []
    var vistos = Set<String>()

    // 1. Estaciones (exacta y luego parcial)
    for (_, ramales) in redDelMetro {
        for ramal in ramales {
            for est in ramal.estaciones {
                let n = normalizar(est.nombre)
                if (n == q || n.contains(q)) && !vistos.contains(n) {
                    vistos.insert(n)
                    resultado.append(.estacion(est.nombre))
                }
            }
        }
    }

    // 2. Lugares por nombre o alias
    for lugar in lugaresDeLima {
        let coincide = normalizar(lugar.nombre).contains(q)
            || lugar.alias.contains { normalizar($0).contains(q) || q.contains(normalizar($0)) }
            || normalizar(lugar.distrito) == q
        if coincide { resultado.append(.lugar(lugar)) }
    }

    // 3. Puntos de interés declarados dentro de estaciones
    for (_, ramales) in redDelMetro {
        for ramal in ramales {
            for est in ramal.estaciones {
                for poi in est.puntosDeInteres where normalizar(poi).contains(q) {
                    let clave = normalizar(est.nombre)
                    if !vistos.contains(clave) {
                        vistos.insert(clave)
                        resultado.append(.estacion(est.nombre))
                    }
                }
            }
        }
    }

    return resultado
}

func estacionesEn(distrito: String) -> [(LineaMetro, Estacion)] {
    let q = normalizar(distrito)
    var lista: [(LineaMetro, Estacion)] = []
    for (linea, ramales) in redDelMetro {
        for ramal in ramales {
            for est in ramal.estaciones where normalizar(est.distrito).contains(q) {
                lista.append((linea, est))
            }
        }
    }
    return lista
}

// MARK: - Entrada por Consola

func leer() -> String {
    guard let linea = readLine() else {
        print("\nEntrada cerrada. Hasta luego.")
        exit(0)
    }
    return linea.trimmingCharacters(in: .whitespacesAndNewlines)
}

func pedirTexto(_ mensaje: String, permitirCancelar: Bool = true) -> String? {
    while true {
        print("\n" + mensaje + (permitirCancelar ? "  (escribe 0 para cancelar)" : ""))
        print("> ", terminator: "")
        let texto = leer()
        if permitirCancelar && texto == "0" { return nil }
        if !texto.isEmpty { return texto }
        print("El dato no puede estar vacío.")
    }
}

func pedirOpcion(_ mensaje: String, opciones: [String]) -> Int? {
    while true {
        print("\n" + mensaje)
        for (i, o) in opciones.enumerated() { print("  \(i + 1). \(o)") }
        print("  0. Cancelar")
        print("> ", terminator: "")
        let texto = leer()
        if texto == "0" { return nil }
        if let n = Int(texto), n >= 1, n <= opciones.count { return n - 1 }
        print("Opción no válida.")
    }
}

func pedirHora() -> String? {
    while true {
        print("\nHora de salida (HH:MM), o Enter para usar 08:00.  (0 para cancelar)")
        print("> ", terminator: "")
        let texto = leer()
        if texto == "0" { return nil }
        if texto.isEmpty { return "08:00" }
        if textoAMinutos(texto) != nil { return texto }
        print("Formato no válido. Ejemplo: 08:30")
    }
}

// MARK: - Opciones del Menú

// ---- Opción 1
func listarLineas() {
    separador("Líneas del Metro de Lima")
    for linea in LineaMetro.allCases {
        let ramales = redDelMetro[linea] ?? []
        let total = ramales.reduce(0) { $0 + $1.estaciones.count }
        let operativas = ramales.reduce(0) { $0 + $1.estaciones.filter { $0.estado == .operativa }.count }

        print("\n[\(linea.rawValue)] \(linea.nombre.uppercased())  —  color \(linea.color)")
        print("    Estado    : \(linea.nivel.etiqueta)")
        print("    Recorrido : \(linea.recorrido)")
        if total == 0 {
            print("    Estaciones: sin lista publicada (ver opción 2 para el corredor)")
        } else if operativas == total {
            print("    Estaciones: \(total), todas en servicio")
        } else if operativas > 0 {
            print("    Estaciones: \(total) confirmadas, \(operativas) en servicio hoy")
        } else {
            print("    Estaciones: \(total) con nombre anunciado, ninguna en servicio")
        }
        print("    Pago      : \(linea.sistemaDePago.nombre)"
              + (linea.tarifaEstaConfirmada ? "" : " — tarifa aún no publicada"))
    }
}

// ---- Opción 2
// Se muestra un aviso general y se mantiene el flujo normal.
func mostrarEstaciones(de linea: LineaMetro) {
    let ramales = redDelMetro[linea] ?? []

    if ramales.isEmpty {
        mostrarCorredor(linea)
        return
    }

    separador("Estaciones de \(linea.nombre) (\(linea.color))")
    for ramal in ramales {
        print("\n--- \(ramal.nombre) — \(ramal.estaciones.count) estaciones ---")
        for (i, est) in ramal.estaciones.enumerated() {
            let numero = String(format: "%2d", i + 1)
            print("\(numero). \(rellenar(est.nombre, 32)) \(est.distrito)")
        }
    }

    // El usuario recibe un aviso general, pero puede seguir usando el flujo normal.
    switch linea {
    case .l1:
        print("\n✓ Esta línea se encuentra en servicio.")
    case .l2:
        print("""

        ⚠ AVISO:
           La Línea 2 todavía se encuentra en construcción en parte de su recorrido.
           Las estaciones que aún no abren al público se muestran para simular
           el recorrido completo y pueden utilizarse en el planificador.
        """)
    case .l3:
        print("""

        ⚠ AVISO:
           La Línea 3 todavía no está en servicio.
           Las estaciones mostradas corresponden al trazado registrado para el simulador.
           Los tiempos de viaje son estimados.
        """)
    case .l4:
        print("""

        ⚠ AVISO:
           La Línea 4 todavía no está completamente en servicio.
           Parte del recorrido se encuentra en obra y otra parte corresponde
           al trazado anunciado. Los tiempos de viaje son estimados.
        """)
    case .l5, .l6:
        break
    }
}

func mostrarCorredor(_ linea: LineaMetro) {
    guard let c = linea.corredor else { return }
    separador("\(linea.nombre) (\(linea.color))")
    print("""

    Esta línea todavía NO tiene una lista oficial de estaciones.
    El simulador no las muestra para no darte información inventada.

    Lo que sí está definido:
      Longitud  : ~\(Int(c.kilometrosEstimados)) km
      Distritos : \(c.distritos.joined(separator: ", "))
      Avenidas  : \(c.avenidas.joined(separator: ", "))
    """)
    if let empalme = c.empalmeConocido { print("      Empalme   : \(empalme)") }
    print("      Situación : \(c.situacion)")
    print("""

    ¿Vas a alguno de esos distritos? Usa la opción 3 para ver qué estación
    de la red te deja más cerca.
    """)
}

// ---- Opción 3
func buscar(_ texto: String) {
    separador("Búsqueda: \"\(texto)\"")
    let encontrados = buscarDestinos(texto)

    if encontrados.isEmpty {
        print("\nNo encontré nada con ese nombre.")
        let porDistrito = estacionesEn(distrito: texto)
        if !porDistrito.isEmpty {
            print("Pero hay estaciones en ese distrito:")
            for (linea, est) in porDistrito { print("  - \(est.nombre) (\(linea.nombre))") }
        } else {
            for linea in [LineaMetro.l5, .l6] {
                if let c = linea.corredor,
                   c.distritos.contains(where: { normalizar($0) == normalizar(texto) }) {
                    print("\nEse distrito está en el corredor previsto de la \(linea.nombre),")
                    print("que aún no tiene estaciones publicadas.")
                }
            }
        }
        return
    }

    for destino in encontrados.prefix(8) {
        switch destino {
        case .estacion(let nombre):
            print("\n▸ Estación \(nombre)")
            for nodo in nodosDe(estacion: nombre) {
                let est = estacionDe(nodo)
                print("    \(nodo.linea.nombre) — \(ramalDe(nodo).nombre)")
                print("    Distrito: \(est.distrito)   |   \(est.estado.etiqueta)")
                if !est.puntosDeInteres.isEmpty {
                    print("    Cerca   : \(est.puntosDeInteres.joined(separator: ", "))")
                }
            }
            let cruces = conexiones.filter {
                normalizar($0.estacionA) == normalizar(nombre) || normalizar($0.estacionB) == normalizar(nombre)
            }
            for c in cruces { print("    Conexión: \(c.descripcion)") }

        case .lugar(let lugar):
            print("\n▸ \(lugar.nombre)  [\(lugar.categoria)]")
            print("    Distrito : \(lugar.distrito)")
            print("    Estación : \(lugar.estacion) (\(lugar.linea.nombre)), a \(lugar.metros) m")
            print("    A pie    : \(lugar.indicaciones)")
            if let extra = lugar.conexionAdicional { print("    Nota     : \(extra)") }
        }
    }
}

// ---- Opción 4
func mostrarConexiones() {
    separador("Conexiones entre líneas")
    print("\nSe muestran las conexiones declaradas y las detectadas automáticamente.\n")
    for c in conexionesCompletas() {
        let tipo = c.salirALaCalle ? "a pie, saliendo a la calle" : "dentro de la estación"
        print("• \(c.estacionA) (\(c.lineaA.nombre))  <->  \(c.estacionB) (\(c.lineaB.nombre))")
        print("    \(minutosATexto(c.minutos)) \(tipo)")
        print("    \(c.descripcion)\n")
    }
    print("""
    Ojo con un caso que confunde: "28 de Julio" existe en la Línea 2 y NO es
    la misma estación que ninguna de la Línea 1. El cruce real en esa zona es
    Gamarra (L1) con 28 de Julio (L2), caminando.
    """)
}

// ---- Opción 5
func planificarViaje() {
    separador("Planificar viaje")

    guard let textoOrigen = pedirTexto("¿Desde dónde sales? (estación, lugar o distrito)") else { return }
    guard let origen = elegirDestino(buscarDestinos(textoOrigen), texto: textoOrigen) else { return }

    guard let textoDestino = pedirTexto("¿A dónde vas? (estación, lugar o distrito)") else { return }
    guard let destino = elegirDestino(buscarDestinos(textoDestino), texto: textoDestino) else { return }

    if normalizar(origen.estacionObjetivo) == normalizar(destino.estacionObjetivo) {
        print("\nEl origen y el destino caen en la misma estación.")
        return
    }

    guard let iDia = pedirOpcion("¿Qué día viajas?",
                                 opciones: ["Lunes a sábado", "Domingo o feriado"]) else { return }
    let dia: DiaDeViaje = iDia == 0 ? .lunesASabado : .domingoOFeriado

    guard let horaTexto = pedirHora(), let horaSalida = textoAMinutos(horaTexto) else { return }

    let factor = factorDeCongestion(horaSalida, dia: dia)
    let grafo = construirGrafo(factor: factor)

    let nodosOrigen = nodosDe(estacion: origen.estacionObjetivo)
    let nodosDestino = nodosDe(estacion: destino.estacionObjetivo)

    guard let ruta = rutaMasRapida(desde: nodosOrigen, hasta: nodosDestino, grafo: grafo) else {
        print("""

        No hay una ruta posible con las estaciones registradas.
        Verifica que el origen y el destino pertenezcan a una línea
        con estaciones publicadas y conexiones disponibles.
        """)
        return
    }

    let (tramos, transbordos) = dividirEnTramos(ruta)
    let tarifa = calcularTarifa(tramos: tramos, pasajero: perfil.tipoPasajero, dia: dia)

    // --- Cabecera
    print("\n" + String(repeating: "-", count: 62))
    print("  PLAN DE VIAJE — \(perfil.nombre)")
    print(String(repeating: "-", count: 62))
    print("  Origen  : \(origen.titulo)")
    print("  Destino : \(destino.titulo)")
    print("  Día     : \(dia.nombre)   |   Salida: \(horaTexto)")
    print("  Pasajero: \(perfil.tipoPasajero.nombre)")

    // --- Itinerario
    print("\n  ITINERARIO")
    var paso = 1
    for (i, tramo) in tramos.enumerated() {
        let lista = tramo.estaciones
        print("\n  \(paso). Toma la \(tramo.linea.nombre) (\(tramo.linea.color)) en \"\(lista.first!.nombre)\"")
        print("     Sentido \(tramo.sentido) — \(tramo.cantidadDeEstaciones) estaciones, \(minutosATexto(tramo.minutos))")
        
        // Estaciones restantes
        let restantes = estacionesRestantes(
                tramos: tramos,
                tramoActual: i
            )

            print("     Estaciones restantes hasta destino: \(restantes)")
        
        if tramo.cantidadDeEstaciones > 1 {
            let intermedias = lista.dropFirst().dropLast().map { $0.nombre }
            if !intermedias.isEmpty {
                let muestra = intermedias.count <= 6
                    ? intermedias.joined(separator: " > ")
                    : intermedias.prefix(3).joined(separator: " > ")
                      + " > ... > " + intermedias.suffix(2).joined(separator: " > ")
                print("     Pasa por: \(muestra)")
            }
        }
        print("     Baja en \"\(lista.last!.nombre)\"")
        paso += 1

        if i < transbordos.count {
            let t = transbordos[i]
            print("\n  \(paso). Transbordo — \(minutosATexto(t.minutos))")
            print("     \(t.descripcion)")
            paso += 1
        }
    }

    // --- Tiempo
    let llegada = horaSalida + Int(ruta.minutos.rounded())
    print("\n  TIEMPO")
    print("    Duración estimada : \(minutosATexto(ruta.minutos))")
    print("    Llegada estimada  : \(horaATexto(llegada))")
    if factor > 1.0 {
        print("    Se aplicó un recargo de hora punta (+25%).")
    }

    // --- Tarifa
    print("\n  TARIFA")
    for cobro in tarifa.cobros {
        print("    \(soles(cobro.monto))  —  \(cobro.motivo)")
    }
    print("    ─────────")
    print("    TOTAL: \(soles(tarifa.total))")
    if tarifa.cobros.count > 1 {
        print("    Pagas más de un pasaje porque las líneas usan sistemas de recaudo distintos.")
    }
    if tarifa.hayEstimados {
        print("    Incluye líneas sin tarifa publicada: se usa la TIT (S/ 1.40) como referencia.")
    }

    // --- Tarjetas y saldo
    let faltantes = tarifa.tarjetasNecesarias.subtracting(perfil.tarjetas)
    if !faltantes.isEmpty {
        print("\n  TARJETAS QUE TE FALTAN")
        for s in faltantes {
            print("    \(s.nombre) — costo de la tarjeta: \(soles(s.costoDeLaTarjeta))")
        }
    }
    
    // --- Cobro del viaje
    
    var puedePagarTodo = true

    for cobro in tarifa.cobros {

        guard perfil.tarjetas.contains(cobro.sistema) else {

            print("\n⚠ Falta la tarjeta \(cobro.sistema.nombreCorto).")

            puedePagarTodo = false

            continue
        }

        if perfil.saldoDe(cobro.sistema) < cobro.monto {

            print("\n⚠ Saldo insuficiente en \(cobro.sistema.nombreCorto).")

            print("  Tienes: \(soles(perfil.saldoDe(cobro.sistema)))")

            print("  Necesitas: \(soles(cobro.monto))")

            puedePagarTodo = false
        }
    }

    // Si no puede pagar todo, NO realizamos ningún cobro.

    if !puedePagarTodo {

        print("\nNo se realizó el cobro.")

        print("Recarga las tarjetas necesarias desde la opción 9.")

    } else {

        // Ahora sí realizamos todos los cobros.

        for cobro in tarifa.cobros {

            let saldoAntes = perfil.saldoDe(cobro.sistema)

            _ = perfil.cobrar(
                cobro.sistema,
                monto: cobro.monto
            )

            let saldoDespues = perfil.saldoDe(cobro.sistema)

            print("\n✓ Pago realizado en \(cobro.sistema.nombreCorto)")

            print("  Saldo anterior: \(soles(saldoAntes))")

            print("  Cobro: \(soles(cobro.monto))")

            print("  Saldo restante: \(soles(saldoDespues))")
        }
    }
            

    // --- Horario
    print("\n  HORARIO")
    var lineasUsadas: [LineaMetro] = []
    for t in tramos where !lineasUsadas.contains(t.linea) { lineasUsadas.append(t.linea) }
    for linea in lineasUsadas {
        guard let apertura = linea.aperturaEnMinutos(dia), let cierre = linea.cierreEnMinutos(dia) else {
            print("    \(linea.nombre): sin horario oficial porque todavía no está en servicio.")
            continue
        }
        if horaSalida < apertura {
            print("    \(linea.nombre): abre a las \(horaATexto(apertura)). Sales antes de la apertura.")
        } else if horaSalida > cierre {
            print("    \(linea.nombre): cierra a las \(horaATexto(cierre)). Ya no hay servicio.")
        } else if llegada > cierre {
            print("    \(linea.nombre): cierra a las \(horaATexto(cierre)). "
                  + "Tu llegada estimada (\(horaATexto(llegada))) queda fuera del horario.")
        } else {
            print("    \(linea.nombre): \(horaATexto(apertura)) a \(horaATexto(cierre)). Sin problema.")
        }
    }

    // --- Indicaciones finales a pie
    if case .lugar(let lugar) = destino {
        print("\n  AL SALIR DE LA ESTACIÓN")
        print("    \(lugar.nombre) está a \(lugar.metros) m de \(lugar.estacion).")
        print("    \(lugar.indicaciones)")
        if let extra = lugar.conexionAdicional { print("    \(extra)") }
    }

    // --- Avisos (esto NO bloquea el plan, solo informa)
    var niveles = Set<NivelDeDatos>()
    for nodo in ruta.nodos { niveles.insert(estacionDe(nodo).estado) }
    let avisos = niveles.filter { $0 != .operativa }.compactMap { $0.avisoDeViaje }
    if !avisos.isEmpty {
        print("\n  ⚠ A TENER EN CUENTA")
        for aviso in avisos { print("    • \(aviso)") }
    }

    if let nota = perfil.tipoPasajero.nota { print("\n  Nota de tarifa: \(nota)") }

    perfil.historial.append(ViajeRegistrado(origen: origen.titulo, destino: destino.titulo,
                                            costo: tarifa.total, minutos: ruta.minutos, hora: horaTexto))
}

func elegirDestino(_ candidatos: [Destino], texto: String) -> Destino? {
    if candidatos.isEmpty {
        print("\nNo encontré \"\(texto)\".")
        let porDistrito = estacionesEn(distrito: texto)
        if !porDistrito.isEmpty {
            print("Hay estaciones en ese distrito:")
            for (linea, est) in porDistrito.prefix(10) { print("  - \(est.nombre) (\(linea.nombre))") }
            print("Vuelve a intentarlo con el nombre de una de ellas.")
        }
        return nil
    }
    if candidatos.count == 1 { return candidatos[0] }
    let opciones = candidatos.prefix(8).map { $0.titulo }
    guard let i = pedirOpcion("Encontré varias coincidencias. ¿Cuál es?", opciones: Array(opciones)) else { return nil }
    return candidatos[i]
}

// ---- Opción 6
func queHayCerca() {
    guard let texto = pedirTexto("¿De qué estación quieres ver los alrededores?") else { return }
    let nodos = nodosDe(estacion: texto)
    if nodos.isEmpty { print("\nNo encontré esa estación."); return }

    separador("Alrededores de \(estacionDe(nodos[0]).nombre)")
    let est = estacionDe(nodos[0])
    print("\nDistrito: \(est.distrito)")
    if !est.puntosDeInteres.isEmpty {
        print("\nEn la estación:")
        for poi in est.puntosDeInteres { print("  • \(poi)") }
    }
    let cercanos = lugaresDeLima.filter { normalizar($0.estacion) == normalizar(est.nombre) }
    if !cercanos.isEmpty {
        print("\nLugares registrados cerca:")
        for l in cercanos {
            print("  • \(l.nombre) — \(l.metros) m [\(l.categoria)]")
            print("    \(l.indicaciones)")
        }
    }
    if est.puntosDeInteres.isEmpty && cercanos.isEmpty {
        print("\nNo hay puntos de interés registrados para esta estación.")
    }
}

// ---- Opción 7
func mostrarTarifas() {
    separador("Tarifas y política de pago")
    print("""

    SISTEMAS DE RECAUDO
      Línea 1                   : tarjeta propia de la Línea 1 (costo \(soles(SistemaDePago.tarjetaLinea1.costoDeLaTarjeta)))
      Líneas 2, 3, 4 y futuras  : Tarjeta Interoperable de Transporte, TIT (costo \(soles(SistemaDePago.tarjetaInteroperable.costoDeLaTarjeta)))

    PASAJES (tarifa plana, no varía por distancia)
      Línea 1 : adulto \(soles(SistemaDePago.tarjetaLinea1.tarifaAdulto))  |  reducido \(soles(SistemaDePago.tarjetaLinea1.tarifaReducida))
      Línea 2 : adulto \(soles(SistemaDePago.tarjetaInteroperable.tarifaAdulto))  |  reducido \(soles(SistemaDePago.tarjetaInteroperable.tarifaReducida))
      Líneas 3 y 4: tarifa aún no publicada. Se usa la TIT como referencia.

    ¿LA TARJETA DE LA LÍNEA 1 SIRVE EN LA LÍNEA 2?
      No. Desde el 8 de julio de 2026 la TIT es obligatoria para entrar a las
      estaciones operativas de la Línea 2, y la Línea 1 mantiene su propio
      sistema de recaudo. Son dos tarjetas distintas y dos pagos distintos.
      Un viaje L1 -> L2 hoy cuesta \(soles(1.50)) + \(soles(1.40)) = \(soles(2.90)) para un adulto.

      La ATU busca extender la TIT a la Línea 1, el Metropolitano y los
      corredores complementarios, pero eso todavía no ocurre.

    CÓMO COBRA ESTE SIMULADOR
      Se cobra un pasaje al ingresar y otro cada vez que cambias de sistema
      de recaudo. Si dos líneas comparten la TIT se asume un solo pago; es
      un supuesto, porque la ATU aún no publica una tarifa integrada entre
      líneas del metro.

    MEDIO PASAJE
      Escolar y adulto mayor  : todos los días, con acreditación.
      Universitario/instituto : lunes a sábado. Domingos y feriados se cobra
                                tarifa adulto.
    """)
}

// ---- Opción 8
// MODIFICADO: horarios simplificados
func mostrarHorarios() {
    separador("Horarios")
    print("""

    Línea 1
      Lunes a sábado   : 05:00 - 22:00
      Domingos/feriados: 05:30 - 22:00

    Línea 2
      Horario similar al de la Línea 1.

    Línea 3
      Todavía no está en servicio. No tiene horario oficial.

    Línea 4
      Todavía no está completamente en servicio. No tiene horario oficial.

    Líneas 5 y 6
      Todavía no cuentan con estaciones publicadas ni servicio.

    --------------------------------------------------------------
    HORA PUNTA DEL SIMULADOR
    --------------------------------------------------------------
      Lunes a sábado: 06:30 - 09:00 y 17:00 - 20:00

    Si sales durante una hora punta, el simulador estima un 25%
    más de tiempo de viaje por la mayor demanda.

    IMPORTANTE:
      Este 25% es una estimación del simulador y no cambia la tarifa.
    """)
}

// ---- Opción 9
func gestionarPerfil() {
    while true {
        separador("Mi perfil")
        print("""

        Nombre   : \(perfil.nombre)
        Pasajero : \(perfil.tipoPasajero.nombre)
        Tarjetas : \(perfil.tarjetas.isEmpty ? "ninguna" : perfil.tarjetas.map { $0.nombreCorto }.joined(separator: ", "))
        """)
        for s in perfil.tarjetas.sorted(by: { $0.nombreCorto < $1.nombreCorto }) {
            print("           \(s.nombreCorto): saldo \(soles(perfil.saldoDe(s)))")
        }

        guard let opcion = pedirOpcion("¿Qué quieres hacer?", opciones: [
            "Cambiar nombre",
            "Cambiar tipo de pasajero",
            "Comprar o recargar tarjeta"
        ]) else { return }

        switch opcion {
        case 0:
            if let n = pedirTexto("Tu nombre:") { perfil.nombre = n }
        case 1:
            preguntarTipoPasajero()
        default:
            let sistemas: [SistemaDePago] = [.tarjetaLinea1, .tarjetaInteroperable]
            guard let i = pedirOpcion("¿Qué tarjeta?", opciones: sistemas.map { $0.nombre }) else { break }
            let sistema = sistemas[i]
            if !perfil.tarjetas.contains(sistema) {
                print("\nComprando la tarjeta por \(soles(sistema.costoDeLaTarjeta))...")
            }
            guard let montoTexto = pedirTexto("¿Cuánto recargas? (ej: 20)"),
                  let monto = Double(montoTexto.replacingOccurrences(of: ",", with: ".")),
                  monto > 0 else {
                print("Monto no válido."); break
            }
            perfil.recargar(sistema, monto: monto)
            print("Listo. Saldo de \(sistema.nombreCorto): \(soles(perfil.saldoDe(sistema)))")
        }
    }
}

// ---- Opción 10
func mostrarHistorial() {
    separador("Mis viajes de esta sesión")
    if perfil.historial.isEmpty {
        print("\nTodavía no has planificado ningún viaje.")
        return
    }
    for (i, v) in perfil.historial.enumerated() {
        print("\n\(i + 1). \(v.origen)  ->  \(v.destino)")
        print("   Salida \(v.hora) | \(minutosATexto(v.minutos)) | \(soles(v.costo))")
    }
    print("\nTotal gastado: \(soles(perfil.totalGastado)) en \(perfil.historial.count) viaje(s).")
}

// MARK: - Arranque y Menú

func preguntarTipoPasajero() {
    let tipos = TipoPasajero.allCases
    guard let i = pedirOpcion("¿Qué tipo de pasajero eres?", opciones: tipos.map { $0.nombre }) else { return }
    perfil.tipoPasajero = tipos[i]
    if let nota = tipos[i].nota { print("\n  " + nota) }
}

func configuracionInicial() {
    print("""

    ==============================================================
       METRO DE LIMA 2026 — SIMULADOR DE RED
    ==============================================================
    Antes de empezar, dos datos para calcular bien tus tarifas.
    """)
    if let n = pedirTexto("¿Cómo te llamas?", permitirCancelar: false) { perfil.nombre = n }
    preguntarTipoPasajero()
    print("\n¡Listo, \(perfil.nombre)! Puedes cambiar esto luego en la opción 9.")
}

// MODIFICADO: se eliminó el cambio entre RED ACTUAL y RED COMPLETA.
// Ahora todo el programa trabaja con las estaciones registradas.
func mostrarMenu() {
    print("""

    ==============================================================
       METRO DE LIMA 2026   |   \(perfil.nombre)   |   \(perfil.tipoPasajero == .adulto ? "Adulto" : "Medio pasaje")
       Red: ESTACIONES REGISTRADAS
    ==============================================================
     1. Ver líneas y estado del servicio
     2. Ver estaciones de una línea
     3. Buscar estación, lugar o distrito
     4. Ver conexiones entre líneas
     5. Planificar viaje
     6. ¿Qué hay cerca de una estación?
     7. Tarifas y política de pago
     8. Horarios
     9. Mi perfil y saldo
    10. Mis viajes de esta sesión
    11. Salir
    ==============================================================
    """)
    print("Elige una opción: ", terminator: "")
}

func pedirLinea() -> LineaMetro? {
    guard let texto = pedirTexto("Número de línea (1-6):") else { return nil }
    guard let n = Int(texto), let linea = LineaMetro(rawValue: n) else {
        print("Número de línea no válido.")
        return nil
    }
    return linea
}

func ejecutar() {
    configuracionInicial()

    var seguir = true
    while seguir {
        mostrarMenu()
        switch leer() {
        case "1":  listarLineas();                                  pausa()
        case "2":  if let l = pedirLinea() { mostrarEstaciones(de: l) }; pausa()
        case "3":  if let t = pedirTexto("¿Qué buscas?") { buscar(t) }; pausa()
        case "4":  mostrarConexiones();                              pausa()
        case "5":  planificarViaje();                                pausa()
        case "6":  queHayCerca();                                    pausa()
        case "7":  mostrarTarifas();                                 pausa()
        case "8":  mostrarHorarios();                                pausa()
        case "9":  gestionarPerfil()
        case "10": mostrarHistorial();                               pausa()
        case "11":
            print("\n¡Buen viaje, \(perfil.nombre)!")
            if !perfil.historial.isEmpty {
                print("Planificaste \(perfil.historial.count) viaje(s) por \(soles(perfil.totalGastado)).")
            }
            seguir = false
        default:
            print("Opción no válida. Elige un número del 1 al 11.")
        }
    }
}

ejecutar()

