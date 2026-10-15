import Foundation

/// Fuente única de los seis registros originales.
enum CatalogoCulturas {
    static let todas: [Cultura] = [
        Cultura(
            id: "caral",
            nombre: "Caral",
            region: "Lima",
            descripcion: "Una de las civilizaciones más antiguas de América, reconocida por sus construcciones monumentales.",
            imagen: "caral"
        ),
        Cultura(
            id: "chavin",
            nombre: "Chavín",
            region: "Áncash",
            descripcion: "Cultura destacada por su arquitectura religiosa y esculturas como el Lanzón Monolítico.",
            imagen: "chavin"
        ),
        Cultura(
            id: "paracas",
            nombre: "Paracas",
            region: "Ica",
            descripcion: "Cultura reconocida por sus textiles, mantos funerarios y conocimientos médicos.",
            imagen: "paracas"
        ),
        Cultura(
            id: "nazca",
            nombre: "Nazca",
            region: "Ica",
            descripcion: "Cultura conocida por las Líneas de Nazca, su cerámica y sus sistemas hidráulicos.",
            imagen: "nazca"
        ),
        Cultura(
            id: "moche",
            nombre: "Moche",
            region: "La Libertad",
            descripcion: "Cultura de la costa norte del Perú, destacada por su cerámica y sus construcciones ceremoniales.",
            imagen: "moche"
        ),
        Cultura(
            id: "inca",
            nombre: "Inca",
            region: "Cusco",
            descripcion: "Civilización andina que desarrolló el Tahuantinsuyo, con grandes avances en arquitectura e ingeniería.",
            imagen: "inca"
        )
    ]
}
