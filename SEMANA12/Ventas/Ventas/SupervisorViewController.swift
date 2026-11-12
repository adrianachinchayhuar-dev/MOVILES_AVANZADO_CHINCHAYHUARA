import UIKit
import CoreData

// Estructura mínima de Resumen/Ventas: solo lectura de datos reales, sin A7/A8 completas.
final class SupervisorViewController: UITableViewController {
    var usuarioSesion: Usuario? {
        didSet { if isViewLoaded { cargar() } }
    }
    var mostrarResumen = false
    private var contexto: NSManagedObjectContext!
    private var ventas: [Venta] = []
    private var resumen: [(String, Int)] = []
    private let fecha: DateFormatter = {
        let formato = DateFormatter()
        formato.dateStyle = .short
        formato.timeStyle = .short
        return formato
    }()
    private var autorizado: Bool {
        guard let usuario = usuarioSesion, !usuario.isDeleted,
              usuario.managedObjectContext != nil else { return false }
        return usuario.rol == "Supervisor"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = mostrarResumen ? "Resumen" : "Ventas"
        let app = UIApplication.shared.delegate as! AppDelegate
        contexto = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contexto.persistentStoreCoordinator = app.persistentContainer.persistentStoreCoordinator
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contexto.refreshAllObjects()
        cargar()
    }
    private func cargar() {
        guard contexto != nil else { return }
        ventas = []; resumen = []
        guard autorizado else { mostrarEstado("Se requiere una sesión Supervisor."); return }
        do {
            if mostrarResumen {
                for entidad in ["Producto", "Cliente", "Venta"] {
                    let solicitud = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
                    resumen.append((entidad == "Producto" ? "Productos" : (entidad == "Cliente" ? "Clientes" : "Ventas registradas"), try contexto.count(for: solicitud)))
                }
            } else {
                let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
                solicitud.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
                ventas = try contexto.fetch(solicitud)
            }
            mostrarEstado(!mostrarResumen && ventas.isEmpty ? "No hay ventas registradas." : nil)
        } catch {
            ventas = []; resumen = []
            mostrarEstado("No se pudieron consultar los datos. Vuelve a abrir la pestaña.")
        }
    }
    private func mostrarEstado(_ texto: String?) {
        let etiqueta = UILabel()
        etiqueta.text = texto
        etiqueta.textAlignment = .center
        etiqueta.numberOfLines = 0
        tableView.backgroundView = texto == nil ? nil : etiqueta
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mostrarResumen ? resumen.count : ventas.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        celda.selectionStyle = .none
        if mostrarResumen {
            celda.textLabel?.text = "\(resumen[indexPath.row].0): \(resumen[indexPath.row].1)"
        } else {
            let venta = ventas[indexPath.row]
            celda.textLabel?.numberOfLines = 0
            celda.detailTextLabel?.numberOfLines = 0
            celda.textLabel?.text = "\(venta.fecha.map { fecha.string(from: $0) } ?? "Sin fecha") · \(venta.anulada ? "Anulada" : "Activa")"
            celda.detailTextLabel?.text = "Cliente: \(venta.cliente?.nombre ?? "—")\nProducto: \(venta.producto?.nombre ?? "—") · Cantidad: \(venta.cantidad)\nVendedor: \(venta.vendedor?.usuario ?? "—") · Total: S/ \(String(format: "%.2f", venta.total))"
        }
        return celda
    }
}
