import UIKit
import CoreData

// La estructura visual y las cuatro filas estáticas se editan en Main.storyboard.
final class CuentaViewController: UITableViewController {
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var usuarioLabel: UILabel!
    @IBOutlet weak var rolLabel: UILabel!

    var usuarioSesion: Usuario? {
        didSet { if isViewLoaded { actualizarDatos() } }
    }
    var alCerrarSesion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cuenta"
        actualizarDatos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizarDatos()
    }

    private func actualizarDatos() {
        guard let usuario = usuarioSesion, !usuario.isDeleted,
              usuario.managedObjectContext != nil else {
            nombreLabel.text = "Sin sesión"
            usuarioLabel.text = "—"
            rolLabel.text = "—"
            return
        }
        nombreLabel.text = usuario.nombre ?? "—"
        usuarioLabel.text = usuario.usuario ?? "—"
        rolLabel.text = usuario.rol ?? "—"
    }

    @IBAction func cerrarSesion(_ sender: UIButton) {
        alCerrarSesion?()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
