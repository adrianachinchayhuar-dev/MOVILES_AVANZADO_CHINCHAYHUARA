import UIKit
import CoreData

final class ProductosViewController: UIViewController, UITableViewDataSource,
                                     UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var productosTableView: UITableView!
    @IBOutlet weak var buscarSearchBar: UISearchBar!
    @IBOutlet weak var categoriaTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var precioTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var guardarButton: UIButton!


    var usuarioSesion: Usuario? {
        didSet {
            if isViewLoaded { actualizarPermisos(); cargarProductos() }
        }
    }

    private var productos: [Producto] = []
    private var productoEnEdicion: Producto?
    // Contexto independiente: un fallo no revierte cambios de otras pantallas.
    private var contexto: NSManagedObjectContext!

    private var puedeModificar: Bool {
        guard let usuario = usuarioSesion, !usuario.isDeleted,
              usuario.managedObjectContext != nil else { return false }
        return usuario.rol == "Supervisor"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        productosTableView.dataSource = self
        productosTableView.delegate = self
        buscarSearchBar.delegate = self
        buscarSearchBar.text = ""
        buscarSearchBar.placeholder = "Buscar producto"
        buscarSearchBar.scopeButtonTitles = ["Nombre", "Categoría"]
        buscarSearchBar.showsScopeBar = true
        buscarSearchBar.selectedScopeButtonIndex = 0
        precioTextField.keyboardType = .decimalPad
        stockTextField.keyboardType = .numberPad
        productosTableView.keyboardDismissMode = .onDrag
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            guardarButton.isEnabled = false
            return
        }
        contexto = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contexto.persistentStoreCoordinator = app.persistentContainer.persistentStoreCoordinator
        actualizarTituloBoton()
        actualizarPermisos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizarPermisos()
        contexto?.refreshAllObjects()
        cargarProductos()
    }

    private func actualizarPermisos() {
        let habilitado = contexto != nil && puedeModificar
        guardarButton.isEnabled = habilitado
        [nombreTextField, categoriaTextField, precioTextField, stockTextField].forEach {
            $0?.isEnabled = habilitado
        }
        if !habilitado { limpiarFormulario() }
        productosTableView.reloadData()
    }

    private func actualizarTituloBoton() {
        let titulo = productoEnEdicion == nil ? "Guardar producto" : "Actualizar producto"
        // Los botones configurados en Storyboard pueden usar UIButton.Configuration.
        if var configuracion = guardarButton.configuration {
            configuracion.title = titulo
            guardarButton.configuration = configuracion
        } else {
            guardarButton.setTitle(titulo, for: .normal)
        }
    }

    private func limpiarFormulario() {
        productoEnEdicion = nil
        [nombreTextField, categoriaTextField, precioTextField, stockTextField].forEach {
            $0?.text = ""
        }
        actualizarTituloBoton()
    }

    @IBAction func guardarProducto(_ sender: UIButton) {
        guard validarPermiso() else { return }
        let valores = [nombreTextField, categoriaTextField, precioTextField, stockTextField].map {
            ($0?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        }
        guardar(producto: productoEnEdicion, valores: valores)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargarProductos()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBar.placeholder = selectedScope == 0 ? "Buscar producto" : "Categoría exacta"
        cargarProductos()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    private func cargarProductos() {
        guard let contexto = contexto else { return }
        guard let usuario = usuarioSesion, !usuario.isDeleted,
              usuario.managedObjectContext != nil,
              ["Vendedor", "Supervisor"].contains(usuario.rol ?? "") else {
            productos = []
            productosTableView.reloadData()
            return
        }
        let solicitud: NSFetchRequest<Producto> = Producto.fetchRequest()
        let texto = (buscarSearchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !texto.isEmpty {
            solicitud.predicate = buscarSearchBar.selectedScopeButtonIndex == 1
                ? NSPredicate(format: "categoria ==[cd] %@", texto)
                : NSPredicate(format: "nombre CONTAINS[cd] %@", texto)
        }
        solicitud.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        do {
            productos = try contexto.fetch(solicitud)
            productosTableView.reloadData()
        } catch {
            mostrarAlerta("No se pudieron listar los productos. Intenta nuevamente.")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // No requiere prototipo ni clase de celda adicional en Storyboard.
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ProductoCell")
        let producto = productos[indexPath.row]
        celda.textLabel?.text = "\(producto.nombre ?? "") · \(producto.categoria ?? "")"
        celda.detailTextLabel?.text = String(format: "Precio: %.2f · Stock: %lld", producto.precio, producto.stock)
        celda.detailTextLabel?.textColor = producto.stock > 10 ? .systemGreen
            : (producto.stock >= 6 ? UIColor(red: 1, green: 0.65, blue: 0, alpha: 1) : .systemRed)
        celda.selectionStyle = puedeModificar ? .default : .none
        celda.accessoryType = puedeModificar ? .disclosureIndicator : .none
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard puedeModificar else { return }
        let producto = productos[indexPath.row]
        // Tocar nuevamente el producto en edición permite volver a registrar uno nuevo.
        if productoEnEdicion == producto {
            limpiarFormulario()
            return
        }
        productoEnEdicion = producto
        nombreTextField.text = producto.nombre
        categoriaTextField.text = producto.categoria
        precioTextField.text = String(producto.precio)
        stockTextField.text = String(producto.stock)
        actualizarTituloBoton()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        puedeModificar
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, validarPermiso() else { return }
        let producto = productos[indexPath.row]
        let alerta = UIAlertController(title: "Eliminar producto",
                                      message: "¿Eliminar \(producto.nombre ?? "este producto")?",
                                      preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.eliminar(producto)
        })
        present(alerta, animated: true)
    }

    private func guardar(producto: Producto?, valores: [String]) {
        guard validarPermiso(), let contexto = contexto else { return }
        guard !valores[0].isEmpty, !valores[1].isEmpty,
              let precio = Double(valores[2].replacingOccurrences(of: ",", with: ".")),
              precio.isFinite, precio > 0,
              let stock = Int64(valores[3]), stock >= 0 else {
            mostrarAlerta("Nombre y categoría son obligatorios. El precio debe ser mayor que cero "
                          + "(sin separador de miles) y el stock debe ser un entero no negativo.")
            return
        }
        let destino = producto ?? Producto(context: contexto)
        destino.nombre = valores[0]
        destino.categoria = valores[1]
        destino.precio = precio
        destino.stock = stock
        do {
            try contexto.save()
            limpiarFormulario()
            view.endEditing(true)
            cargarProductos()
        } catch {
            contexto.rollback()
            mostrarAlerta("No se pudo guardar el producto. No se aplicaron los cambios.")
        }
    }

    private func eliminar(_ producto: Producto) {
        guard validarPermiso(), let contexto = contexto, !producto.isDeleted else { return }
        do {
            // Incluye ventas anuladas: cualquier relación impide la eliminación.
            let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
            solicitud.predicate = NSPredicate(format: "producto == %@", producto)
            if try contexto.count(for: solicitud) > 0 {
                mostrarAlerta("No se puede eliminar este producto porque está relacionado con ventas, "
                              + "incluso si están anuladas.")
                return
            }
            let eraProductoEnEdicion = productoEnEdicion == producto
            contexto.delete(producto)
            try contexto.save() // La regla Deny del modelo también protege la relación.
            if eraProductoEnEdicion { limpiarFormulario() }
            cargarProductos()
        } catch {
            contexto.rollback()
            mostrarAlerta("No se pudo eliminar el producto. Puede tener ventas relacionadas. "
                          + "No se aplicaron los cambios.")
        }
    }

    @discardableResult
    private func validarPermiso() -> Bool {
        guard puedeModificar else {
            mostrarAlerta("Solo un Supervisor autenticado puede registrar, editar o eliminar productos.")
            return false
        }
        return true
    }

    private func mostrarAlerta(_ mensaje: String) {
        let alerta = UIAlertController(title: "Productos", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
