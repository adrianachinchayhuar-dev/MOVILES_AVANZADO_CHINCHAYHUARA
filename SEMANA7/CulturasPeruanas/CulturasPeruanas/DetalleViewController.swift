import UIKit
import SafariServices

class DetalleViewController: UIViewController {
    var culturaSeleccionada: Cultura?
    private let favoritos = FavoritosStore.compartido
    private lazy var botonFavorito = UIBarButtonItem(
        image: UIImage(systemName: "heart"), style: .plain,
        target: self, action: #selector(alternarFavorito))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = culturaSeleccionada?.nombre
        configurarInterfaz()
        navigationItem.rightBarButtonItem = botonFavorito
        actualizarFavorito()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizarFavorito()
    }

    @objc private func alternarFavorito() {
        guard let cultura = culturaSeleccionada else { return }
        favoritos.alternar(cultura.id)
        actualizarFavorito()
    }

    private func actualizarFavorito() {
        guard let cultura = culturaSeleccionada else {
            botonFavorito.isEnabled = false
            return
        }
        let guardada = favoritos.contiene(cultura.id)
        botonFavorito.image = UIImage(systemName: guardada ? "heart.fill" : "heart")
        botonFavorito.tintColor = guardada ? EstiloUI.terracota : EstiloUI.secundario
        botonFavorito.accessibilityLabel = guardada ? "Quitar de favoritas" : "Agregar a favoritas"
        botonFavorito.accessibilityValue = guardada ? "Guardada" : "Sin guardar"
    }

    func configurarInterfaz() {
        let contenido = EstiloUI.contenido(en: self)
        guard let cultura = culturaSeleccionada else {
            contenido.addArrangedSubview(EstiloUI.etiqueta(
                "No se pudo cargar la cultura seleccionada.", estilo: .body))
            return
        }
        let imagen = UIImageView(image: UIImage(named: cultura.imagen))
        imagen.contentMode = .scaleAspectFit
        imagen.backgroundColor = EstiloUI.beige
        imagen.layer.cornerRadius = 24
        imagen.clipsToBounds = true
        imagen.heightAnchor.constraint(equalToConstant: 220).isActive = true
        imagen.isAccessibilityElement = true
        imagen.accessibilityLabel = "Imagen de la cultura \(cultura.nombre)"
        contenido.addArrangedSubview(imagen)
        contenido.addArrangedSubview(EstiloUI.etiqueta(
            "CULTURAS DEL PERÚ", estilo: .caption1, color: EstiloUI.terracota))
        let nombre = EstiloUI.etiqueta(cultura.nombre, estilo: .largeTitle, serif: true)
        nombre.accessibilityTraits.insert(.header)
        contenido.addArrangedSubview(nombre)
        contenido.addArrangedSubview(EstiloUI.etiqueta(
            "Región: \(cultura.region)", estilo: .headline, color: EstiloUI.secundario))
        let fuentePeriodo = FuenteHistorica(titulo: cultura.periodoHistorico.fuente,
                                             enlace: cultura.periodoHistorico.enlaceFuente)
        let referencias = cultura.contenidoCultural.referencias(incluyendo: fuentePeriodo)
        contenido.addArrangedSubview(EstiloUI.etiqueta(
            cultura.periodoHistorico.texto, estilo: .headline, color: EstiloUI.terracota))
        contenido.addArrangedSubview(EstiloUI.etiqueta(cultura.descripcion, estilo: .body))

        agregarTitulo("Datos curiosos", en: contenido)
        for dato in cultura.contenidoCultural.datosCuriosos {
            contenido.addArrangedSubview(TarjetaInformativaView(titulo: dato.titulo,
                descripcion: dato.descripcion, referencias: numeros(dato.fuentes, en: referencias)))
        }
        agregarTitulo("Legado cultural", en: contenido)
        contenido.addArrangedSubview(TarjetaInformativaView(titulo: "Una mirada a su legado",
            descripcion: cultura.contenidoCultural.legado,
            referencias: numeros(cultura.contenidoCultural.fuentesLegado, en: referencias)))
        agregarTitulo("Sobre estas fechas", en: contenido)
        contenido.addArrangedSubview(EstiloUI.etiqueta(
            cultura.periodoHistorico.nota + " " + numeros([fuentePeriodo], en: referencias),
            estilo: .footnote, color: EstiloUI.secundario))
        agregarTitulo("Fuentes consultadas", en: contenido)
        let enlaces = UIStackView()
        enlaces.axis = .vertical
        enlaces.spacing = 8
        for (indice, fuente) in referencias.enumerated() {
            enlaces.addArrangedSubview(botonFuente(fuente, numero: indice + 1))
        }
        contenido.addArrangedSubview(enlaces)
    }

    private func agregarTitulo(_ texto: String, en contenido: UIStackView) {
        let titulo = EstiloUI.etiqueta(texto, estilo: .title2, serif: true)
        titulo.accessibilityTraits.insert(.header)
        contenido.addArrangedSubview(titulo)
    }

    private func numeros(_ fuentes: [FuenteHistorica], en referencias: [FuenteHistorica]) -> String {
        fuentes.compactMap { fuente in
            referencias.firstIndex(where: { $0.enlace == fuente.enlace }).map { "[\($0 + 1)]" }
        }.joined(separator: " ")
    }

    private func botonFuente(_ fuente: FuenteHistorica, numero: Int) -> UIButton {
        var configuracion = UIButton.Configuration.plain()
        configuracion.title = "[\(numero)] \(fuente.titulo)"
        configuracion.image = UIImage(systemName: "arrow.up.right")
        configuracion.imagePlacement = .trailing
        configuracion.imagePadding = 10
        configuracion.baseForegroundColor = EstiloUI.terracota
        configuracion.background.backgroundColor = EstiloUI.marfil
        configuracion.background.cornerRadius = 14
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        configuracion.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var resultado = atributos
            resultado.font = EstiloUI.fuente(.subheadline)
            return resultado
        }
        let boton = UIButton(configuration: configuracion, primaryAction: UIAction { [weak self] _ in
            guard let self = self, let url = fuente.url, self.presentedViewController == nil else { return }
            let navegador = SFSafariViewController(url: url)
            self.present(navegador, animated: true)
        })
        boton.contentHorizontalAlignment = .leading
        boton.titleLabel?.numberOfLines = 0
        boton.titleLabel?.adjustsFontForContentSizeCategory = true
        boton.accessibilityTraits = .link
        boton.accessibilityLabel = "Fuente \(numero): \(fuente.titulo)"
        boton.accessibilityHint = "Abre la referencia en Safari. Requiere internet."
        boton.accessibilityIdentifier = "fuente:" + fuente.enlace
        boton.isEnabled = fuente.url != nil
        boton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        return boton
    }

}
