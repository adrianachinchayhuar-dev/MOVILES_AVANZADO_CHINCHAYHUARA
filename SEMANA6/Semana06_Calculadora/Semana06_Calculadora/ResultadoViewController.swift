//
//  ResultadoViewController.swift
//  Semana06_Calculadora
//
//  Created by Adriana Chinchayhuara on 3/10/26.
//

import UIKit

class ResultadoViewController: UIViewController {

    
    @IBOutlet weak var lblSubtotal: UILabel!
    
    @IBOutlet weak var lblIgv: UILabel!
    
    @IBOutlet weak var lblBase: UILabel!
    
    @IBOutlet weak var lblIntereses: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblCuota: UILabel!
    
    var pVenta: VentaModel = VentaModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblSubtotal.text = String(format: "S/. %.2f", pVenta.subtotal)
        lblIgv.text = String(format: "S/. %.2f", pVenta.igv)
        lblBase.text = String(format: "S/. %.2f", pVenta.base)
        lblIntereses.text = String(format: "S/. %.2f", pVenta.intereses)
        lblTotal.text = String(format: "S/. %.2f", pVenta.total)
        lblCuota.text = String(format: "S/. %.2f", pVenta.cuota)
    }

}
