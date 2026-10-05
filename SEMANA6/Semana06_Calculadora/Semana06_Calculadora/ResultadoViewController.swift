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
        overrideUserInterfaceStyle = .light
        view.subviews.forEach { $0.isHidden = true }
        view.backgroundColor = .fondoApp
        construirPantalla()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Construcción de la pantalla

    private func construirPantalla() {
        let venta = pVenta

        var configAtras = UIButton.Configuration.filled()
        configAtras.image = UIImage(systemName: "chevron.left")
        configAtras.baseBackgroundColor = .white
        configAtras.baseForegroundColor = .tinta
        configAtras.cornerStyle = .capsule
        let atras = UIButton(configuration: configAtras)
        atras.addTarget(self, action: #selector(volver), for: .touchUpInside)
        atras.widthAnchor.constraint(equalToConstant: 38).isActive = true
        atras.heightAnchor.constraint(equalToConstant: 38).isActive = true

        let titulo = etiqueta("Resultado", tamano: 24, peso: .bold)
        let cabecera = pila([atras, titulo], eje: .horizontal, espacio: 12)
        cabecera.alignment = .center

        let tasa = String(format: "%g", venta.interesMensual)
        let chips = pila([
            crearChip("\(venta.producto) x \(venta.cantidad)", flexible: true),
            crearChip("\(venta.meses) meses"),
            crearChip("\(tasa)% mensual"),
            UIView()
        ], eje: .horizontal, espacio: 6)

        let suave = UIColor.white.withAlphaComponent(0.85)
        let l1 = etiqueta("Cuota mensual", tamano: 13, color: suave)
        let l2 = etiqueta(soles(venta.cuota), tamano: 36, peso: .bold, color: .white)
        l2.adjustsFontSizeToFitWidth = true
        l2.minimumScaleFactor = 0.5
        let l3 = etiqueta("durante \(venta.meses) meses", tamano: 13, color: suave)
        let interior = pila([l1, l2, l3], espacio: 2)
        interior.isLayoutMarginsRelativeArrangement = true
        interior.layoutMargins = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        let tarjetaCuota = UIView()
        tarjetaCuota.backgroundColor = .primario
        tarjetaCuota.layer.cornerRadius = 18
        fijar(interior, en: tarjetaCuota)

        let filas = pila([
            fila("Subtotal", soles(venta.subtotal)), separador(),
            fila("IGV (18%)", soles(venta.igv)), separador(),
            fila("Base", soles(venta.base)), separador(),
            fila("Intereses", "+ " + soles(venta.intereses), colorValor: .interes), separador(),
            fila("Total", soles(venta.total), destacado: true)
        ])
        filas.isLayoutMarginsRelativeArrangement = true
        filas.layoutMargins = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let tarjetaDetalle = UIView()
        tarjetaDetalle.backgroundColor = .white
        tarjetaDetalle.layer.cornerRadius = 16
        fijar(filas, en: tarjetaDetalle)

        let contenido = pila([cabecera, chips, tarjetaCuota, tarjetaDetalle], espacio: 14)
        contenido.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contenido)

        let compartir = crearBoton(titulo: "Compartir", icono: "square.and.arrow.up",
                                   fondo: .white, texto: .primarioOscuro)
        compartir.addTarget(self, action: #selector(compartirResultado), for: .touchUpInside)
        let nueva = crearBoton(titulo: "Nueva venta", icono: "plus",
                               fondo: .primario, texto: .white)
        nueva.addTarget(self, action: #selector(volver), for: .touchUpInside)
        let botones = pila([compartir, nueva], eje: .horizontal, espacio: 8)
        botones.distribution = .fillEqually
        botones.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(botones)

        let guia = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            contenido.topAnchor.constraint(equalTo: guia.topAnchor, constant: 8),
            contenido.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: 18),
            contenido.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -18),

            botones.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: 18),
            botones.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -18),
            botones.bottomAnchor.constraint(equalTo: guia.bottomAnchor, constant: -12)
        ])
    }

    private func crearChip(_ texto: String, flexible: Bool = false) -> UIView {
        let l = etiqueta(texto, tamano: 12, color: .textoSuave)
        l.lineBreakMode = .byTruncatingTail
        let caja = UIView()
        caja.backgroundColor = .white
        caja.layer.cornerRadius = 13
        l.translatesAutoresizingMaskIntoConstraints = false
        caja.addSubview(l)
        NSLayoutConstraint.activate([
            l.topAnchor.constraint(equalTo: caja.topAnchor, constant: 6),
            l.bottomAnchor.constraint(equalTo: caja.bottomAnchor, constant: -6),
            l.leadingAnchor.constraint(equalTo: caja.leadingAnchor, constant: 10),
            l.trailingAnchor.constraint(equalTo: caja.trailingAnchor, constant: -10)
        ])
        caja.setContentHuggingPriority(.required, for: .horizontal)
        if flexible {
            caja.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        return caja
    }

    private func fila(_ titulo: String, _ valor: String,
                      colorValor: UIColor = .tinta, destacado: Bool = false) -> UIView {
        let peso: UIFont.Weight = destacado ? .semibold : .regular
        let tamano: CGFloat = destacado ? 17 : 14
        let izquierda = etiqueta(titulo, tamano: tamano, peso: peso,
                                 color: destacado ? .tinta : .textoSuave)
        let derecha = etiqueta(valor, tamano: tamano, peso: peso, color: colorValor)
        derecha.textAlignment = .right
        derecha.setContentHuggingPriority(.required, for: .horizontal)
        let f = pila([izquierda, derecha], eje: .horizontal)
        f.alignment = .center
        f.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return f
    }

    private func separador() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        v.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return v
    }

    // MARK: - Acciones

    @objc private func volver() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func compartirResultado() {
        let texto = """
        \(pVenta.producto) x \(pVenta.cantidad)
        Total: \(soles(pVenta.total))
        Cuota mensual: \(soles(pVenta.cuota)) por \(pVenta.meses) meses
        """
        let vc = UIActivityViewController(activityItems: [texto], applicationActivities: nil)
        present(vc, animated: true)
    }
}

#Preview {
    let vc = ResultadoViewController()
    vc.pVenta = VentaModel(producto: "Refrigerador", precioUnitario: 1500,
                           cantidad: 2, meses: 12, interesMensual: 3)
    return vc
}
