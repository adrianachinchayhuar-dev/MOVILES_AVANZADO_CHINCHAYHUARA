import UIKit

class DetalleViewController: UIViewController {
    var culturaSeleccionada: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = culturaSeleccionada?.nombre
        configurarInterfaz()
    }

    func configurarInterfaz() {
        let contenido = EstiloUI.contenido(en: self)
        guard let cultura = culturaSeleccionada else {
            contenido.addArrangedSubview(EstiloUI.etiqueta(
                "No se pudo cargar la cultura seleccionada.", estilo: .body))
            return
        }
        let imagen = UIImageView(image: UIImage(named: cultura.imagen))
        imagen.contentMode = .scaleAspectFit
        imagen.backgroundColor = EstiloUI.beige
        imagen.layer.cornerRadius = 24
        imagen.clipsToBounds = true
        imagen.heightAnchor.constraint(equalToConstant: 220).isActive = true
        imagen.isAccessibilityElement = true
        imagen.accessibilityLabel = "Imagen de la cultura \(cultura.nombre)"
        contenido.addArrangedSubview(imagen)
        contenido.addArrangedSubview(EstiloUI.etiqueta(
            "CULTURAS DEL PERÚ", estilo: .caption1, color: EstiloUI.terracota))
        let nombre = EstiloUI.etiqueta(cultura.nombre, estilo: .largeTitle, serif: true)
        nombre.accessibilityTraits.insert(.header)
        contenido.addArrangedSubview(nombre)
        contenido.addArrangedSubview(EstiloUI.etiqueta(
            "Región: \(cultura.region)", estilo: .headline, color: EstiloUI.secundario))
        contenido.addArrangedSubview(EstiloUI.etiqueta(cultura.descripcion, estilo: .body))
    }
}
