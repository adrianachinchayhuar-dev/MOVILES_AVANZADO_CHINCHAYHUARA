import Foundation

// Se conserva la precisión del cálculo; dos decimales solo para presentación.
// La guía no establece redondeo intermedio ni redondeo contable al persistir.
struct CalculoVenta {
    let categoria: String
    let subtotal: Decimal
    let descuento: Decimal
    let igv: Decimal
    let total: Decimal

    init(precio: Decimal, cantidad: Int64, acumulado: Decimal) {
        categoria = acumulado >= 5000 ? "VIP" : (acumulado >= 1000 ? "Frecuente" : "Regular")
        subtotal = precio * Decimal(cantidad)
        descuento = categoria == "VIP" ? subtotal * Decimal(string: "0.10")! : 0
        igv = (subtotal - descuento) * Decimal(string: "0.18")!
        total = subtotal - descuento + igv
    }
}
