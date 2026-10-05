//
//  VentaModel.swift
//  Semana06_Calculadora
//
//  Created by Adriana Chinchayhuara on 3/10/26.
//

import UIKit

class VentaModel: NSObject {
    var subtotal: Double = 0
    var igv: Double = 0
    var base: Double = 0
    var intereses: Double = 0
    var total: Double = 0
    var cuota: Double = 0

    var producto: String = ""
    var cantidad: Int = 0
    var meses: Int = 0
    var interesMensual: Double = 0

    override init() {
        super.init()
    }

    init(pSubtotal: Double, pIgv: Double, pBase: Double,
         pIntereses: Double, pTotal: Double, pCuota: Double) {
        self.subtotal = pSubtotal
        self.igv = pIgv
        self.base = pBase
        self.intereses = pIntereses
        self.total = pTotal
        self.cuota = pCuota
    }

    convenience init(producto: String = "", precioUnitario: Double, cantidad: Int,
                     meses: Int, interesMensual: Double) {
        let subtotal = precioUnitario * Double(cantidad)
        let igv = subtotal * 0.18
        let base = subtotal + igv
        let intereses = base * (interesMensual / 100) * Double(meses)
        let total = base + intereses
        let cuota = meses > 0 ? total / Double(meses) : 0

        self.init(pSubtotal: subtotal, pIgv: igv, pBase: base,
                  pIntereses: intereses, pTotal: total, pCuota: cuota)

        self.producto = producto
        self.cantidad = cantidad
        self.meses = meses
        self.interesMensual = interesMensual
    }
}
