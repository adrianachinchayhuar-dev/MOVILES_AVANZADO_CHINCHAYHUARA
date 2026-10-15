//
//  ViewController.swift
//  CulturasPeruanas
//
//  Created by Adriana Chinchayhuara on 15/10/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tablaCulturas: UITableView!
    
    let culturas: [Cultura] = [
        Cultura(
            nombre: "Caral",
            region: "Lima",
            descripcion: "Una de las civilizaciones más antiguas de América, reconocida por sus construcciones monumentales.",
            imagen: "caral"
        ),
        Cultura(
            nombre: "Chavín",
            region: "Áncash",
            descripcion: "Cultura destacada por su arquitectura religiosa y esculturas como el Lanzón Monolítico.",
            imagen: "chavin"
        ),
        Cultura(
            nombre: "Paracas",
            region: "Ica",
            descripcion: "Cultura reconocida por sus textiles, mantos funerarios y conocimientos médicos.",
            imagen: "paracas"
        ),
        Cultura(
            nombre: "Nazca",
            region: "Ica",
            descripcion: "Cultura conocida por las Líneas de Nazca, su cerámica y sus sistemas hidráulicos.",
            imagen: "nazca"
        ),
        Cultura(
            nombre: "Moche",
            region: "La Libertad",
            descripcion: "Cultura de la costa norte del Perú, destacada por su cerámica y sus construcciones ceremoniales.",
            imagen: "moche"
        ),
        Cultura(
            nombre: "Inca",
            region: "Cusco",
            descripcion: "Civilización andina que desarrolló el Tahuantinsuyo, con grandes avances en arquitectura e ingeniería.",
            imagen: "inca"
        )
    ]

    private let buscador = UISearchController(searchResultsController: nil)
    private var culturasVisibles: [Cultura] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = EstiloUI.crema
        navigationItem.title = "Culturas Peruanas"
        culturasVisibles = culturas
        tablaCulturas.dataSource = self
        tablaCulturas.delegate = self
        tablaCulturas.backgroundColor = EstiloUI.crema
        tablaCulturas.separatorStyle = .none
        tablaCulturas.rowHeight = UITableView.automaticDimension
        tablaCulturas.estimatedRowHeight = 116
        tablaCulturas.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
        tablaCulturas.keyboardDismissMode = .onDrag

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar cultura…"
        buscador.searchBar.tintColor = EstiloUI.terracota
        buscador.searchBar.searchTextField.backgroundColor = EstiloUI.beige
        buscador.searchBar.searchTextField.textColor = EstiloUI.marron
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let seleccion = tablaCulturas.indexPathForSelectedRow {
            tablaCulturas.deselectRow(at: seleccion, animated: animated)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "mostrarDetalle",
              let destino = segue.destination as? DetalleViewController,
              let indexPath = tablaCulturas.indexPathForSelectedRow,
              culturasVisibles.indices.contains(indexPath.row) else { return }
        // La selección debe consultar la misma colección que dibuja la tabla.
        destino.culturaSeleccionada = culturasVisibles[indexPath.row]
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        culturasVisibles.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaCultura", for: indexPath)
        if let tarjeta = celda as? CulturaTableViewCell {
            tarjeta.configurar(con: culturasVisibles[indexPath.row])
        }
        return celda
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let consulta = (searchController.searchBar.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        culturasVisibles = consulta.isEmpty ? culturas : culturas.filter {
            $0.nombre.range(of: consulta, options: [.caseInsensitive, .diacriticInsensitive],
                            locale: Locale(identifier: "es_PE")) != nil
        }
        if culturasVisibles.isEmpty {
            let mensaje = EstiloUI.etiqueta("No se encontraron culturas.\nPrueba con otro nombre.",
                                            estilo: .body, color: EstiloUI.secundario)
            mensaje.textAlignment = .center
            let fondo = UIView()
            mensaje.translatesAutoresizingMaskIntoConstraints = false
            fondo.addSubview(mensaje)
            NSLayoutConstraint.activate([
                mensaje.centerYAnchor.constraint(equalTo: fondo.centerYAnchor),
                mensaje.leadingAnchor.constraint(equalTo: fondo.leadingAnchor, constant: 24),
                mensaje.trailingAnchor.constraint(equalTo: fondo.trailingAnchor, constant: -24)
            ])
            tablaCulturas.backgroundView = fondo
        } else {
            tablaCulturas.backgroundView = nil
        }
        tablaCulturas.reloadData()
    }
}
