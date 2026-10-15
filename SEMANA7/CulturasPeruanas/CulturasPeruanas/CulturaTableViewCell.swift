import UIKit

/// Celda del Storyboard: sus vistas decorativas no interceptan la selección de la fila.
class CulturaTableViewCell: UITableViewCell {
    private let tarjeta = UIView()
    private let foto = UIImageView()
    private let nombre = EstiloUI.etiqueta("", estilo: .title2, serif: true)
    private let region = EstiloUI.etiqueta("", estilo: .subheadline, color: EstiloUI.secundario)

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        tarjeta.backgroundColor = EstiloUI.marfil
        tarjeta.layer.cornerRadius = 22
        tarjeta.isUserInteractionEnabled = false
        tarjeta.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tarjeta)

        foto.contentMode = .scaleAspectFill
        foto.clipsToBounds = true
        foto.layer.cornerRadius = 14
        foto.backgroundColor = EstiloUI.beige
        foto.translatesAutoresizingMaskIntoConstraints = false
        let textos = UIStackView(arrangedSubviews: [nombre, region])
        textos.axis = .vertical
        textos.spacing = 6
        let flecha = UIImageView(image: UIImage(systemName: "chevron.right"))
        flecha.tintColor = EstiloUI.terracota
        flecha.contentMode = .scaleAspectFit
        flecha.setContentHuggingPriority(.required, for: .horizontal)
        flecha.setContentCompressionResistancePriority(.required, for: .horizontal)
        let fila = UIStackView(arrangedSubviews: [foto, textos, flecha])
        fila.spacing = 14
        fila.alignment = .center
        fila.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.addSubview(fila)
        NSLayoutConstraint.activate([
            tarjeta.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            tarjeta.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            tarjeta.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tarjeta.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            fila.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 12),
            fila.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -12),
            fila.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 12),
            fila.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -16),
            foto.widthAnchor.constraint(equalToConstant: 80),
            foto.heightAnchor.constraint(equalToConstant: 80)
        ])
        isAccessibilityElement = true
        accessibilityTraits = .button
    }

    func configurar(con cultura: Cultura) {
        nombre.text = cultura.nombre
        region.text = cultura.region
        foto.image = UIImage(named: cultura.imagen)
        accessibilityLabel = "\(cultura.nombre), región \(cultura.region)"
        accessibilityHint = "Muestra información de esta cultura"
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        tarjeta.backgroundColor = highlighted ? EstiloUI.beige : EstiloUI.marfil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tarjeta.backgroundColor = selected ? EstiloUI.beige : EstiloUI.marfil
    }
}
