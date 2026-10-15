import UIKit

class FavoritasViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        EstiloUI.mensajePendiente(en: self, titulo: "Mis favoritas", simbolo: "heart",
            mensaje: "Aquí podrás consultar tus culturas favoritas cuando se habilite esta función. Por ahora, puedes conocer las seis culturas en la pestaña Explorar.")
    }
}
