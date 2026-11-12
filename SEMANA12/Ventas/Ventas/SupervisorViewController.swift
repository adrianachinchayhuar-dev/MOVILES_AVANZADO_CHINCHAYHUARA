import UIKit
import CoreData

// Resumen conserva su implementación mínima. Ventas del equipo es solo consulta (A7).
final class SupervisorViewController: UITableViewController, UISearchBarDelegate {
    var usuarioSesion: Usuario? {
        didSet {
            guard isViewLoaded else { return }
            if oldValue?.objectID != usuarioSesion?.objectID {
                vendedorID = nil
                buscarSearchBar.text = ""
                estadoSegmented.selectedSegmentIndex = 0
            }
            cargar()
        }
    }
    var mostrarResumen = false
    private var contexto: NSManagedObjectContext!
    private var ventas: [Venta] = []
    private var resumen: [(String, Int)] = []
    private var vendedorID: NSManagedObjectID?
    private let buscarSearchBar = UISearchBar()
    private let estadoSegmented = UISegmentedControl(items: ["Todas", "Activas", "Anuladas"])
    private let vendedorButton = UIButton(type: .system)
    private var filtrosStack: UIStackView?
    private let fecha: DateFormatter = {
        let formato = DateFormatter()
        formato.dateStyle = .short
        formato.timeStyle = .short
        return formato
    }()
    private var autorizado: Bool {
        guard let usuario = usuarioSesion, !usuario.isDeleted,
              usuario.managedObjectContext != nil, !usuario.objectID.isTemporaryID else { return false }
        return usuario.rol == "Supervisor"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = mostrarResumen ? "Resumen" : "Ventas"
        let app = UIApplication.shared.delegate as! AppDelegate
        contexto = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contexto.persistentStoreCoordinator = app.persistentContainer.persistentStoreCoordinator
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 125
        tableView.keyboardDismissMode = .onDrag
        if !mostrarResumen { configurarFiltros() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contexto.refreshAllObjects()
        cargar()
    }

    private func configurarFiltros() {
        buscarSearchBar.placeholder = "Cliente, producto o vendedor"
        buscarSearchBar.delegate = self
        estadoSegmented.selectedSegmentIndex = 0
        estadoSegmented.addTarget(self, action: #selector(cambiarEstado), for: .valueChanged)
        vendedorButton.setTitle("Vendedor: Todos", for: .normal)
        vendedorButton.showsMenuAsPrimaryAction = true
        vendedorButton.titleLabel?.numberOfLines = 0
        let stack = UIStackView(arrangedSubviews: [buscarSearchBar, estadoSegmented, vendedorButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        let cabecera = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 160))
        cabecera.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: cabecera.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: cabecera.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cabecera.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: cabecera.bottomAnchor, constant: -8),
            vendedorButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
        filtrosStack = stack
        tableView.tableHeaderView = cabecera
        let refrescar = UIRefreshControl()
        refrescar.addTarget(self, action: #selector(actualizarListado), for: .valueChanged)
        refreshControl = refrescar
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let cabecera = tableView.tableHeaderView, let stack = filtrosStack else { return }
        let ancho = tableView.bounds.width
        let tamano = stack.systemLayoutSizeFitting(
            CGSize(width: max(0, ancho - 32), height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        let alto = ceil(tamano.height + 16)
        if cabecera.frame.width != ancho || abs(cabecera.frame.height - alto) > 0.5 {
            cabecera.frame.size = CGSize(width: ancho, height: alto)
            tableView.tableHeaderView = cabecera
        }
    }

    @objc private func cambiarEstado() { cargar() }
    @objc private func actualizarListado() {
        contexto.refreshAllObjects()
        cargar()
        refreshControl?.endRefreshing()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { cargar() }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }

    private func actualizarVendedores() throws {
        let solicitud: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        // Incluye vendedores sin ventas y responsables de registros históricos, sin ocultar ventas.
        solicitud.predicate = NSPredicate(format: "rol == %@ OR ventas.@count > 0", "Vendedor")
        solicitud.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true),
                                     NSSortDescriptor(key: "usuario", ascending: true)]
        let usuarios = try contexto.fetch(solicitud)
        if let id = vendedorID, !usuarios.contains(where: { $0.objectID == id }) { vendedorID = nil }
        let seleccionado = usuarios.first { $0.objectID == vendedorID }
        vendedorButton.setTitle("Vendedor: \(seleccionado.map { nombreVendedor($0) } ?? "Todos")", for: .normal)
        var opciones = [UIAction(title: "Todos", state: vendedorID == nil ? .on : .off) { [weak self] _ in
            self?.seleccionarVendedor(nil)
        }]
        opciones += usuarios.map { usuario in
            let id = usuario.objectID
            return UIAction(title: nombreVendedor(usuario), state: vendedorID == id ? .on : .off) { [weak self] _ in
                self?.seleccionarVendedor(id)
            }
        }
        vendedorButton.menu = UIMenu(title: "Filtrar por vendedor", children: opciones)
    }

    private func seleccionarVendedor(_ id: NSManagedObjectID?) {
        guard autorizado else { cargar(); return }
        vendedorID = id
        cargar()
    }

    private func cargar() {
        guard contexto != nil else { return }
        ventas = []; resumen = []
        buscarSearchBar.isUserInteractionEnabled = autorizado
        estadoSegmented.isEnabled = autorizado
        vendedorButton.isEnabled = autorizado
        guard autorizado else {
            vendedorButton.menu = nil
            mostrarEstado("Se requiere una sesión Supervisor para consultar las ventas del equipo.")
            return
        }
        do {
            if mostrarResumen {
                for entidad in ["Producto", "Cliente", "Venta"] {
                    let solicitud = NSFetchRequest<NSFetchRequestResult>(entityName: entidad)
                    resumen.append((entidad == "Producto" ? "Productos" : (entidad == "Cliente" ? "Clientes" : "Ventas registradas"), try contexto.count(for: solicitud)))
                }
            } else {
                try actualizarVendedores()
                let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
                var filtros: [NSPredicate] = []
                let texto = (buscarSearchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                if !texto.isEmpty {
                    filtros.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@ OR producto.nombre CONTAINS[cd] %@ OR vendedor.nombre CONTAINS[cd] %@ OR vendedor.usuario CONTAINS[cd] %@", texto, texto, texto, texto))
                }
                if let id = vendedorID { filtros.append(NSPredicate(format: "vendedor == %@", id)) }
                if estadoSegmented.selectedSegmentIndex == 1 { filtros.append(NSPredicate(format: "anulada == NO")) }
                if estadoSegmented.selectedSegmentIndex == 2 { filtros.append(NSPredicate(format: "anulada == YES")) }
                solicitud.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
                solicitud.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
                solicitud.relationshipKeyPathsForPrefetching = ["cliente", "producto", "vendedor"]
                ventas = try contexto.fetch(solicitud)
                let filtrando = !texto.isEmpty || vendedorID != nil || estadoSegmented.selectedSegmentIndex != 0
                mostrarEstado(ventas.isEmpty ? (filtrando ? "No hay ventas que coincidan. Prueba otra búsqueda o cambia los filtros." : "Todavía no hay ventas registradas por el equipo.") : nil)
                return
            }
            mostrarEstado(nil)
        } catch {
            ventas = []; resumen = []
            mostrarEstado("No se pudieron consultar los datos. Vuelve a abrir la pestaña o desliza hacia abajo para actualizar.")
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
    private func nombreVendedor(_ usuario: Usuario?) -> String {
        guard let usuario = usuario else { return "Sin vendedor asociado" }
        return "\(usuario.nombre ?? "Sin nombre") (\(usuario.usuario ?? "Sin usuario"))"
    }
    private func fechaVenta(_ venta: Venta) -> String {
        venta.fecha.map { fecha.string(from: $0) } ?? "Sin fecha"
    }
    private func importe(_ valor: Double) -> String { String(format: "S/ %.2f", valor) }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mostrarResumen ? resumen.count : ventas.count
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { false }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "VentaEquipoCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "VentaEquipoCell")
        celda.selectionStyle = mostrarResumen ? .none : .default
        celda.accessoryType = mostrarResumen ? .none : .disclosureIndicator
        celda.textLabel?.numberOfLines = 0
        celda.detailTextLabel?.numberOfLines = 0
        if mostrarResumen {
            celda.textLabel?.text = "\(resumen[indexPath.row].0): \(resumen[indexPath.row].1)"
            celda.detailTextLabel?.text = nil
        } else {
            let venta = ventas[indexPath.row]
            celda.textLabel?.text = "\(fechaVenta(venta)) · \(venta.anulada ? "Anulada" : "Activa")"
            celda.detailTextLabel?.text = "Cliente: \(venta.cliente?.nombre ?? "Sin cliente")\nProducto: \(venta.producto?.nombre ?? "Sin producto")\nVendedor: \(nombreVendedor(venta.vendedor))\nCantidad: \(venta.cantidad) · Total: \(importe(venta.total))"
        }
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard autorizado, !mostrarResumen, ventas.indices.contains(indexPath.row) else { cargar(); return }
        let venta = ventas[indexPath.row]
        let mensaje = """
        Fecha: \(fechaVenta(venta))
        Cliente: \(venta.cliente?.nombre ?? "Sin cliente")
        Documento: \(venta.cliente?.documento ?? "—")
        Producto: \(venta.producto?.nombre ?? "Sin producto")
        Vendedor: \(nombreVendedor(venta.vendedor))
        Cantidad: \(venta.cantidad)
        Precio unitario: \(importe(venta.precioUnitario))
        Descuento: \(importe(venta.descuento))
        IGV: \(importe(venta.igv))
        Total: \(importe(venta.total))
        Estado: \(venta.anulada ? "Anulada" : "Activa")
        """ + (venta.anulada ? "\nMotivo: \(venta.motivoAnulacion ?? "Sin motivo registrado")" : "")
        let detalle = UIAlertController(title: "Detalle de venta", message: mensaje, preferredStyle: .alert)
        detalle.addAction(UIAlertAction(title: "Cerrar", style: .cancel))
        present(detalle, animated: true)
    }
}
