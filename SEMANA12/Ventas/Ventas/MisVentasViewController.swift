import UIKit
import CoreData

final class MisVentasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var buscarSearchBar: UISearchBar!
    @IBOutlet weak var estadoSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ventasTableView: UITableView!
    @IBOutlet weak var estadoVacioLabel: UILabel!
    @IBOutlet private weak var ventasHeaderStack: UIStackView!
    @IBOutlet private weak var ventasBottomConstraint: NSLayoutConstraint!

    var usuarioSesion: Usuario? {
        didSet { if isViewLoaded { cargarVentas() } }
    }
    private var contexto: NSManagedObjectContext!
    private var ventas: [Venta] = []
    private let formatoFecha: DateFormatter = {
        let formato = DateFormatter()
        formato.dateStyle = .short
        formato.timeStyle = .short
        return formato
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate
        contexto = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contexto.persistentStoreCoordinator = app.persistentContainer.persistentStoreCoordinator
        ventasTableView.dataSource = self
        ventasTableView.delegate = self
        ventasTableView.rowHeight = UITableView.automaticDimension
        ventasTableView.estimatedRowHeight = 160
        ventasTableView.keyboardDismissMode = .onDrag
        ventasBottomConstraint.isActive = false
        ventasTableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        buscarSearchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contexto.refreshAllObjects()
        cargarVentas()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let cabecera = ventasTableView.tableHeaderView else { return }
        let ancho = ventasTableView.bounds.width
        let ajuste = ventasHeaderStack.systemLayoutSizeFitting(
            CGSize(width: max(0, ancho - 40), height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        let alto = ceil(ajuste.height + 24)
        if cabecera.frame.width != ancho || abs(cabecera.frame.height - alto) > 0.5 {
            cabecera.frame.size = CGSize(width: ancho, height: alto)
            ventasTableView.tableHeaderView = cabecera
        }
    }

    @IBAction func filtrarEstado(_ sender: UISegmentedControl) { cargarVentas() }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { cargarVentas() }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }

    private func cargarVentas() {
        guard contexto != nil else { return }
        // Ajusta la cabecera al mostrar u ocultar el mensaje vacío, sin repetir consultas.
        view.setNeedsLayout()
        // Sin usuario persistido no se hace ninguna consulta de ventas.
        guard let usuario = usuarioSesion, usuario.rol == "Vendedor", !usuario.isDeleted,
              usuario.managedObjectContext != nil, !usuario.objectID.isTemporaryID else {
            ventas = []
            estadoVacioLabel.text = "Inicia sesión para consultar tus ventas."
            estadoVacioLabel.isHidden = false
            ventasTableView.reloadData()
            return
        }
        let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
        var filtros = [NSPredicate(format: "vendedor == %@", usuario.objectID)]
        let texto = (buscarSearchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !texto.isEmpty {
            filtros.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@ OR producto.nombre CONTAINS[cd] %@", texto, texto))
        }
        if estadoSegmentedControl.selectedSegmentIndex == 1 {
            filtros.append(NSPredicate(format: "anulada == NO"))
        } else if estadoSegmentedControl.selectedSegmentIndex == 2 {
            filtros.append(NSPredicate(format: "anulada == YES"))
        }
        solicitud.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
        solicitud.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        do {
            ventas = try contexto.fetch(solicitud)
            estadoVacioLabel.text = "No hay ventas para esta búsqueda y estado."
            estadoVacioLabel.isHidden = !ventas.isEmpty
            ventasTableView.reloadData()
        } catch {
            // No se conservan filas de una sesión anterior si falla la consulta.
            ventas = []
            estadoVacioLabel.text = "No se pudieron consultar tus ventas. Vuelve a abrir la pantalla."
            estadoVacioLabel.isHidden = false
            ventasTableView.reloadData()
        }
    }

    private func fecha(_ venta: Venta) -> String {
        venta.fecha.map { formatoFecha.string(from: $0) } ?? "Sin fecha"
    }
    private func importe(_ valor: Double) -> String { String(format: "%.2f", valor) }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { ventas.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "VentaCell", for: indexPath) as! MisVentaTableViewCell
        let venta = ventas[indexPath.row]
        celda.fechaLabel.text = fecha(venta)
        celda.estadoLabel.text = venta.anulada ? "Anulada" : "Activa"
        celda.clienteLabel.text = "Cliente: \(venta.cliente?.nombre ?? "Sin cliente")"
        celda.productoLabel.text = "Producto: \(venta.producto?.nombre ?? "Sin producto")"
        celda.cantidadLabel.text = "Cantidad: \(venta.cantidad)"
        celda.totalLabel.text = "Total: S/ \(importe(venta.total))"
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let venta = ventas[indexPath.row]
        // Comprueba la sesión también al mostrar el detalle.
        guard let usuario = usuarioSesion, usuario.rol == "Vendedor", !usuario.isDeleted,
              venta.vendedor?.objectID == usuario.objectID else {
            cargarVentas()
            return
        }
        let mensaje = """
        Fecha: \(fecha(venta))
        Cliente: \(venta.cliente?.nombre ?? "Sin cliente")
        Documento: \(venta.cliente?.documento ?? "—")
        Producto: \(venta.producto?.nombre ?? "Sin producto")
        Cantidad: \(venta.cantidad)
        Precio unitario: \(importe(venta.precioUnitario))
        Descuento: \(importe(venta.descuento))
        IGV: \(importe(venta.igv))
        Total: \(importe(venta.total))
        Estado: \(venta.anulada ? "Anulada" : "Activa")
        """ + (venta.anulada ? "\nMotivo: \(venta.motivoAnulacion ?? "Sin motivo")" : "")
        let detalle = UIAlertController(title: "Detalle de venta", message: mensaje, preferredStyle: .alert)
        detalle.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(detalle, animated: true)
    }
}
