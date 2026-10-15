import UIKit

/// Identidad visual común de las pantallas de la primera etapa.
enum EstiloUI {
    static let crema = UIColor(red: 0.96, green: 0.93, blue: 0.87, alpha: 1)
    static let marfil = UIColor(red: 1, green: 0.98, blue: 0.94, alpha: 1)
    static let beige = UIColor(red: 0.91, green: 0.86, blue: 0.77, alpha: 1)
    static let marron = UIColor(red: 0.20, green: 0.14, blue: 0.10, alpha: 1)
    static let secundario = UIColor(red: 0.40, green: 0.30, blue: 0.23, alpha: 1)
    static let terracota = UIColor(red: 0.65, green: 0.23, blue: 0.13, alpha: 1)

    static func fuente(_ estilo: UIFont.TextStyle, serif: Bool = false) -> UIFont {
        let base = UIFont.preferredFont(forTextStyle: estilo)
        guard serif, let descriptor = base.fontDescriptor.withDesign(.serif) else { return base }
        return UIFont(descriptor: descriptor, size: 0)
    }

    static func etiqueta(_ texto: String, estilo: UIFont.TextStyle,
                         serif: Bool = false, color: UIColor = marron) -> UILabel {
        let label = UILabel()
        label.text = texto
        label.font = fuente(estilo, serif: serif)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = color
        return label
    }

    /// Contenido desplazable, centrado y de ancho limitado para iPhone e iPad.
    static func contenido(en controlador: UIViewController) -> UIStackView {
        controlador.view.backgroundColor = crema
        let scroll = UIScrollView()
        let stack = UIStackView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 24
        controlador.view.addSubview(scroll)
        scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: controlador.view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: controlador.view.safeAreaLayoutGuide.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: controlador.view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: controlador.view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -32),
            stack.centerXAnchor.constraint(equalTo: scroll.frameLayoutGuide.centerXAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: scroll.contentLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: scroll.contentLayoutGuide.trailingAnchor, constant: -24),
            stack.widthAnchor.constraint(lessThanOrEqualToConstant: 640)
        ])
        let ancho = stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -48)
        ancho.priority = .defaultHigh
        ancho.isActive = true
        return stack
    }

    static func mensajePendiente(en controlador: UIViewController, titulo: String,
                                  simbolo: String, mensaje: String) {
        controlador.title = titulo
        let stack = contenido(en: controlador)
        let icono = UIImageView(image: UIImage(systemName: simbolo))
        icono.tintColor = terracota
        icono.contentMode = .scaleAspectFit
        icono.heightAnchor.constraint(equalToConstant: 72).isActive = true
        icono.isAccessibilityElement = false
        stack.addArrangedSubview(icono)
        stack.addArrangedSubview(etiqueta(titulo, estilo: .largeTitle, serif: true))
        stack.addArrangedSubview(etiqueta("Próximamente", estilo: .headline, color: terracota))
        stack.addArrangedSubview(etiqueta(mensaje, estilo: .body, color: secundario))
    }
}
