import Foundation

/// Intervalo educativo aproximado: años negativos para a. C., positivos para d. C.
/// Las fuentes y notas se conservan junto al dato para reutilizarlas en otras pantallas.
struct PeriodoHistorico {
    let inicio: Int
    let fin: Int
    let fuente: String
    let enlaceFuente: String
    let nota: String

    var texto: String {
        if inicio < 0 && fin < 0 {
            return "Aprox. \(abs(inicio))–\(abs(fin)) a. C."
        }
        if inicio > 0 && fin > 0 {
            return "Aprox. \(inicio)–\(fin) d. C."
        }
        return "Aprox. \(abs(inicio)) a. C.–\(fin) d. C."
    }

    /// Un límite compartido no demuestra coexistencia: se exige un intervalo común.
    func seSuperpone(con otro: PeriodoHistorico) -> Bool {
        max(inicio, otro.inicio) < min(fin, otro.fin)
    }
}
