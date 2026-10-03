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
}
