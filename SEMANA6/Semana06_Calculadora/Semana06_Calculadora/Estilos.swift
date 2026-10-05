//
//  Estilos.swift
//  Semana06_Calculadora
//
//  Created by Adriana Chinchayhuara on 4/10/26.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt32) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255,
                  green: CGFloat((hex >> 8) & 0xFF) / 255,
                  blue: CGFloat(hex & 0xFF) / 255,
                  alpha: 1)
    }
    static let fondoApp = UIColor(hex: 0xE6E8FF)
    static let primario = UIColor(hex: 0x5B54F0)
    static let primarioOscuro = UIColor(hex: 0x3B35B5)
    static let textoSuave = UIColor(hex: 0x4B4A7A)
    static let tinta = UIColor(hex: 0x1E1B4B)
    static let interes = UIColor(hex: 0xB45309)
}

func soles(_ valor: Double) -> String {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.minimumFractionDigits = 2
    f.maximumFractionDigits = 2
    f.locale = Locale(identifier: "es_PE")
    return "S/ " + (f.string(from: NSNumber(value: valor)) ?? "0.00")
}

func etiqueta(_ texto: String, tamano: CGFloat, peso: UIFont.Weight = .regular,
              color: UIColor = .tinta) -> UILabel {
    let l = UILabel()
    l.text = texto
    l.font = .systemFont(ofSize: tamano, weight: peso)
    l.textColor = color
    return l
}

func pila(_ vistas: [UIView], eje: NSLayoutConstraint.Axis = .vertical,
          espacio: CGFloat = 0) -> UIStackView {
    let s = UIStackView(arrangedSubviews: vistas)
    s.axis = eje
    s.spacing = espacio
    return s
}

func fijar(_ interna: UIView, en caja: UIView) {
    interna.translatesAutoresizingMaskIntoConstraints = false
    caja.addSubview(interna)
    NSLayoutConstraint.activate([
        interna.topAnchor.constraint(equalTo: caja.topAnchor),
        interna.bottomAnchor.constraint(equalTo: caja.bottomAnchor),
        interna.leadingAnchor.constraint(equalTo: caja.leadingAnchor),
        interna.trailingAnchor.constraint(equalTo: caja.trailingAnchor)
    ])
}

func crearBoton(titulo: String, icono: String, fondo: UIColor, texto: UIColor) -> UIButton {
    var config = UIButton.Configuration.filled()
    config.title = titulo
    config.image = UIImage(systemName: icono)
    config.imagePadding = 8
    config.baseBackgroundColor = fondo
    config.baseForegroundColor = texto
    config.cornerStyle = .fixed
    config.background.cornerRadius = 14
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
        var a = atributos
        a.font = .systemFont(ofSize: 16, weight: .medium)
        return a
    }
    let boton = UIButton(configuration: config)
    boton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    return boton
}
