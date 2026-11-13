import UIKit
import CoreData

// Cuenta mínima: datos de sesión y cierre, sin implementar funciones completas de A9.
final class CuentaViewController: UITableViewController {
    var usuarioSesion: Usuario?
    var alCerrarSesion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cuenta"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 4 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let usuario = usuarioSesion
        let valido = usuario != nil && usuario?.isDeleted == false && usuario?.managedObjectContext != nil
        switch indexPath.row {
        case 0: celda.textLabel?.text = "Nombre"; celda.detailTextLabel?.text = valido ? usuario?.nombre : "Sin sesión"
        case 1: celda.textLabel?.text = "Usuario"; celda.detailTextLabel?.text = valido ? usuario?.usuario : "—"
        case 2: celda.textLabel?.text = "Rol"; celda.detailTextLabel?.text = valido ? usuario?.rol : "—"
        default: celda.textLabel?.text = "Cerrar sesión"; celda.textLabel?.textColor = .systemRed
        }
        celda.selectionStyle = indexPath.row == 3 ? .default : .none
        return celda
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3 { alCerrarSesion?() }
    }
}
