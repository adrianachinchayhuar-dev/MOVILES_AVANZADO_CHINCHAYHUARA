import UIKit
import CoreData

// Se reutiliza la escena del menú como contenedor de pestañas según el rol.
final class MenuPrincipalViewController: UITabBarController {
    var usuarioSesion: Usuario?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let usuario = usuarioSesion, !usuario.isDeleted,
              usuario.managedObjectContext != nil, !usuario.objectID.isTemporaryID,
              ["Vendedor", "Supervisor"].contains(usuario.rol ?? ""),
              let storyboard = storyboard else { return }

        func pantalla(_ id: String, _ titulo: String, _ icono: String) -> UINavigationController {
            let destino = storyboard.instantiateViewController(withIdentifier: id)
            switch destino {
            case let vc as ProductosViewController: vc.usuarioSesion = usuario
            case let vc as ClientesViewController: vc.usuarioSesion = usuario
            case let vc as RegistrarVentaViewController: vc.usuarioSesion = usuario
            case let vc as MisVentasViewController: vc.usuarioSesion = usuario
            default: break
            }
            destino.title = titulo
            let navegacion = UINavigationController(rootViewController: destino)
            navegacion.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), tag: 0)
            return navegacion
        }
        let productos = pantalla("ProductosViewController", "Productos", "shippingbox")
        let clientes = pantalla("ClientesViewController", "Clientes", "person.2")
        let cuenta = CuentaViewController(style: .insetGrouped)
        cuenta.usuarioSesion = usuario
        cuenta.alCerrarSesion = { [weak self] in self?.cerrarSesion() }
        let navegacionCuenta = UINavigationController(rootViewController: cuenta)
        navegacionCuenta.tabBarItem = UITabBarItem(title: "Cuenta", image: UIImage(systemName: "person.crop.circle"), tag: 0)
        if usuario.rol == "Vendedor" {
            viewControllers = [productos, clientes,
                pantalla("RegistrarVentaViewController", "Venta", "cart"),
                pantalla("MisVentasViewController", "Mis ventas", "list.bullet"), navegacionCuenta]
        } else {
            func supervisor(_ resumen: Bool) -> UINavigationController {
                let destino = SupervisorViewController(style: .insetGrouped)
                destino.usuarioSesion = usuario
                destino.mostrarResumen = resumen
                let navegacion = UINavigationController(rootViewController: destino)
                navegacion.tabBarItem = UITabBarItem(title: resumen ? "Resumen" : "Ventas",
                    image: UIImage(systemName: resumen ? "chart.bar" : "list.bullet"), tag: 0)
                return navegacion
            }
            viewControllers = [supervisor(true), supervisor(false), productos, clientes, navegacionCuenta]
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let usuario = usuarioSesion, !usuario.isDeleted,
              usuario.managedObjectContext != nil,
              ["Vendedor", "Supervisor"].contains(usuario.rol ?? "") else {
            cerrarSesion()
            return
        }
    }

    func cerrarSesion() {
        for navegacion in viewControllers ?? [] {
            for destino in (navegacion as? UINavigationController)?.viewControllers ?? [] {
                switch destino {
                case let vc as ProductosViewController: vc.usuarioSesion = nil
                case let vc as ClientesViewController: vc.usuarioSesion = nil
                case let vc as RegistrarVentaViewController: vc.usuarioSesion = nil
                case let vc as MisVentasViewController: vc.usuarioSesion = nil
                case let vc as SupervisorViewController: vc.usuarioSesion = nil
                case let vc as CuentaViewController:
                    vc.usuarioSesion = nil
                    vc.alCerrarSesion = nil
                default: break
                }
            }
        }
        usuarioSesion = nil
        setViewControllers([], animated: false)
        // Registro también puede presentar las pestañas: el cierre siempre vuelve al Login.
        let origen = presentingViewController
        let navegacion = (origen as? UINavigationController) ?? origen?.navigationController
        dismiss(animated: true) { [weak navegacion] in
            navegacion?.popToRootViewController(animated: false)
        }
    }
}
