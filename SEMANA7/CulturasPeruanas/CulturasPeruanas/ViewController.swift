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

    override func viewDidLoad() {
        super.viewDidLoad()

        tablaCulturas.dataSource = self
        tablaCulturas.delegate = self
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        print("SEGUE EJECUTADO: \(segue.identifier ?? "sin identificador")")

        guard segue.identifier == "mostrarDetalle" else {
            print("ERROR: IDENTIFICADOR INCORRECTO")
            return
        }

        guard let destino = segue.destination as? DetalleViewController else {
            print("ERROR: DESTINO INCORRECTO")
            return
        }

        guard let indexPath = tablaCulturas.indexPathForSelectedRow else {
            print("ERROR: NO HAY FILA SELECCIONADA")
            return
        }

        destino.culturaSeleccionada = culturas[indexPath.row]

        print("ENVIANDO CULTURA: \(culturas[indexPath.row].nombre)")
    }


    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let celda = tableView.dequeueReusableCell(
            withIdentifier: "celdaCultura",
            for: indexPath
        )

        let cultura = culturas[indexPath.row]

        var contenido = celda.defaultContentConfiguration()
        contenido.text = cultura.nombre
        contenido.image = UIImage(named: cultura.imagen)
        contenido.imageProperties.maximumSize = CGSize(
            width: 50,
            height: 50
        )

        celda.contentConfiguration = contenido

        return celda
    }
}


