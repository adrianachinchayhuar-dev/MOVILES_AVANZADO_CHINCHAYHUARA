import UIKit

class LineaTiempoViewController: UIViewController {
    @IBOutlet weak var tablaLineaTiempo: UITableView!
    // El índice original resuelve empates sin alterar el orden del catálogo compartido.
    private let culturasCronologicas = CatalogoCulturas.todas.enumerated().sorted {
        if $0.element.periodoHistorico.inicio == $1.element.periodoHistorico.inicio {
            return $0.offset < $1.offset
        }
        return $0.element.periodoHistorico.inicio < $1.element.periodoHistorico.inicio
    }.map(\.element)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Línea de tiempo"
        view.backgroundColor = EstiloUI.crema
        tablaLineaTiempo.backgroundColor = EstiloUI.crema
        tablaLineaTiempo.separatorStyle = .none
        tablaLineaTiempo.rowHeight = UITableView.automaticDimension
        tablaLineaTiempo.estimatedRowHeight = 480
        tablaLineaTiempo.contentInset.bottom = 24
        tablaLineaTiempo.register(LineaTiempoTableViewCell.self, forCellReuseIdentifier: "celdaLineaTiempo")
        tablaLineaTiempo.dataSource = self
        tablaLineaTiempo.delegate = self
        configurarCabecera()
    }

    private func configurarCabecera() {
        let titulo = EstiloUI.etiqueta("Un recorrido por nuestra historia", estilo: .title1, serif: true)
        titulo.accessibilityTraits.insert(.header)
        let aviso = EstiloUI.etiqueta(
            "Períodos aproximados. Algunas culturas coexistieron. El orden sigue su inicio; la distancia entre tarjetas no representa años.",
            estilo: .subheadline, color: EstiloUI.secundario)
        let textos = UIStackView(arrangedSubviews: [titulo, aviso])
        textos.axis = .vertical
        textos.spacing = 12
        textos.translatesAutoresizingMaskIntoConstraints = false
        let cabecera = UIView()
        cabecera.addSubview(textos)
        NSLayoutConstraint.activate([
            textos.topAnchor.constraint(equalTo: cabecera.topAnchor, constant: 24),
            textos.bottomAnchor.constraint(equalTo: cabecera.bottomAnchor, constant: -16),
            textos.leadingAnchor.constraint(equalTo: cabecera.leadingAnchor, constant: 24),
            textos.trailingAnchor.constraint(equalTo: cabecera.trailingAnchor, constant: -24)
        ])
        tablaLineaTiempo.tableHeaderView = cabecera
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let cabecera = tablaLineaTiempo.tableHeaderView else { return }
        let ancho = tablaLineaTiempo.bounds.width
        guard ancho > 0 else { return }
        let altura = cabecera.systemLayoutSizeFitting(CGSize(width: ancho, height: 0),
            withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        if cabecera.frame.width != ancho || abs(cabecera.frame.height - altura) > 0.5 {
            cabecera.frame = CGRect(x: 0, y: 0, width: ancho, height: altura)
            tablaLineaTiempo.tableHeaderView = cabecera
        }
    }
}

extension LineaTiempoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        culturasCronologicas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLineaTiempo", for: indexPath)
        let cultura = culturasCronologicas[indexPath.row]
        let contemporaneas = culturasCronologicas.filter {
            $0.id != cultura.id && cultura.periodoHistorico.seSuperpone(con: $0.periodoHistorico)
        }.map(\.nombre)
        (celda as? LineaTiempoTableViewCell)?.configurar(con: cultura, contemporaneas: contemporaneas,
            primera: indexPath.row == 0, ultima: indexPath.row == culturasCronologicas.count - 1)
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard culturasCronologicas.indices.contains(indexPath.row),
              let detalle = storyboard?.instantiateViewController(withIdentifier: "DetalleViewController")
                as? DetalleViewController else { return }
        detalle.culturaSeleccionada = culturasCronologicas[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(detalle, animated: true)
    }
}
