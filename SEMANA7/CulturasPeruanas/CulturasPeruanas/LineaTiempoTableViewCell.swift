import UIKit

class LineaTiempoTableViewCell: UITableViewCell {
    private let tarjeta = UIView()
    private let foto = UIImageView()
    private let nombre = EstiloUI.etiqueta("", estilo: .title2, serif: true)
    private let periodo = EstiloUI.etiqueta("", estilo: .headline, color: EstiloUI.terracota)
    private let descripcion = EstiloUI.etiqueta("", estilo: .body, color: EstiloUI.secundario)
    private let coincidencias = EstiloUI.etiqueta("", estilo: .footnote, color: EstiloUI.terracota)
    private let nota = EstiloUI.etiqueta("", estilo: .footnote, color: EstiloUI.secundario)
    private let fuente = EstiloUI.etiqueta("", estilo: .caption2, color: EstiloUI.secundario)
    private let lineaSuperior = UIView()
    private let lineaInferior = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurarInterfaz()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurarInterfaz()
    }

    private func configurarInterfaz() {
        selectionStyle = .none
        backgroundColor = .clear
        tarjeta.backgroundColor = EstiloUI.marfil
        tarjeta.layer.cornerRadius = 22
        // Todo el contenido decorativo deja pasar los toques a la celda.
        tarjeta.isUserInteractionEnabled = false
        tarjeta.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tarjeta)
        let marcador = UIView()
        marcador.backgroundColor = EstiloUI.terracota
        marcador.layer.cornerRadius = 7
        for vista in [lineaSuperior, lineaInferior, marcador] {
            vista.translatesAutoresizingMaskIntoConstraints = false
            vista.isUserInteractionEnabled = false
            contentView.addSubview(vista)
        }
        lineaSuperior.backgroundColor = EstiloUI.beige
        lineaInferior.backgroundColor = EstiloUI.beige
        foto.contentMode = .scaleAspectFill
        foto.clipsToBounds = true
        foto.layer.cornerRadius = 14
        foto.backgroundColor = EstiloUI.beige
        foto.heightAnchor.constraint(equalToConstant: 140).isActive = true
        let contenido = UIStackView(arrangedSubviews: [foto, nombre, periodo, descripcion, coincidencias, nota, fuente])
        contenido.axis = .vertical
        contenido.spacing = 12
        contenido.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.addSubview(contenido)
        NSLayoutConstraint.activate([
            tarjeta.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            tarjeta.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            tarjeta.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            tarjeta.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contenido.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 16),
            contenido.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -16),
            contenido.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 16),
            contenido.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -16),
            marcador.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            marcador.centerYAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 32),
            marcador.widthAnchor.constraint(equalToConstant: 14),
            marcador.heightAnchor.constraint(equalToConstant: 14),
            lineaSuperior.centerXAnchor.constraint(equalTo: marcador.centerXAnchor),
            lineaSuperior.widthAnchor.constraint(equalToConstant: 2),
            lineaSuperior.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineaSuperior.bottomAnchor.constraint(equalTo: marcador.topAnchor),
            lineaInferior.centerXAnchor.constraint(equalTo: marcador.centerXAnchor),
            lineaInferior.widthAnchor.constraint(equalToConstant: 2),
            lineaInferior.topAnchor.constraint(equalTo: marcador.bottomAnchor),
            lineaInferior.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityHint = "Abre el detalle de esta cultura"
    }

    func configurar(con cultura: Cultura, contemporaneas: [String], primera: Bool, ultima: Bool) {
        foto.image = UIImage(named: cultura.imagen)
        nombre.text = cultura.nombre
        periodo.text = cultura.periodoHistorico.texto
        descripcion.text = cultura.descripcion
        coincidencias.isHidden = contemporaneas.isEmpty
        coincidencias.text = "Coincide parcialmente con: " + contemporaneas.joined(separator: ", ")
        nota.text = cultura.periodoHistorico.nota
        fuente.text = "Fuente: " + cultura.periodoHistorico.fuente
        lineaSuperior.isHidden = primera
        lineaInferior.isHidden = ultima
        accessibilityLabel = [nombre.text, periodo.text, descripcion.text,
                              contemporaneas.isEmpty ? nil : coincidencias.text,
                              nota.text, fuente.text].compactMap { $0 }.joined(separator: ". ")
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
