import Foundation

struct FuenteHistorica: Hashable {
    let titulo: String
    let enlace: String

    var url: URL? {
        guard let url = URL(string: enlace), url.scheme == "https", url.host != nil else { return nil }
        return url
    }
}

struct DatoCurioso {
    let titulo: String
    let descripcion: String
    let fuentes: [FuenteHistorica]
}

struct ContenidoCultural {
    let datosCuriosos: [DatoCurioso]
    let legado: String
    let fuentesLegado: [FuenteHistorica]

    /// Mantiene las referencias en orden y evita mostrar un enlace varias veces.
    func referencias(incluyendo fuentePeriodo: FuenteHistorica) -> [FuenteHistorica] {
        let todas = [fuentePeriodo] + datosCuriosos.flatMap(\.fuentes) + fuentesLegado
        var enlaces = Set<String>()
        return todas.filter { enlaces.insert($0.enlace).inserted }
    }
}
