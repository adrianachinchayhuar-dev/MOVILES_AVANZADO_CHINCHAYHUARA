import UIKit

// Distribución y estilos editables en el prototipo VentaCell de Main.storyboard.
final class MisVentaTableViewCell: UITableViewCell {
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    @IBOutlet weak var clienteLabel: UILabel!
    @IBOutlet weak var productoLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
}
