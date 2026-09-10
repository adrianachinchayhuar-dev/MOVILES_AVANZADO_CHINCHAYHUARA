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
    
    // MARK: Tarifas (RF-6)
    // L1: pasaje adulto S/ 1.50, medio pasaje S/ 0.75, tarifa plana (no varía por distancia),
    //     se paga con la tarjeta propia de la Línea 1.
    // L2: pasaje adulto S/ 1.40, tarifa plana, se paga con la Tarjeta Interoperable de
    //     Transporte (TIT). La ATU aún no publica una tarifa "medio pasaje" oficial
    //     para L2 a la fecha de este ejercicio -> se estima proporcional a la de adultos.
    // L3-L6: aún no tienen tarifa oficial (líneas proyectadas) -> se usa como referencia
    //     la tarifa de L1, marcada como estimada.
    var tarifaAdulto: Double {
        switch self {
        case .l1: return 1.50
        case .l2: return 1.40
        case .l3, .l4, .l5, .l6: return 1.50 // estimado (línea aún proyectada)
        }
    }
     
    var tarifaMedioPasaje: Double {
        switch self {
        case .l1: return 0.75
        case .l2: return 0.70 // estimado, proporcional (sin cifra oficial publicada por ATU)
        case .l3, .l4, .l5, .l6: return 0.75 // estimado
        }
    }
     
    var tarifaEsOficial: Bool {
        switch self {
        case .l1, .l2: return true
        case .l3, .l4, .l5, .l6: return false
        }
    }
     
    // Sistema/tarjeta con el que se paga cada línea. Es la base para decidir si un
    // transbordo implica pago único o pago doble (ver calcularTarifaDeViaje).
    var sistemaDePago: String {
        switch self {
        case .l1: return "Tarjeta propia Línea 1"
        case .l2, .l3, .l4, .l5, .l6: return "Tarjeta Interoperable de Transporte (TIT)"
        }
    }
     
    // MARK: Tiempos de viaje (RF-7)
    // Estimación gruesa de minutos promedio entre estaciones consecutivas,
    // calculada a partir de la duración total aproximada de cada línea real
    var minutosPromedioPorEstacion: Double {
        switch self {
        case .l1: return 1.8
        case .l2: return 2.0
        case .l3, .l4, .l5, .l6: return 2.0 // estimado
        }
    }
}
     
// Minutos fijos que se asumen para bajar del tren, caminar al andén de la otra
// línea y esperar el siguiente tren en una estación de intercambio.
let minutosPromedioTransbordo = 5.0
     
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
        Estacion(nombre: "28 de Julio", distrito: "La Victoria", puntosDeInteres: []),
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
        Estacion(nombre: "Cabitos", distrito: "Surco", puntosDeInteres: []),
        Estacion(nombre: "Las Gardenias", distrito: "Surco", puntosDeInteres: []),
        Estacion(nombre: "Los Héroes", distrito: "Surco", puntosDeInteres: []),
        Estacion(nombre: "Pedro Miotta", distrito: "Surco", puntosDeInteres: []),
    ],
 
    // Línea 4: las primeras 8 son el Ramal Faucett-Gambetta, en construcción real (avance 53% a ene-2026).
    // Las 3 últimas son puntos de cruce confirmados por ATU/MTC con el resto de la red (jun-jul 2026);
    // el trazado completo hacia el este (28 estaciones anunciadas) aún no tiene nombres oficiales publicados.
    .l4: [
        Estacion(nombre: "Gambetta", distrito: "Callao", puntosDeInteres: []),
        Estacion(nombre: "Canta Callao", distrito: "Callao", puntosDeInteres: []),
        Estacion(nombre: "Bocanegra", distrito: "Callao", puntosDeInteres: []),
        Estacion(nombre: "Aeropuerto", distrito: "Callao", puntosDeInteres: ["Aeropuerto Internacional Jorge Chávez"]),
        Estacion(nombre: "El Olivar", distrito: "Callao", puntosDeInteres: []),
        Estacion(nombre: "Quilca", distrito: "Callao", puntosDeInteres: []),
        Estacion(nombre: "Morales Duárez", distrito: "Callao", puntosDeInteres: []),
        Estacion(nombre: "Carmen de La Legua", distrito: "Carmen de la Legua", puntosDeInteres: []),
        Estacion(nombre: "Conde de San Isidro", distrito: "San Isidro", puntosDeInteres: []),
        Estacion(nombre: "La Cultura", distrito: "San Borja", puntosDeInteres: ["Museo de la Nación"]),
        Estacion(nombre: "Mercado Santa Anita", distrito: "Santa Anita", puntosDeInteres: ["Mercado Mayorista de Santa Anita"]),
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

// RF-4: agrupa estaciones por nombre y se queda con las que están en más de una línea.
func mostrarIntercambios() {
    var estacionALineas: [String: [LineaMetro]] = [:]
    for linea in LineaMetro.allCases {
        for estacion in redDelMetro[linea] ?? [] {
            estacionALineas[estacion.nombre, default: []].append(linea)
        }
    }
 
    let intercambios = estacionALineas.filter { $0.value.count > 1 }
    print("\n=== ESTACIONES DE INTERCAMBIO ENTRE LÍNEAS ===")
    if intercambios.isEmpty {
        print("Actualmente no hay estaciones compartidas entre líneas.")
        return
    }
    for (nombre, lineas) in intercambios.sorted(by: { $0.key < $1.key }) {
        let nombresLineas = lineas.sorted { $0.rawValue < $1.rawValue }.map { $0.nombre }
        print("\(nombre): conecta \(nombresLineas.joined(separator: " <-> "))")
    }
}

// RF-6: calcula el costo de un viaje. Si origen y destino comparten el mismo
func indiceDeEstacion(_ nombre: String, en linea: LineaMetro) -> Int? {
    let nombreNormalizado = nombre.trimmingCharacters(in: .whitespaces).lowercased()
    return (redDelMetro[linea] ?? []).firstIndex { $0.nombre.lowercased() == nombreNormalizado }
}

func formatoSoles(_ monto: Double) -> String {
    String(format: "%.2f", monto)
}

func calcularTarifaDeViaje(lineaOrigen: LineaMetro, lineaDestino: LineaMetro) -> (costo: Double, detalle: String) {
    if lineaOrigen == lineaDestino {
        let etiqueta = lineaOrigen.tarifaEsOficial ? "" : " (tarifa estimada)"
        return (lineaOrigen.tarifaAdulto,
                "Viaje directo en \(lineaOrigen.nombre): S/ \(formatoSoles(lineaOrigen.tarifaAdulto))\(etiqueta), pago único.")
    }
 
    if lineaOrigen.sistemaDePago == lineaDestino.sistemaDePago {
        let costo = lineaDestino.tarifaAdulto
        return (costo,
                "Ambas líneas usan el mismo medio de pago (\(lineaDestino.sistemaDePago)): se considera pago único de S/ \(formatoSoles(costo)).")
    } else {
        let costo = lineaOrigen.tarifaAdulto + lineaDestino.tarifaAdulto
        return (costo,
                "\(lineaOrigen.nombre) (\(lineaOrigen.sistemaDePago)) y \(lineaDestino.nombre) (\(lineaDestino.sistemaDePago)) todavía usan sistemas de pago distintos: " +
                "se paga cada tramo por separado -> S/ \(formatoSoles(lineaOrigen.tarifaAdulto)) + S/ \(formatoSoles(lineaDestino.tarifaAdulto)) = S/ \(formatoSoles(costo)).")
    }
}
 
// RF-7: estima el tiempo de viaje sumando minutos por estación recorrida en
// cada tramo, más un tiempo fijo de transbordo si aplica.
func estimarTiempoDeViaje(lineaOrigen: LineaMetro, indiceOrigen: Int,
                           lineaDestino: LineaMetro, indiceDestino: Int,
                           indiceTransbordoOrigen: Int? = nil,
                           indiceTransbordoDestino: Int? = nil) -> (minutos: Double, detalle: String) {
    if lineaOrigen == lineaDestino {
        let estaciones = abs(indiceDestino - indiceOrigen)
        let minutos = Double(estaciones) * lineaOrigen.minutosPromedioPorEstacion
        return (minutos, "\(estaciones) estación(es) x \(lineaOrigen.minutosPromedioPorEstacion) min ≈ \(String(format: "%.0f", minutos)) min.")
    }
 
    guard let iTransbordoOrigen = indiceTransbordoOrigen, let iTransbordoDestino = indiceTransbordoDestino else {
        return (0, "No se pudo estimar el tiempo (falta la estación de transbordo).")
    }
 
    let estacionesTramo1 = abs(iTransbordoOrigen - indiceOrigen)
    let estacionesTramo2 = abs(indiceDestino - iTransbordoDestino)
    let minutosTramo1 = Double(estacionesTramo1) * lineaOrigen.minutosPromedioPorEstacion
    let minutosTramo2 = Double(estacionesTramo2) * lineaDestino.minutosPromedioPorEstacion
    let total = minutosTramo1 + minutosTramo2 + minutosPromedioTransbordo
 
    let detalle = "Tramo 1: \(estacionesTramo1) estación(es) en \(lineaOrigen.nombre) ≈ \(String(format: "%.0f", minutosTramo1)) min. " +
        "Transbordo ≈ \(String(format: "%.0f", minutosPromedioTransbordo)) min. " +
        "Tramo 2: \(estacionesTramo2) estación(es) en \(lineaDestino.nombre) ≈ \(String(format: "%.0f", minutosTramo2)) min. " +
        "Total estimado ≈ \(String(format: "%.0f", total)) min."
    return (total, detalle)
}

// RF-5: máximo 1 transbordo (ver README, sección "Limitaciones").
func planificarViaje(origen nombreOrigen: String, destino textoBuscado: String) {
    let destinoNormalizado = textoBuscado.trimmingCharacters(in: .whitespaces).lowercased()
 
    let lineasOrigen = lineasQuePasanPor(estacion: nombreOrigen)
    if lineasOrigen.isEmpty {
        print("\nNo encontré la estación de origen \"\(nombreOrigen)\". Verifica el nombre.")
        return
    }
 
    // Destino: puede ser el nombre de una estación o un punto de interés dentro de ella.
    var estacionDestino: Estacion?
    var lineaDestino: LineaMetro?
    for linea in LineaMetro.allCases {
        for estacion in redDelMetro[linea] ?? [] {
            let coincide = estacion.nombre.lowercased() == destinoNormalizado
                || estacion.puntosDeInteres.contains { $0.lowercased().contains(destinoNormalizado) }
            if coincide {
                estacionDestino = estacion
                lineaDestino = linea
                break
            }
        }
        if estacionDestino != nil { break }
    }
 
    guard let destino = estacionDestino, let lineaDelDestino = lineaDestino else {
        print("\nNo encontré \"\(textoBuscado)\" ni como estación ni como punto de interés registrado.")
        return
    }
 
    print("\n=== PLAN DE VIAJE ===")
    print("Origen: \(nombreOrigen)  (\(lineasOrigen.map { $0.nombre }.joined(separator: ", ")))")
    print("Destino: \(destino.nombre)  (\(lineaDelDestino.nombre))")
 
    if lineasOrigen.contains(lineaDelDestino) {
        print("\nNo necesitas transbordo. Toma la \(lineaDelDestino.nombre) y baja en \"\(destino.nombre)\".")
 
        let (costo, detalleCosto) = calcularTarifaDeViaje(lineaOrigen: lineaDelDestino, lineaDestino: lineaDelDestino)
        print("\n[Tarifa] \(detalleCosto)")
        _ = costo
 
        if let iOrigen = indiceDeEstacion(nombreOrigen, en: lineaDelDestino),
           let iDestino = indiceDeEstacion(destino.nombre, en: lineaDelDestino) {
            let (_, detalleTiempo) = estimarTiempoDeViaje(lineaOrigen: lineaDelDestino, indiceOrigen: iOrigen,
                                                            lineaDestino: lineaDelDestino, indiceDestino: iDestino)
            print("[Tiempo estimado] \(detalleTiempo)")
        }
        return
    }
 
    for lineaOrigen in lineasOrigen {
        let estacionesDestino = redDelMetro[lineaDelDestino] ?? []
        for estacionO in redDelMetro[lineaOrigen] ?? [] {
            if estacionesDestino.contains(where: { $0.nombre == estacionO.nombre }) {
                print("\nNecesitas 1 transbordo:")
                print("1. Toma la \(lineaOrigen.nombre) desde \"\(nombreOrigen)\".")
                print("2. Bájate en \"\(estacionO.nombre)\" (estación de intercambio).")
                print("3. Transborda a la \(lineaDelDestino.nombre).")
                print("4. Continúa hasta bajar en \"\(destino.nombre)\".")
 
                let (_, detalleCosto) = calcularTarifaDeViaje(lineaOrigen: lineaOrigen, lineaDestino: lineaDelDestino)
                print("\n[Tarifa] \(detalleCosto)")
 
                if let iOrigen = indiceDeEstacion(nombreOrigen, en: lineaOrigen),
                   let iTransbordoOrigen = indiceDeEstacion(estacionO.nombre, en: lineaOrigen),
                   let iTransbordoDestino = indiceDeEstacion(estacionO.nombre, en: lineaDelDestino),
                   let iDestino = indiceDeEstacion(destino.nombre, en: lineaDelDestino) {
                    let (_, detalleTiempo) = estimarTiempoDeViaje(lineaOrigen: lineaOrigen, indiceOrigen: iOrigen,
                                                                    lineaDestino: lineaDelDestino, indiceDestino: iDestino,
                                                                    indiceTransbordoOrigen: iTransbordoOrigen,
                                                                    indiceTransbordoDestino: iTransbordoDestino)
                    print("[Tiempo estimado] \(detalleTiempo)")
                }
                return
            }
        }
    }
 
    print("\nNo encontré conexión con un solo transbordo entre \(lineasOrigen.map { $0.nombre }.joined(separator: ", ")) y \(lineaDelDestino.nombre).")
    print("Podría requerir dos o más transbordos (fuera del alcance de este ejercicio).")
}

// RF-6 (vista dedicada): muestra la tabla de tarifas de todas las líneas y
// explica la política de pago en transbordos.
func mostrarTarifas() {
    print("\n=== TARIFAS DEL METRO DE LIMA ===")
    for linea in LineaMetro.allCases {
        let etiqueta = linea.tarifaEsOficial ? "oficial" : "estimada, línea aún proyectada"
        print("\(linea.nombre): Adulto S/ \(formatoSoles(linea.tarifaAdulto)) | Medio pasaje S/ \(formatoSoles(linea.tarifaMedioPasaje)) | \(linea.sistemaDePago) (\(etiqueta))")
    }
    print("""
 
    Política de transbordo:
    - Si ambas líneas de tu viaje usan el mismo sistema de tarjeta, se cobra
      UN SOLO pasaje para todo el viaje.
    - Si usan sistemas distintos (hoy, por ejemplo, Línea 1 con su tarjeta
      propia frente a Línea 2 y las demás con la TIT), se paga CADA PASAJE
      POR SEPARADO al hacer el transbordo. Esto puede cambiar conforme
      avance la integración tarifaria de la ATU.
""")
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
    4. Ver estaciones de intercambio entre líneas
    5. Planificar viaje (origen -> destino / punto de interés)
    6. Ver tarifas y política de transbordo
    7. Salir
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
    case "4":
            mostrarIntercambios()
    case "5":
                print("Ingresa tu estación de origen:")
                let origen = readLine() ?? ""
                print("Ingresa tu destino (nombre de estación o punto de interés, ej: 'Estadio Nacional'):")
                let destino = readLine() ?? ""
                planificarViaje(origen: origen, destino: destino)
        case "6":
                mostrarTarifas()
        case "7":
            print("¡Gracias por usar el simulador del Metro de Lima!")
            continuarEjecucion = false
        default:
            print("Opción no válida.")
        }
    }

