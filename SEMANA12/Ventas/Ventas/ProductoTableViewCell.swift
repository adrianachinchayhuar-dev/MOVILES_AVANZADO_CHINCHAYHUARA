import UIKit

// La distribución y los estilos se editan en la celda prototipo de Main.storyboard.
final class ProductoTableViewCell: UITableViewCell {
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
}
