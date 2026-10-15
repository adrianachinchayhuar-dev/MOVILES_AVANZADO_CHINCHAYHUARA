import UIKit

/// El orden coincide con las relaciones del Tab Bar en Main.storyboard.
enum SeccionPrincipal: Int {
    case inicio, explorar, favoritos, lineaTiempo
}

class PrincipalTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = SeccionPrincipal.inicio.rawValue
        let secciones: [(String, String, String)] = [
            ("Inicio", "house", "house.fill"),
            ("Explorar", "safari", "safari.fill"),
            ("Favoritos", "heart", "heart.fill"),
            ("Línea de tiempo", "clock", "clock.fill")
        ]
        let barra = UITabBarAppearance()
        barra.configureWithOpaqueBackground()
        barra.backgroundColor = EstiloUI.marfil
        barra.shadowColor = EstiloUI.beige
        for item in [barra.stackedLayoutAppearance, barra.inlineLayoutAppearance,
                     barra.compactInlineLayoutAppearance] {
            item.normal.iconColor = EstiloUI.secundario
            item.normal.titleTextAttributes = [.foregroundColor: EstiloUI.secundario]
            item.selected.iconColor = EstiloUI.terracota
            item.selected.titleTextAttributes = [.foregroundColor: EstiloUI.terracota]
        }
        tabBar.standardAppearance = barra
        tabBar.scrollEdgeAppearance = barra
        tabBar.tintColor = EstiloUI.terracota

        for (index, controlador) in (viewControllers ?? []).enumerated() {
            guard index < secciones.count,
                  let navegador = controlador as? UINavigationController else { continue }
            let seccion = secciones[index]
            navegador.tabBarItem = UITabBarItem(title: seccion.0,
                image: UIImage(systemName: seccion.1),
                selectedImage: UIImage(systemName: seccion.2))
            let apariencia = UINavigationBarAppearance()
            apariencia.configureWithOpaqueBackground()
            apariencia.backgroundColor = EstiloUI.crema
            apariencia.shadowColor = .clear
            apariencia.titleTextAttributes = [.foregroundColor: EstiloUI.marron]
            apariencia.largeTitleTextAttributes = [
                .foregroundColor: EstiloUI.marron,
                .font: EstiloUI.fuente(.largeTitle, serif: true)
            ]
            navegador.navigationBar.standardAppearance = apariencia
            navegador.navigationBar.scrollEdgeAppearance = apariencia
            navegador.navigationBar.compactAppearance = apariencia
            navegador.navigationBar.tintColor = EstiloUI.terracota
        }
    }
}
