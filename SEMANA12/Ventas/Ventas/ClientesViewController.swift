import UIKit
import CoreData

final class ClientesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var documentoTextField: UITextField!
    @IBOutlet weak var guardarButton: UIButton!
    @IBOutlet weak var buscarSearchBar: UISearchBar!
    @IBOutlet weak var clientesTableView: UITableView!

    var usuarioSesion: Usuario? {
        didSet { if isViewLoaded { actualizarPermisos(); cargarClientes() } }
    }
    // Clientes está disponible para ambos roles.
    var rolesGestionPermitidos: Set<String> = ["Vendedor", "Supervisor"] {
        didSet { if isViewLoaded { actualizarPermisos() } }
    }
    private var contexto: NSManagedObjectContext!
    private var clientes: [Cliente] = []
    private var clienteEnEdicion: Cliente?
    private var sesionValida: Bool {
        guard let usuario = usuarioSesion else { return false }
        return !usuario.isDeleted && usuario.managedObjectContext != nil
            && ["Vendedor", "Supervisor"].contains(usuario.rol ?? "")
    }
    private var puedeGestionar: Bool {
        sesionValida && rolesGestionPermitidos.contains(usuarioSesion?.rol ?? "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate
        contexto = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contexto.persistentStoreCoordinator = app.persistentContainer.persistentStoreCoordinator
        clientesTableView.dataSource = self
        clientesTableView.delegate = self
        clientesTableView.keyboardDismissMode = .onDrag
        buscarSearchBar.delegate = self
        actualizarPermisos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contexto.refreshAllObjects()
        actualizarPermisos()
        cargarClientes()
    }

    private func actualizarPermisos() {
        nombreTextField.isEnabled = puedeGestionar
        documentoTextField.isEnabled = puedeGestionar
        guardarButton.isEnabled = puedeGestionar
        if !puedeGestionar { limpiarFormulario() }
        clientesTableView.reloadData()
    }

    private func tituloGuardar(_ titulo: String) {
        if var configuracion = guardarButton.configuration {
            configuracion.title = titulo
            guardarButton.configuration = configuracion
        } else { guardarButton.setTitle(titulo, for: .normal) }
    }

    private func limpiarFormulario() {
        clienteEnEdicion = nil
        nombreTextField.text = ""
        documentoTextField.text = ""
        tituloGuardar("Guardar cliente")
    }

    @IBAction func guardarCliente(_ sender: UIButton) {
        guard puedeGestionar else {
            alerta("Se requiere una sesión autorizada para gestionar clientes.")
            return
        }
        let nombre = (nombreTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let documento = (documentoTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !nombre.isEmpty, !documento.isEmpty else {
            alerta("Nombre completo y documento son obligatorios.")
            return
        }
        do {
            let solicitud: NSFetchRequest<Cliente> = Cliente.fetchRequest()
            var filtros = [NSPredicate(format: "documento ==[c] %@", documento)]
            if let cliente = clienteEnEdicion {
                filtros.append(NSPredicate(format: "SELF != %@", cliente))
            }
            solicitud.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
            guard try contexto.count(for: solicitud) == 0 else {
                alerta("Ya existe un cliente con ese documento.")
                return
            }
            let cliente = clienteEnEdicion ?? Cliente(context: contexto)
            cliente.nombre = nombre
            cliente.documento = documento
            try contexto.save()
            limpiarFormulario()
            view.endEditing(true)
            cargarClientes()
        } catch {
            contexto.rollback()
            alerta("No se pudo guardar el cliente. No se aplicaron los cambios.")
        }
    }

    private func cargarClientes() {
        guard contexto != nil else { return }
        guard sesionValida else {
            clientes = []
            clientesTableView.reloadData()
            return
        }
        let solicitud: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        let texto = (buscarSearchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !texto.isEmpty {
            solicitud.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@", texto, texto)
        }
        solicitud.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        do {
            clientes = try contexto.fetch(solicitud)
            clientesTableView.reloadData()
        } catch { alerta("No se pudieron consultar los clientes.") }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { cargarClientes() }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { clientes.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ClienteCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ClienteCell")
        let cliente = clientes[indexPath.row]
        celda.textLabel?.text = cliente.nombre
        celda.detailTextLabel?.text = "Documento: \(cliente.documento ?? "")"
        celda.selectionStyle = puedeGestionar ? .default : .none
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard puedeGestionar else { return }
        let cliente = clientes[indexPath.row]
        if clienteEnEdicion == cliente { limpiarFormulario(); return }
        clienteEnEdicion = cliente
        nombreTextField.text = cliente.nombre
        documentoTextField.text = cliente.documento
        tituloGuardar("Actualizar cliente")
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { puedeGestionar }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, puedeGestionar else { return }
        let cliente = clientes[indexPath.row]
        let confirmacion = UIAlertController(title: "Eliminar cliente", message: "¿Eliminar a \(cliente.nombre ?? "este cliente")?", preferredStyle: .alert)
        confirmacion.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        confirmacion.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.eliminar(cliente)
        })
        present(confirmacion, animated: true)
    }
    private func eliminar(_ cliente: Cliente) {
        guard puedeGestionar, !cliente.isDeleted else { return }
        do {
            let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
            solicitud.predicate = NSPredicate(format: "cliente == %@", cliente)
            guard try contexto.count(for: solicitud) == 0 else {
                alerta("No se puede eliminar: el cliente está asociado a ventas, incluso anuladas.")
                return
            }
            let estabaEnEdicion = clienteEnEdicion == cliente
            contexto.delete(cliente)
            try contexto.save()
            if estabaEnEdicion { limpiarFormulario() }
            cargarClientes()
        } catch {
            contexto.rollback()
            alerta("No se pudo eliminar el cliente. Puede tener ventas asociadas.")
        }
    }
    private func alerta(_ mensaje: String) {
        let aviso = UIAlertController(title: "Clientes", message: mensaje, preferredStyle: .alert)
        aviso.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(aviso, animated: true)
    }
}
