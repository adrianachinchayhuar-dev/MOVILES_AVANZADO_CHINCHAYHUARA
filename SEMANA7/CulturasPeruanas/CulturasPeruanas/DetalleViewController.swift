//
//  DetalleViewController.swift
//  CulturasPeruanas
//
//  Created by Adriana Chinchayhuara on 15/10/26.
//


import UIKit

class DetalleViewController: UIViewController {

    var culturaSeleccionada: Cultura?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        print("ENTRÓ A DETALLE VIEW CONTROLLER")

        if let cultura = culturaSeleccionada {
            print("CULTURA RECIBIDA: \(cultura.nombre)")
        } else {
            print("ERROR: NO SE RECIBIÓ NINGUNA CULTURA")
        }

        title = culturaSeleccionada?.nombre

        configurarInterfaz()
    }


    func configurarInterfaz() {
        guard let cultura = culturaSeleccionada else { return }

        let imagen = UIImageView()
        imagen.image = UIImage(named: cultura.imagen)
        imagen.contentMode = .scaleAspectFit
        imagen.translatesAutoresizingMaskIntoConstraints = false

        let nombre = UILabel()
        nombre.text = cultura.nombre
        nombre.font = .boldSystemFont(ofSize: 26)
        nombre.textAlignment = .center

        let region = UILabel()
        region.text = "Región: \(cultura.region)"
        region.font = .systemFont(ofSize: 18)
        region.textAlignment = .center

        let descripcion = UILabel()
        descripcion.text = cultura.descripcion
        descripcion.font = .systemFont(ofSize: 16)
        descripcion.numberOfLines = 0
        descripcion.textAlignment = .center

        let contenido = UIStackView(arrangedSubviews: [
            imagen, nombre, region, descripcion
        ])

        contenido.axis = .vertical
        contenido.spacing = 20
        contenido.alignment = .fill
        contenido.translatesAutoresizingMaskIntoConstraints = false

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(contenido)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contenido.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            contenido.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            contenido.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            contenido.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            contenido.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40),

            imagen.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
}

