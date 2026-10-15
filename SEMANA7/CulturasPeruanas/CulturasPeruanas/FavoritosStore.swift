import Foundation

/// Persiste únicamente identificadores. Todas las pantallas consultan la misma fuente.
final class FavoritosStore {
    static let compartido = FavoritosStore()
    private let defaults: UserDefaults
    private let clave = "culturasPeruanas.favoritos.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    private var identificadores: Set<String> {
        let guardados = Set(defaults.stringArray(forKey: clave) ?? [])
        let conocidos = Set(CatalogoCulturas.todas.map(\.id))
        return guardados.intersection(conocidos)
    }

    func contiene(_ id: String) -> Bool {
        identificadores.contains(id)
    }

    func agregar(_ id: String) {
        guard CatalogoCulturas.todas.contains(where: { $0.id == id }) else { return }
        var ids = identificadores
        ids.insert(id)
        guardar(ids)
    }

    func quitar(_ id: String) {
        var ids = identificadores
        ids.remove(id)
        guardar(ids)
    }

    func alternar(_ id: String) {
        if contiene(id) { quitar(id) } else { agregar(id) }
    }

    private func guardar(_ ids: Set<String>) {
        defaults.set(ids.sorted(), forKey: clave)
    }
}
