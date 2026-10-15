import UIKit

/// Contenido adaptable: ninguna tarjeta impone una altura fija a sus textos.
final class TarjetaInformativaView: UIView {
    init(titulo: String, descripcion: String, referencias: String) {
        super.init(frame: .zero)
        backgroundColor = EstiloUI.marfil
        layer.cornerRadius = 22
        let destacado = EstiloUI.etiqueta(titulo, estilo: .title2, serif: true, color: EstiloUI.terracota)
        let texto = EstiloUI.etiqueta(descripcion, estilo: .body, color: EstiloUI.secundario)
        let fuente = EstiloUI.etiqueta(referencias, estilo: .caption1, color: EstiloUI.secundario)
        let contenido = UIStackView(arrangedSubviews: [destacado, texto, fuente])
        contenido.axis = .vertical
        contenido.spacing = 10
        contenido.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contenido)
        NSLayoutConstraint.activate([
            contenido.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            contenido.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            contenido.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contenido.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        isAccessibilityElement = true
        accessibilityLabel = [titulo, descripcion, referencias].joined(separator: ". ")
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }
}
