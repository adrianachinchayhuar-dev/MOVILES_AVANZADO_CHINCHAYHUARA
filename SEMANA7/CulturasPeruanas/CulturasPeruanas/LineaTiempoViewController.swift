import UIKit

class LineaTiempoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        EstiloUI.mensajePendiente(en: self, titulo: "Línea de tiempo", simbolo: "clock",
            mensaje: "Próximamente podrás recorrer los períodos históricos de las seis culturas. Esta sección está en preparación; mientras tanto, descubre sus descripciones en Explorar.")
    }
}
