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
    @IBOutlet weak var btnCalcular: UIButton!

    private let txtProducto = UITextField()
    private let txtPrecio = UITextField()
    private let txtInteres = UITextField()
    private let lblCantidad = UILabel()
    private let lblCuotaEstimada = UILabel()
    private var botonesPlazo: [UIButton] = []

    private var cantidad = 1
    private var meses = 12
    private let plazos = [6, 12, 18, 24]
    private var ventaActual = VentaModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.subviews.forEach { $0.isHidden = true }
        view.backgroundColor = .fondoApp
        construirPantalla()
        actualizarCuota()

        let tap = UITapGestureRecognizer(target: self, action: #selector(cerrarTeclado))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Construcción de la pantalla

    private func construirPantalla() {
        let titulo = etiqueta("Nueva venta", tamano: 28, peso: .bold)
        let subtitulo = etiqueta("Completa los datos para calcular la cuota",
                                 tamano: 14, color: .textoSuave)

        configurarTexto(txtProducto, placeholder: "Ej. Refrigerador", teclado: .default)
        configurarTexto(txtPrecio, placeholder: "Ej. 1500.00", teclado: .decimalPad)
        configurarTexto(txtInteres, placeholder: "Ej. 3.5", teclado: .decimalPad)

        let campoProducto = crearCampo(titulo: "Electrodoméstico", icono: "shippingbox", campo: txtProducto)
        let campoPrecio = crearCampo(titulo: "Precio unitario", prefijo: "S/", campo: txtPrecio)
        let campoCantidad = crearStepper()
        campoCantidad.widthAnchor.constraint(equalToConstant: 130).isActive = true

        let filaPrecio = pila([campoPrecio, campoCantidad], eje: .horizontal, espacio: 10)
        filaPrecio.alignment = .top

        let campoPlazo = crearPlazos()
        let campoInteres = crearCampo(titulo: "Interés mensual", sufijo: "%", campo: txtInteres)
        let cajaCuota = crearCajaCuota()

        let contenido = pila([titulo, subtitulo, campoProducto, filaPrecio,
                              campoPlazo, campoInteres, cajaCuota], espacio: 14)
        contenido.setCustomSpacing(2, after: titulo)
        contenido.setCustomSpacing(8, after: subtitulo)

        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .interactive
        scroll.translatesAutoresizingMaskIntoConstraints = false
        contenido.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(contenido)

        let boton = crearBoton(titulo: "Calcular", icono: "equal.square",
                               fondo: .primario, texto: .white)
        boton.addTarget(self, action: #selector(calcular), for: .touchUpInside)
        boton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boton)

        let guia = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            boton.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: 18),
            boton.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -18),
            boton.bottomAnchor.constraint(equalTo: guia.bottomAnchor, constant: -12),

            scroll.topAnchor.constraint(equalTo: guia.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: boton.topAnchor, constant: -8),

            contenido.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 12),
            contenido.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -16),
            contenido.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 18),
            contenido.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -18),
            contenido.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -36)
        ])
    }

    private func configurarTexto(_ campo: UITextField, placeholder: String, teclado: UIKeyboardType) {
        campo.autocapitalizationType = .words
        campo.placeholder = placeholder
        campo.keyboardType = teclado
        campo.font = .systemFont(ofSize: 16)
        campo.textColor = .tinta
        campo.tintColor = .primario
        campo.addTarget(self, action: #selector(datosCambiaron), for: .editingChanged)
    }

    private func conTitulo(_ titulo: String, _ contenido: UIView) -> UIStackView {
        pila([etiqueta(titulo, tamano: 12, color: .textoSuave), contenido], espacio: 5)
    }

    private func cajaBlanca(_ interna: UIView) -> UIView {
        let caja = UIView()
        caja.backgroundColor = .white
        caja.layer.cornerRadius = 12
        fijar(interna, en: caja)
        caja.heightAnchor.constraint(equalToConstant: 46).isActive = true
        return caja
    }

    private func crearCampo(titulo: String, icono: String? = nil, prefijo: String? = nil,
                            sufijo: String? = nil, campo: UITextField) -> UIView {
        var elementos: [UIView] = []

        if let icono {
            let imagen = UIImageView(image: UIImage(systemName: icono))
            imagen.tintColor = .primario
            imagen.contentMode = .scaleAspectFit
            imagen.setContentHuggingPriority(.required, for: .horizontal)
            elementos.append(imagen)
        }
        if let prefijo {
            let l = etiqueta(prefijo, tamano: 16, peso: .medium, color: .primario)
            l.setContentHuggingPriority(.required, for: .horizontal)
            elementos.append(l)
        }
        elementos.append(campo)
        if let sufijo {
            let l = etiqueta(sufijo, tamano: 16, peso: .medium, color: .primario)
            l.setContentHuggingPriority(.required, for: .horizontal)
            elementos.append(l)
        }

        let fila = pila(elementos, eje: .horizontal, espacio: 8)
        fila.alignment = .center
        fila.isLayoutMarginsRelativeArrangement = true
        fila.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return conTitulo(titulo, cajaBlanca(fila))
    }

    private func crearStepper() -> UIView {
        let menos = UIButton(type: .system)
        menos.setImage(UIImage(systemName: "minus"), for: .normal)
        menos.tintColor = .primario
        menos.addTarget(self, action: #selector(restarCantidad), for: .touchUpInside)

        let mas = UIButton(type: .system)
        mas.setImage(UIImage(systemName: "plus"), for: .normal)
        mas.tintColor = .primario
        mas.addTarget(self, action: #selector(sumarCantidad), for: .touchUpInside)

        for b in [menos, mas] {
            b.widthAnchor.constraint(equalToConstant: 34).isActive = true
            b.heightAnchor.constraint(equalToConstant: 34).isActive = true
        }

        lblCantidad.text = "\(cantidad)"
        lblCantidad.font = .systemFont(ofSize: 16, weight: .medium)
        lblCantidad.textColor = .tinta
        lblCantidad.textAlignment = .center

        let fila = pila([menos, lblCantidad, mas], eje: .horizontal)
        fila.alignment = .center
        fila.distribution = .equalSpacing
        fila.isLayoutMarginsRelativeArrangement = true
        fila.layoutMargins = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        return conTitulo("Cantidad", cajaBlanca(fila))
    }

    private func crearPlazos() -> UIView {
        for plazo in plazos {
            let b = UIButton(type: .system)
            b.setTitle("\(plazo)", for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            b.layer.cornerRadius = 10
            b.tag = plazo
            b.heightAnchor.constraint(equalToConstant: 40).isActive = true
            b.addTarget(self, action: #selector(elegirPlazo(_:)), for: .touchUpInside)
            botonesPlazo.append(b)
        }
        let fila = pila(botonesPlazo, eje: .horizontal, espacio: 6)
        fila.distribution = .fillEqually
        actualizarPlazos()
        return conTitulo("Plazo en meses", fila)
    }

    private func crearCajaCuota() -> UIView {
        let texto = etiqueta("Cuota estimada", tamano: 13, color: .textoSuave)
        lblCuotaEstimada.font = .systemFont(ofSize: 18, weight: .semibold)
        lblCuotaEstimada.textColor = .primarioOscuro
        lblCuotaEstimada.textAlignment = .right

        let fila = pila([texto, lblCuotaEstimada], eje: .horizontal)
        fila.alignment = .center
        fila.isLayoutMarginsRelativeArrangement = true
        fila.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

        let caja = UIView()
        caja.backgroundColor = UIColor.primario.withAlphaComponent(0.12)
        caja.layer.cornerRadius = 12
        fijar(fila, en: caja)
        caja.heightAnchor.constraint(equalToConstant: 46).isActive = true
        return caja
    }

    // MARK: - Acciones

    @objc private func cerrarTeclado() { view.endEditing(true) }

    @objc private func datosCambiaron() { actualizarCuota() }

    @objc private func restarCantidad() {
        if cantidad > 1 { cantidad -= 1 }
        lblCantidad.text = "\(cantidad)"
        actualizarCuota()
    }

    @objc private func sumarCantidad() {
        if cantidad < 999 { cantidad += 1 }
        lblCantidad.text = "\(cantidad)"
        actualizarCuota()
    }

    @objc private func elegirPlazo(_ sender: UIButton) {
        meses = sender.tag
        actualizarPlazos()
        actualizarCuota()
    }

    private func actualizarPlazos() {
        for b in botonesPlazo {
            let seleccionado = b.tag == meses
            b.backgroundColor = seleccionado ? .primario : .white
            b.setTitleColor(seleccionado ? .white : .textoSuave, for: .normal)
        }
    }

    private func actualizarCuota() {
        if let precio = numero(txtPrecio.text), precio > 0, let tasa = numero(txtInteres.text) {
            let v = VentaModel(precioUnitario: precio, cantidad: cantidad,
                               meses: meses, interesMensual: tasa)
            lblCuotaEstimada.text = soles(v.cuota)
        } else {
            lblCuotaEstimada.text = "—"
        }
    }

    // MARK: - Validación y navegación

    private func numero(_ texto: String?) -> Double? {
        let limpio = (texto ?? "")
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        return Double(limpio)
    }

    private func revisar() -> (venta: VentaModel?, error: String?) {
        let nombre = (txtProducto.text ?? "").trimmingCharacters(in: .whitespaces)
        if nombre.isEmpty { return (nil, "Escribe el nombre del electrodoméstico.") }
        guard let precio = numero(txtPrecio.text), precio > 0 else {
            return (nil, "Ingresa un precio unitario mayor a 0.")
        }
        guard let tasa = numero(txtInteres.text), tasa >= 0 else {
            return (nil, "Ingresa el interés mensual (puede ser 0).")
        }
        let venta = VentaModel(producto: nombre, precioUnitario: precio,
                               cantidad: cantidad, meses: meses, interesMensual: tasa)
        return (venta, nil)
    }

    @objc private func calcular() {
        view.endEditing(true)
        let resultado = revisar()
        if let mensaje = resultado.error {
            let alerta = UIAlertController(title: "Faltan datos", message: mensaje, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Entendido", style: .default))
            present(alerta, animated: true)
            return
        }
        if let venta = resultado.venta {
            ventaActual = venta
            performSegue(withIdentifier: "showResultado", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado",
           let destino = segue.destination as? ResultadoViewController {
            destino.pVenta = ventaActual
        }
    }
}

#Preview {
    NuevaVentaViewController()
}
