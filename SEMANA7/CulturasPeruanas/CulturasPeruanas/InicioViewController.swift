import UIKit

class InicioViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inicio"
        let contenido = EstiloUI.contenido(en: self)
        contenido.addArrangedSubview(EstiloUI.etiqueta("DESCUBRE NUESTRO LEGADO",
            estilo: .caption1, color: EstiloUI.terracota))
        let titulo = EstiloUI.etiqueta("Culturas Peruanas", estilo: .largeTitle, serif: true)
        titulo.accessibilityTraits.insert(.header)
        contenido.addArrangedSubview(titulo)
        contenido.addArrangedSubview(EstiloUI.etiqueta(
            "Bienvenida a un recorrido por la historia del Perú.",
            estilo: .title3, color: EstiloUI.secundario))

        let imagen = UIImageView(image: UIImage(named: "caral"))
        imagen.contentMode = .scaleAspectFit
        imagen.backgroundColor = EstiloUI.beige
        imagen.layer.cornerRadius = 24
        imagen.clipsToBounds = true
        imagen.heightAnchor.constraint(equalToConstant: 190).isActive = true
        imagen.isAccessibilityElement = true
        imagen.accessibilityLabel = "Imagen de la cultura Caral"
        contenido.addArrangedSubview(imagen)
        contenido.addArrangedSubview(EstiloUI.etiqueta(
            "Conoce seis culturas, sus regiones y el legado que nos dejaron.",
            estilo: .body, color: EstiloUI.secundario))
        contenido.addArrangedSubview(acceso("Explorar culturas",
            descripcion: "Descubre las seis culturas peruanas", simbolo: "safari", seccion: .explorar))
        contenido.addArrangedSubview(acceso("Mis favoritas",
            descripcion: "Conoce esta sección en preparación", simbolo: "heart", seccion: .favoritos))
        contenido.addArrangedSubview(acceso("Línea de tiempo",
            descripcion: "Una mirada histórica, próximamente", simbolo: "clock", seccion: .lineaTiempo))
    }

    private func acceso(_ titulo: String, descripcion: String, simbolo: String,
                        seccion: SeccionPrincipal) -> UIButton {
        var configuracion = UIButton.Configuration.filled()
        configuracion.title = titulo
        configuracion.subtitle = descripcion
        configuracion.image = UIImage(systemName: simbolo)
        configuracion.imagePadding = 16
        configuracion.titlePadding = 6
        configuracion.baseBackgroundColor = EstiloUI.marfil
        configuracion.baseForegroundColor = EstiloUI.marron
        configuracion.background.cornerRadius = 22
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        configuracion.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var resultado = atributos
            resultado.font = EstiloUI.fuente(.headline, serif: true)
            return resultado
        }
        let boton = UIButton(configuration: configuracion, primaryAction: UIAction { [weak self] _ in
            self?.tabBarController?.selectedIndex = seccion.rawValue
        })
        boton.contentHorizontalAlignment = .leading
        boton.titleLabel?.numberOfLines = 0
        boton.subtitleLabel?.numberOfLines = 0
        boton.titleLabel?.adjustsFontForContentSizeCategory = true
        boton.subtitleLabel?.adjustsFontForContentSizeCategory = true
        boton.accessibilityLabel = titulo
        boton.accessibilityHint = "Abre la pestaña correspondiente. \(descripcion)."
        boton.heightAnchor.constraint(greaterThanOrEqualToConstant: 88).isActive = true
        return boton
    }
}
