import UIKit

class FavoritasViewController: UIViewController {
    @IBOutlet weak var tablaFavoritas: UITableView!
    private let favoritos = FavoritosStore.compartido
    private var culturasFavoritas: [Cultura] = []
    private let estadoVacio = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mis favoritas"
        view.backgroundColor = EstiloUI.crema
        tablaFavoritas.backgroundColor = EstiloUI.crema
        tablaFavoritas.separatorStyle = .none
        tablaFavoritas.rowHeight = UITableView.automaticDimension
        tablaFavoritas.estimatedRowHeight = 116
        tablaFavoritas.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
        tablaFavoritas.register(CulturaTableViewCell.self, forCellReuseIdentifier: "celdaCultura")
        tablaFavoritas.dataSource = self
        tablaFavoritas.delegate = self
        configurarEstadoVacio()
        actualizarListado()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizarListado()
    }

    private func actualizarListado() {
        culturasFavoritas = CatalogoCulturas.todas.filter { favoritos.contiene($0.id) }
        tablaFavoritas.reloadData()
        tablaFavoritas.isHidden = culturasFavoritas.isEmpty
        estadoVacio.isHidden = !culturasFavoritas.isEmpty
    }

    private func configurarEstadoVacio() {
        estadoVacio.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(estadoVacio)
        let icono = UIImageView(image: UIImage(systemName: "heart"))
        icono.tintColor = EstiloUI.terracota
        icono.contentMode = .scaleAspectFit
        icono.heightAnchor.constraint(equalToConstant: 64).isActive = true
        let titulo = EstiloUI.etiqueta("Tu historia favorita empieza aquí", estilo: .title1, serif: true)
        titulo.accessibilityTraits.insert(.header)
        let mensaje = EstiloUI.etiqueta(
            "Aún no tienes culturas favoritas. Explora las culturas y toca el corazón en sus detalles para guardarlas aquí.",
            estilo: .body, color: EstiloUI.secundario)
        var configuracion = UIButton.Configuration.filled()
        configuracion.title = "Explorar culturas"
        configuracion.baseBackgroundColor = EstiloUI.terracota
        configuracion.baseForegroundColor = EstiloUI.marfil
        configuracion.background.cornerRadius = 18
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        let boton = UIButton(configuration: configuracion, primaryAction: UIAction { [weak self] _ in
            self?.tabBarController?.selectedIndex = SeccionPrincipal.explorar.rawValue
        })
        boton.titleLabel?.numberOfLines = 0
        boton.titleLabel?.adjustsFontForContentSizeCategory = true
        let contenido = UIStackView(arrangedSubviews: [icono, titulo, mensaje, boton])
        contenido.axis = .vertical
        contenido.spacing = 24
        contenido.translatesAutoresizingMaskIntoConstraints = false
        estadoVacio.addSubview(contenido)
        NSLayoutConstraint.activate([
            estadoVacio.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            estadoVacio.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            estadoVacio.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            estadoVacio.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contenido.topAnchor.constraint(equalTo: estadoVacio.contentLayoutGuide.topAnchor, constant: 32),
            contenido.bottomAnchor.constraint(equalTo: estadoVacio.contentLayoutGuide.bottomAnchor, constant: -32),
            contenido.centerXAnchor.constraint(equalTo: estadoVacio.frameLayoutGuide.centerXAnchor),
            contenido.leadingAnchor.constraint(greaterThanOrEqualTo: estadoVacio.contentLayoutGuide.leadingAnchor, constant: 24),
            contenido.trailingAnchor.constraint(lessThanOrEqualTo: estadoVacio.contentLayoutGuide.trailingAnchor, constant: -24),
            contenido.widthAnchor.constraint(lessThanOrEqualToConstant: 640)
        ])
        let ancho = contenido.widthAnchor.constraint(equalTo: estadoVacio.frameLayoutGuide.widthAnchor, constant: -48)
        ancho.priority = .defaultHigh
        ancho.isActive = true
    }
}

extension FavoritasViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        culturasFavoritas.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaCultura", for: indexPath)
        (celda as? CulturaTableViewCell)?.configurar(con: culturasFavoritas[indexPath.row])
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard culturasFavoritas.indices.contains(indexPath.row),
              let detalle = storyboard?.instantiateViewController(withIdentifier: "DetalleViewController")
                as? DetalleViewController else { return }
        detalle.culturaSeleccionada = culturasFavoritas[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(detalle, animated: true)
    }
}
