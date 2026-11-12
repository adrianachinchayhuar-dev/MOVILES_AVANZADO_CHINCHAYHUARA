import UIKit
import CoreData

final class RegistrarVentaViewController: UIViewController {
    @IBOutlet weak var clienteButton: UIButton!
    @IBOutlet weak var productoButton: UIButton!
    @IBOutlet weak var cantidadTextField: UITextField!
    @IBOutlet weak var precioUnitarioLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var estadoLabel: UILabel!

    var usuarioSesion: Usuario? {
        didSet {
            if isViewLoaded { limpiarSeleccion(); actualizarPermisos(); cargarSelectores() }
        }
    }
    private var contexto: NSManagedObjectContext!
    private var clienteID: NSManagedObjectID?
    private var productoID: NSManagedObjectID?
    private var registrando = false

    // Registrar ventas corresponde exclusivamente al Vendedor autenticado.
    private var autorizado: Bool {
        guard let usuario = usuarioSesion, !usuario.isDeleted,
              usuario.managedObjectContext != nil else { return false }
        return usuario.rol == "Vendedor"
    }

    private enum ErrorVenta: LocalizedError {
        case validacion(String)
        var errorDescription: String? {
            switch self { case .validacion(let mensaje): return mensaje }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate
        contexto = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        contexto.persistentStoreCoordinator = app.persistentContainer.persistentStoreCoordinator
        // La política por defecto de Core Data rechaza conflictos de stock; no los sobrescribe.
        cantidadTextField.keyboardType = .numberPad
        clienteButton.showsMenuAsPrimaryAction = true
        productoButton.showsMenuAsPrimaryAction = true
        limpiarSeleccion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contexto.reset()
        limpiarSeleccion()
        actualizarPermisos()
        cargarSelectores()
    }

    private func titulo(_ boton: UIButton, _ texto: String) {
        if var configuracion = boton.configuration {
            configuracion.title = texto
            boton.configuration = configuracion
        } else { boton.setTitle(texto, for: .normal) }
    }

    private func actualizarPermisos() {
        let habilitado = autorizado && !registrando
        clienteButton.isEnabled = habilitado
        productoButton.isEnabled = habilitado
        cantidadTextField.isEnabled = habilitado
        registrarButton.isEnabled = habilitado
        estadoLabel.text = autorizado
            ? "Selecciona cliente y producto e ingresa la cantidad."
            : "Registrar ventas está disponible solo para Vendedores."
    }

    private func limpiarSeleccion() {
        clienteID = nil
        productoID = nil
        cantidadTextField.text = ""
        titulo(clienteButton, "Seleccionar cliente")
        titulo(productoButton, "Seleccionar producto")
        precioUnitarioLabel.text = "Precio unitario: —"
        mostrarImportes(nil)
    }

    private func mostrarImportes(_ importes: CalculoVenta?) {
        guard let importes = importes else {
            subtotalLabel.text = "Subtotal: —"
            descuentoLabel.text = "Descuento: —"
            igvLabel.text = "IGV: —"
            totalLabel.text = "Total: —"
            return
        }
        estadoLabel.text = "Cliente \(importes.categoria) · Revisa los importes y registra la venta."
        subtotalLabel.text = "Subtotal: \(moneda(importes.subtotal))"
        descuentoLabel.text = "Descuento: \(moneda(importes.descuento))"
        igvLabel.text = "IGV: \(moneda(importes.igv))"
        totalLabel.text = "Total: \(moneda(importes.total))"
    }

    private func cargarSelectores() {
        guard contexto != nil else { return }
        clienteButton.menu = nil
        productoButton.menu = nil
        guard autorizado else { return }
        do {
            let solicitudClientes: NSFetchRequest<Cliente> = Cliente.fetchRequest()
            solicitudClientes.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
            let clientes = try contexto.fetch(solicitudClientes)
            clienteButton.menu = UIMenu(children: clientes.map { cliente in
                let id = cliente.objectID
                let texto = "\(cliente.nombre ?? "Sin nombre") · \(cliente.documento ?? "")"
                return UIAction(title: texto) { [weak self] _ in
                    guard let self = self, self.autorizado, !self.registrando else { return }
                    self.clienteID = id
                    self.titulo(self.clienteButton, texto)
                    self.actualizarCalculo()
                }
            })
            let solicitudProductos: NSFetchRequest<Producto> = Producto.fetchRequest()
            solicitudProductos.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
            let productos = try contexto.fetch(solicitudProductos)
            productoButton.menu = UIMenu(children: productos.map { producto in
                let id = producto.objectID
                let texto = "\(producto.nombre ?? "Sin nombre") · Stock: \(producto.stock)"
                let precio = producto.precio
                return UIAction(title: texto) { [weak self] _ in
                    guard let self = self, self.autorizado, !self.registrando else { return }
                    self.productoID = id
                    self.titulo(self.productoButton, texto)
                    self.precioUnitarioLabel.text = "Precio unitario: \(self.moneda(Decimal(precio)))"
                    self.actualizarCalculo()
                }
            })
            if clientes.isEmpty || productos.isEmpty {
                estadoLabel.text = "Registra primero un cliente y un producto para realizar una venta."
            }
        } catch { alerta("No se pudieron cargar clientes y productos.") }
    }

    @IBAction func cantidadCambiada(_ sender: UITextField) { actualizarCalculo() }

    private func moneda(_ valor: Decimal) -> String {
        let formato = NumberFormatter()
        formato.locale = Locale(identifier: "es_PE")
        formato.numberStyle = .decimal
        formato.minimumFractionDigits = 2
        formato.maximumFractionDigits = 2
        return "S/ " + (formato.string(from: NSDecimalNumber(decimal: valor)) ?? "—")
    }

    private func calcularImportes(precio: Double, cantidad: Int64, cliente: Cliente) throws -> CalculoVenta {
        let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
        solicitud.predicate = NSPredicate(format: "cliente == %@ AND anulada == NO", cliente)
        let ventas = try contexto.fetch(solicitud)
        var acumulado: Decimal = 0
        for venta in ventas {
            guard venta.total.isFinite else {
                throw ErrorVenta.validacion("No se pudo calcular la categoría del cliente. Revisa sus ventas anteriores.")
            }
            acumulado += Decimal(venta.total)
        }
        return CalculoVenta(precio: Decimal(precio), cantidad: cantidad, acumulado: acumulado)
    }

    private func actualizarCalculo() {
        mostrarImportes(nil)
        guard autorizado else { actualizarPermisos(); return }
        guard let clienteID = clienteID, let productoID = productoID else {
            estadoLabel.text = "Selecciona cliente y producto e ingresa la cantidad."
            return
        }
        guard let cantidad = Int64((cantidadTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)), cantidad > 0 else {
            estadoLabel.text = "Ingresa una cantidad entera mayor que cero."
            return
        }
        do {
            let cliente = try obtener(Cliente.self, entidad: "Cliente", id: clienteID)
            let producto = try obtener(Producto.self, entidad: "Producto", id: productoID)
            guard producto.precio.isFinite, producto.precio > 0 else {
                estadoLabel.text = "El producto necesita un precio mayor que cero."
                return
            }
            guard cantidad <= producto.stock else {
                estadoLabel.text = "Stock disponible: \(producto.stock). Reduce la cantidad."
                return
            }
            mostrarImportes(try calcularImportes(precio: producto.precio, cantidad: cantidad, cliente: cliente))
        } catch { estadoLabel.text = "No se pudieron consultar los datos. Vuelve a seleccionar cliente y producto." }
    }

    private func obtener<T: NSManagedObject>(_ tipo: T.Type, entidad: String,
                                              id: NSManagedObjectID) throws -> T {
        let solicitud = NSFetchRequest<T>(entityName: entidad)
        solicitud.predicate = NSPredicate(format: "SELF == %@", id)
        solicitud.fetchLimit = 1
        guard let objeto = try contexto.fetch(solicitud).first else {
            throw ErrorVenta.validacion("El registro de \(entidad) ya no existe. Vuelve a seleccionarlo.")
        }
        return objeto
    }

    @IBAction func registrarVenta(_ sender: UIButton) {
        guard !registrando else { return }
        guard autorizado, let usuario = usuarioSesion else {
            alerta("Se requiere un Vendedor autenticado.")
            return
        }
        guard let clienteID = clienteID, let productoID = productoID else {
            alerta("Selecciona un cliente y un producto existentes.")
            return
        }
        let texto = (cantidadTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard let cantidad = Int64(texto), cantidad > 0 else {
            alerta("La cantidad debe ser un entero mayor que cero.")
            return
        }
        guard !usuario.objectID.isTemporaryID else {
            alerta("El usuario de sesión debe estar guardado.")
            return
        }
        registrando = true
        actualizarPermisos()
        var guardado = false
        defer {
            if !guardado { registrando = false; actualizarPermisos(); actualizarCalculo() }
        }
        do {
            // Reconsulta datos persistidos para no vender con un stock antiguo del menú.
            contexto.reset()
            let cliente = try obtener(Cliente.self, entidad: "Cliente", id: clienteID)
            let producto = try obtener(Producto.self, entidad: "Producto", id: productoID)
            let vendedor = try obtener(Usuario.self, entidad: "Usuario", id: usuario.objectID)
            guard vendedor.rol == "Vendedor" else {
                throw ErrorVenta.validacion("El usuario ya no tiene un rol autorizado.")
            }
            guard producto.stock >= cantidad else {
                throw ErrorVenta.validacion("Stock insuficiente. Disponible: \(producto.stock).")
            }
            guard producto.precio.isFinite, producto.precio > 0 else {
                throw ErrorVenta.validacion("El producto debe tener un precio válido mayor que cero.")
            }
            let importes = try calcularImportes(precio: producto.precio, cantidad: cantidad, cliente: cliente)
            guard [importes.subtotal, importes.descuento, importes.igv, importes.total]
                .allSatisfy({ !$0.isNaN && $0 >= 0 && NSDecimalNumber(decimal: $0).doubleValue.isFinite }) else {
                throw ErrorVenta.validacion("El cálculo produjo importes inválidos.")
            }
            let venta = Venta(context: contexto)
            venta.cliente = cliente
            venta.producto = producto
            venta.vendedor = vendedor
            venta.cantidad = cantidad
            venta.precioUnitario = producto.precio
            venta.descuento = NSDecimalNumber(decimal: importes.descuento).doubleValue
            venta.igv = NSDecimalNumber(decimal: importes.igv).doubleValue
            venta.total = NSDecimalNumber(decimal: importes.total).doubleValue
            venta.fecha = Date()
            venta.anulada = false
            producto.stock -= cantidad
            // Venta y stock se persisten juntos; si falla, rollback revierte ambos.
            try contexto.save()
            guardado = true
            mostrarImportes(importes)
            let aviso = UIAlertController(title: "Venta registrada", message: "La venta y el stock se guardaron correctamente.", preferredStyle: .alert)
            aviso.addAction(UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.limpiarSeleccion()
                self.registrando = false
                self.actualizarPermisos()
                self.cargarSelectores()
            })
            present(aviso, animated: true)
        } catch {
            contexto.rollback()
            alerta((error as? ErrorVenta)?.localizedDescription ?? "No se pudo guardar la venta. No se aplicaron cambios de stock. Vuelve a seleccionar los datos.")
        }
    }

    private func alerta(_ mensaje: String) {
        let aviso = UIAlertController(title: "Registrar venta", message: mensaje, preferredStyle: .alert)
        aviso.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(aviso, animated: true)
    }
}
