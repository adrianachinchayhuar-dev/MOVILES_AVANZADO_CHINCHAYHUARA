//
//  ViewController.swift
//  CalculadoraPrestamos
//
//  Created by Adriana Chinchayhuara on 4/10/26.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var capitalTextField: UITextField!
    
    @IBOutlet weak var rateTextField: UITextField!
    
    @IBOutlet weak var yearsTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aplicarEstilo()
        
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        resultLabel.text = "Ingresa capital, tasa y plazo"

        // Teclado numérico con punto decimal
        capitalTextField.keyboardType = .decimalPad
        rateTextField.keyboardType = .decimalPad
        yearsTextField.keyboardType = .decimalPad

        // Tocar fuera de los campos cierra el teclado
        let tap = UITapGestureRecognizer(target: self, action: #selector(cerrarTeclado))
        view.addGestureRecognizer(tap)
    }
    
    @objc func cerrarTeclado() {
        view.endEditing(true)
    }
    
    private func aplicarEstilo() {
        // Fondo suave
        view.backgroundColor = UIColor(red: 0.95, green: 0.98, blue: 0.99, alpha: 1)

        // Campos de texto: blancos, redondeados, con borde y texto centrado
        for campo in [capitalTextField, rateTextField, yearsTextField] {
            campo?.borderStyle = .none
            campo?.backgroundColor = .white
            campo?.layer.cornerRadius = 10
            campo?.layer.borderWidth = 1
            campo?.layer.borderColor = UIColor.systemTeal.cgColor
            campo?.textAlignment = .center
            campo?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        }

        // Tarjeta de resultado
        resultLabel.backgroundColor = .white
        resultLabel.layer.cornerRadius = 16
        resultLabel.layer.masksToBounds = true
        resultLabel.layer.borderWidth = 1.5
        resultLabel.layer.borderColor = UIColor.systemTeal.cgColor
        resultLabel.textColor = UIColor(red: 0.0, green: 0.35, blue: 0.4, alpha: 1)
        resultLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

    @IBAction func calcularPrestamo(_ sender: Any) {
        
        view.endEditing(true)

        // 1. Leer datos (acepta coma o punto decimal)
        let capital   = leerNumero(capitalTextField)   // P
        let tasaAnual = leerNumero(rateTextField)      // % anual
        let anios     = leerNumero(yearsTextField)

        // 2. Validar
        if capital <= 0 || anios <= 0 || tasaAnual < 0 {
            resultLabel.text = "Por favor, ingresa valores válidos."
            return
        }

        // 3. Variables de la fórmula
        let r = (tasaAnual / 100) / 12      // tasa de interés mensual
        let n = anios * 12                  // número total de pagos

        // 4. Cuota mensual: M = P * r(1+r)^n / ((1+r)^n - 1)
        let cuota: Double
        if r == 0 {
            cuota = capital / n             // sin interés
        } else {
            let factor = pow(1 + r, n)
            cuota = capital * (r * factor) / (factor - 1)
        }

        // 5. Totales
        let totalPagar = cuota * n
        let intereses  = totalPagar - capital

        // 6. Mostrar resultado
        resultLabel.text = """
        Cuota mensual: \(String(format: "%.2f", cuota))
        Total a pagar: \(String(format: "%.2f", totalPagar))
        Intereses: \(String(format: "%.2f", intereses))
        """
    }
    
    // MARK: - Botón Limpiar
    @IBAction func limpiarCampos(_ sender: Any) {
        capitalTextField.text = ""
        rateTextField.text = ""
        yearsTextField.text = ""
        resultLabel.text = "Ingresa capital, tasa y plazo"
        view.endEditing(true)
    }

    // MARK: - Utilidad
    private func leerNumero(_ campo: UITextField) -> Double {
        let texto = (campo.text ?? "").replacingOccurrences(of: ",", with: ".")
        return Double(texto) ?? 0
    }
    
}

