import Foundation

// Prueba independiente del target iOS; no crea registros ni cambia Core Data.
@main
struct CalculoVentaTests {
    static func main() {
        let casos: [(String, String, String, String, String)] = [
            ("0", "Regular", "0", "36", "236"),
            ("999.99", "Regular", "0", "36", "236"),
            ("1000", "Frecuente", "0", "36", "236"),
            ("4999.99", "Frecuente", "0", "36", "236"),
            ("5000", "VIP", "20", "32.4", "212.4"),
            ("10000", "VIP", "20", "32.4", "212.4")
        ]
        for (acumulado, categoria, descuento, igv, total) in casos {
            let calculo = CalculoVenta(precio: 100, cantidad: 2, acumulado: Decimal(string: acumulado)!)
            precondition(calculo.categoria == categoria, "Categoría incorrecta en \(acumulado)")
            precondition(calculo.subtotal == 200)
            precondition(calculo.descuento == Decimal(string: descuento)!)
            precondition(calculo.igv == Decimal(string: igv)!)
            precondition(calculo.total == Decimal(string: total)!)
        }
        let decimal = CalculoVenta(precio: Decimal(string: "0.10")!, cantidad: 3, acumulado: 0)
        precondition(decimal.subtotal == Decimal(string: "0.30")!)
        precondition(decimal.total == Decimal(string: "0.354")!)
        let formato = NumberFormatter()
        formato.locale = Locale(identifier: "es_PE")
        formato.numberStyle = .decimal
        formato.minimumFractionDigits = 2
        formato.maximumFractionDigits = 2
        precondition(formato.string(from: NSDecimalNumber(decimal: decimal.total)) == "0.35")
        print("OK: límites Regular/Frecuente/VIP, descuento, IGV, total y presentación decimal.")
    }
}
