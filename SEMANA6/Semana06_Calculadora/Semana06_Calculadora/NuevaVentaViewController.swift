//
//  NuevaVentaViewController.swift
//  Semana06_Calculadora
//
//  Created by Adriana Chinchayhuara on 3/10/26.
//

import UIKit

class NuevaVentaViewController: UIViewController {

    @IBOutlet weak var tfElectrodomestico: UITextField!
    
    @IBOutlet weak var tfPrecioUnitario: UITextField!
    
    @IBOutlet weak var tfCantidad: UITextField!
    
    @IBOutlet weak var tfMeses: UITextField!
    
    @IBOutlet weak var tfInteres: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado" {
            let destino = segue.destination as! ResultadoViewController

            let precioUnitario = Double(tfPrecioUnitario.text ?? "") ?? 0
            let cantidad = Double(tfCantidad.text ?? "") ?? 0
            let meses = Double(tfMeses.text ?? "") ?? 0
            let tasa = Double(tfInteres.text ?? "") ?? 0

            let subtotal = precioUnitario * cantidad
            let igv = subtotal * 0.18
            let base = subtotal + igv
            let intereses = base * (tasa / 100) * meses
            let total = base + intereses
            let cuota = meses > 0 ? total / meses : 0

            destino.pVenta = VentaModel(pSubtotal: subtotal, pIgv: igv, pBase: base,
                                        pIntereses: intereses, pTotal: total, pCuota: cuota)
        }
    }
    

    

}
