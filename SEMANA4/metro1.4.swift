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

// MARK: - Datos de la red
// L1, L2 y L3: estaciones reales (metrolima.net/mapa-metro-lima).
// L4, L5 y L6: aún proyectadas, sin estaciones oficiales -> datos representativos.
 
let redDelMetro: [LineaMetro: [Estacion]] = [
 
    .l1: [
        Estacion(nombre: "Villa El Salvador", distrito: "Villa El Salvador", puntosDeInteres: ["Parque Industrial de VES"]),
        Estacion(nombre: "Parque Industrial", distrito: "Villa El Salvador", puntosDeInteres: []),
        Estacion(nombre: "Pumacahua", distrito: "Villa El Salvador", puntosDeInteres: []),
        Estacion(nombre: "Villa María", distrito: "Villa María del Triunfo", puntosDeInteres: []),
        Estacion(nombre: "María Auxiliadora", distrito: "San Juan de Miraflores", puntosDeInteres: ["Hospital María Auxiliadora"]),
        Estacion(nombre: "San Juan", distrito: "San Juan de Miraflores", puntosDeInteres: []),
        Estacion(nombre: "Atocongo", distrito: "San Juan de Miraflores", puntosDeInteres: ["Open Plaza Atocongo"]),
        Estacion(nombre: "Jorge Chávez", distrito: "San Juan de Miraflores", puntosDeInteres: []),
        Estacion(nombre: "Ayacucho", distrito: "San Juan de Miraflores", puntosDeInteres: []),
        Estacion(nombre: "Cabitos", distrito: "Surco", puntosDeInteres: []),
        Estacion(nombre: "Angamos", distrito: "Surco", puntosDeInteres: ["Jockey Plaza (cercano)"]),
        Estacion(nombre: "San Borja Sur", distrito: "San Borja", puntosDeInteres: []),
        Estacion(nombre: "La Cultura", distrito: "San Borja", puntosDeInteres: ["Museo de la Nación"]),
        Estacion(nombre: "Arriola", distrito: "La Victoria", puntosDeInteres: []),
        Estacion(nombre: "Gamarra", distrito: "La Victoria", puntosDeInteres: ["Emporio Comercial de Gamarra"]),
        Estacion(nombre: "Miguel Grau", distrito: "La Victoria", puntosDeInteres: []),
        Estacion(nombre: "El Ángel", distrito: "El Agustino", puntosDeInteres: []),
        Estacion(nombre: "Presbítero Maestro", distrito: "Cercado de Lima", puntosDeInteres: ["Cementerio Presbítero Maestro"]),
        Estacion(nombre: "Caja de Agua", distrito: "San Juan de Lurigancho", puntosDeInteres: []),
        Estacion(nombre: "Pirámide del Sol", distrito: "San Juan de Lurigancho", puntosDeInteres: ["Huaca Mangomarca (cercana)"]),
        Estacion(nombre: "Los Jardines", distrito: "San Juan de Lurigancho", puntosDeInteres: []),
        Estacion(nombre: "Los Postes", distrito: "San Juan de Lurigancho", puntosDeInteres: []),
        Estacion(nombre: "San Carlos", distrito: "San Juan de Lurigancho", puntosDeInteres: []),
        Estacion(nombre: "San Martín", distrito: "San Juan de Lurigancho", puntosDeInteres: []),
        Estacion(nombre: "Santa Rosa", distrito: "San Juan de Lurigancho", puntosDeInteres: []),
        Estacion(nombre: "Bayóvar", distrito: "San Juan de Lurigancho", puntosDeInteres: ["Mercado Bayóvar"]),
    ],
 
    .l2: [
        Estacion(nombre: "Puerto del Callao", distrito: "Callao", puntosDeInteres: ["Muelle Guerra (cercano)"]),
        Estacion(nombre: "Buenos Aires", distrito: "Callao", puntosDeInteres: []),
        Estacion(nombre: "Juan Pablo II", distrito: "Callao", puntosDeInteres: []),
        Estacion(nombre: "Insurgentes", distrito: "Callao", puntosDeInteres: []),
        Estacion(nombre: "Carmen de La Legua", distrito: "Carmen de la Legua", puntosDeInteres: []),
        Estacion(nombre: "Óscar R. Benavides", distrito: "Cercado de Lima", puntosDeInteres: []),
        Estacion(nombre: "San Marcos", distrito: "Cercado de Lima", puntosDeInteres: ["Universidad Nacional Mayor de San Marcos"]),
        Estacion(nombre: "Elio", distrito: "Cercado de Lima", puntosDeInteres: []),
        Estacion(nombre: "La Alborada", distrito: "Cercado de Lima", puntosDeInteres: []),
        Estacion(nombre: "Tingo María", distrito: "Cercado de Lima", puntosDeInteres: []),
        Estacion(nombre: "Parque Murillo", distrito: "Cercado de Lima", puntosDeInteres: ["Parque de la Muralla (cercano)"]),
        Estacion(nombre: "Plaza Bolognesi", distrito: "Cercado de Lima", puntosDeInteres: ["Plaza Bolognesi"]),
        Estacion(nombre: "Central", distrito: "Cercado de Lima", puntosDeInteres: ["Centro Histórico de Lima", "Plaza San Martín (cercana)"]),
        Estacion(nombre: "Plaza Manco Cápac", distrito: "La Victoria", puntosDeInteres: ["Plaza Manco Cápac"]),
        Estacion(nombre: "Cangallo", distrito: "La Victoria", puntosDeInteres: []),
        Estacion(nombre: "28 de Julio", distrito: "La Victoria", puntosDeInteres: []),
        Estacion(nombre: "Nicolás Ayllón", distrito: "La Victoria", puntosDeInteres: []),
        Estacion(nombre: "Circunvalación", distrito: "El Agustino", puntosDeInteres: []),
        Estacion(nombre: "San Juan de Dios", distrito: "El Agustino", puntosDeInteres: []),
        Estacion(nombre: "Evitamiento", distrito: "Santa Anita", puntosDeInteres: []),
        Estacion(nombre: "Óvalo Santa Anita", distrito: "Santa Anita", puntosDeInteres: []),
        Estacion(nombre: "Colectora Industrial", distrito: "Santa Anita", puntosDeInteres: []),
        Estacion(nombre: "Hermilio Valdizán", distrito: "Santa Anita", puntosDeInteres: []),
        Estacion(nombre: "Mercado Santa Anita", distrito: "Santa Anita", puntosDeInteres: ["Mercado Mayorista de Santa Anita"]),
        Estacion(nombre: "Vista Alegre", distrito: "Ate", puntosDeInteres: []),
        Estacion(nombre: "Prolongación Javier Prado", distrito: "Ate", puntosDeInteres: []),
        Estacion(nombre: "Municipalidad de Ate", distrito: "Ate", puntosDeInteres: ["Municipalidad de Ate"]),
    ],
 
    .l3: [
        Estacion(nombre: "El Álamo", distrito: "Comas", puntosDeInteres: []),
        Estacion(nombre: "Huandoy", distrito: "Comas", puntosDeInteres: []),
        Estacion(nombre: "2 de Octubre", distrito: "Comas", puntosDeInteres: []),
        Estacion(nombre: "Villa Sol", distrito: "Comas", puntosDeInteres: []),
        Estacion(nombre: "Naranjal", distrito: "Los Olivos", puntosDeInteres: ["Real Plaza Naranjal"]),
        Estacion(nombre: "Carlos Izaguirre", distrito: "Los Olivos", puntosDeInteres: []),
        Estacion(nombre: "Tomás Valle", distrito: "Los Olivos", puntosDeInteres: []),
        Estacion(nombre: "Bartolomé de las Casas", distrito: "Independencia", puntosDeInteres: []),
        Estacion(nombre: "José Granda", distrito: "San Martín de Porres", puntosDeInteres: []),
        Estacion(nombre: "Caquetá", distrito: "Cercado de Lima", puntosDeInteres: []),
        Estacion(nombre: "Tacna", distrito: "Cercado de Lima", puntosDeInteres: ["Jirón de la Unión (cercano)"]),
        Estacion(nombre: "Garcilaso de la Vega", distrito: "Cercado de Lima", puntosDeInteres: ["Estadio Nacional"]),
        Estacion(nombre: "Central", distrito: "Cercado de Lima", puntosDeInteres: ["Centro Histórico de Lima", "Plaza San Martín (cercana)"]),
        Estacion(nombre: "Parque de la Reserva", distrito: "Cercado de Lima", puntosDeInteres: ["Circuito Mágico del Agua"]),
        Estacion(nombre: "Museo de Historia Natural", distrito: "Cercado de Lima", puntosDeInteres: ["Museo de Historia Natural"]),
        Estacion(nombre: "César Canevaro", distrito: "Lince", puntosDeInteres: []),
        Estacion(nombre: "Conde de San Isidro", distrito: "San Isidro", puntosDeInteres: []),
        Estacion(nombre: "Andrés Aramburú", distrito: "San Isidro", puntosDeInteres: []),
        Estacion(nombre: "Huaca Pucllana", distrito: "Miraflores", puntosDeInteres: ["Huaca Pucllana"]),
        Estacion(nombre: "Parque Central de Miraflores", distrito: "Miraflores", puntosDeInteres: ["Parque Central de Miraflores"]),
        Estacion(nombre: "Parque Reducto", distrito: "Miraflores", puntosDeInteres: ["Parque Reducto"]),
        Estacion(nombre: "República de Panamá", distrito: "Miraflores", puntosDeInteres: []),
        Estacion(nombre: "Juana Alarco", distrito: "Miraflores", puntosDeInteres: []),
        Estacion(nombre: "Alejandro Velasco", distrito: "Miraflores", puntosDeInteres: []),
        Estacion(nombre: "Las Gardenias", distrito: "Surco", puntosDeInteres: []),
        Estacion(nombre: "Los Héroes", distrito: "Surco", puntosDeInteres: []),
        Estacion(nombre: "Pedro Miotta", distrito: "Surco", puntosDeInteres: []),
    ],
 
    .l4: [
        Estacion(nombre: "Municipalidad de Ate (L4)", distrito: "Ate", puntosDeInteres: []),
        Estacion(nombre: "Santa Anita (L4)", distrito: "Santa Anita", puntosDeInteres: []),
        Estacion(nombre: "San Luis (L4)", distrito: "San Luis", puntosDeInteres: []),
        Estacion(nombre: "La Victoria (L4)", distrito: "La Victoria", puntosDeInteres: []),
        Estacion(nombre: "Breña (L4)", distrito: "Breña", puntosDeInteres: []),
        Estacion(nombre: "Callao (L4)", distrito: "Callao", puntosDeInteres: []),
    ],
 
    .l5: [
        Estacion(nombre: "Santiago de Surco (L5)", distrito: "Surco", puntosDeInteres: []),
        Estacion(nombre: "Chorrillos (L5)", distrito: "Chorrillos", puntosDeInteres: []),
        Estacion(nombre: "San Juan de Miraflores (L5)", distrito: "San Juan de Miraflores", puntosDeInteres: []),
        Estacion(nombre: "Villa El Salvador (L5)", distrito: "Villa El Salvador", puntosDeInteres: []),
    ],
 
    .l6: [
        Estacion(nombre: "Los Olivos (L6)", distrito: "Los Olivos", puntosDeInteres: []),
        Estacion(nombre: "San Martín de Porres (L6)", distrito: "San Martín de Porres", puntosDeInteres: []),
        Estacion(nombre: "Cercado de Lima (L6)", distrito: "Cercado de Lima", puntosDeInteres: []),
        Estacion(nombre: "San Isidro (L6)", distrito: "San Isidro", puntosDeInteres: []),
        Estacion(nombre: "Surco (L6)", distrito: "Surco", puntosDeInteres: []),
    ],
]

// MARK: - Funciones de consulta
 
// RF-1
func listarLineas() {
    print("\n=== LÍNEAS DEL METRO DE LIMA ===")
    for linea in LineaMetro.allCases {
        print("\(linea.nombre)  |  Color: \(linea.color)  |  Estado: \(linea.estado)")
        print("   Recorrido: \(linea.recorrido)")
    }
}

// RF-2
func mostrarEstaciones(de linea: LineaMetro) {
    let estaciones = redDelMetro[linea] ?? []
    print("\n=== ESTACIONES DE \(linea.nombre.uppercased()) (\(linea.color)) ===")
    print("Total: \(estaciones.count)\n")
    for (indice, estacion) in estaciones.enumerated() {
        print("\(indice + 1). \(estacion.nombre) - \(estacion.distrito)")
    }
}

// Busca en qué líneas aparece una estación (por nombre). Base para RF-3, RF-4 y RF-5.
func lineasQuePasanPor(estacion nombreBuscado: String) -> [LineaMetro] {
    let nombreNormalizado = nombreBuscado.trimmingCharacters(in: .whitespaces).lowercased()
    return LineaMetro.allCases.filter { linea in
        (redDelMetro[linea] ?? []).contains { $0.nombre.lowercased() == nombreNormalizado }
    }
}

// RF-3
func buscarEstacion(nombre nombreBuscado: String) {
    let nombreNormalizado = nombreBuscado.trimmingCharacters(in: .whitespaces).lowercased()
    var encontrada = false
 
    print("\n=== RESULTADO DE BÚSQUEDA: \"\(nombreBuscado)\" ===")
 
    for linea in LineaMetro.allCases {
        for estacion in redDelMetro[linea] ?? [] where estacion.nombre.lowercased() == nombreNormalizado {
            encontrada = true
            print("\nEstación: \(estacion.nombre)")
            print("Distrito: \(estacion.distrito)")
            print("Pertenece a: \(linea.nombre) (\(linea.color))")
            let pois = estacion.puntosDeInteres.isEmpty ? "sin registro" : estacion.puntosDeInteres.joined(separator: ", ")
            print("Puntos de interés cercanos: \(pois)")
        }
    }
 
    if !encontrada {
        print("No se encontró ninguna estación con ese nombre. Revisa la ortografía (incluye tildes).")
        return
    }
 
    let lineas = lineasQuePasanPor(estacion: nombreBuscado)
    if lineas.count > 1 {
        print("\n>> Estación de INTERCAMBIO: aquí se cruzan \(lineas.map { $0.nombre }.joined(separator: " y ")).")
    }
}
 
// MARK: - Menú en consola
 
func mostrarMenu() {
    print("""
 
    ============================================
       METRO DE LIMA 2026 - SIMULADOR DE RED
    ============================================
    1. Ver todas las líneas
    2. Ver estaciones de una línea
    3. Buscar una estación (detalles y puntos de interés)
    6. Salir
    ============================================
    Elige una opción:
""")
}

func pedirLinea() -> LineaMetro? {
    print("Ingresa el número de línea (1-6):")
    guard let entrada = readLine(), let numero = Int(entrada), let linea = LineaMetro(rawValue: numero) else {
        print("Número de línea no válido.")
        return nil
    }
    return linea
}
 
var continuarEjecucion = true
 
while continuarEjecucion {
    mostrarMenu()
    let opcion = readLine() ?? ""
 
    switch opcion {
    case "1":
        listarLineas()
    case "2":
            if let linea = pedirLinea() {mostrarEstaciones(de: linea) }
    case "3":
            print("Ingresa el nombre de la estación a buscar:")
            buscarEstacion(nombre: readLine() ?? "")
    case "6":
        print("¡Gracias por usar el simulador del Metro de Lima!")
        continuarEjecucion = false
    default:
        print("Opción no válida.")
    }
}

