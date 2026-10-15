import Foundation

/// Fuente única de los seis registros originales.
enum CatalogoCulturas {
    static let todas: [Cultura] = [
        Cultura(
            id: "caral",
            nombre: "Caral",
            region: "Lima",
            descripcion: "Una de las civilizaciones más antiguas de América, reconocida por sus construcciones monumentales.",
            imagen: "caral",
            periodoHistorico: PeriodoHistorico(
                inicio: -3000, fin: -1800,
                fuente: "Ministerio de Cultura: Caral-Supe",
                enlaceFuente: "https://patrimoniomundial.cultura.pe/sitiosdelpatrimoniomundial/ciudad-sagrada-de-caral-supe",
                nota: "Referencia para Caral-Supe durante el Arcaico Tardío; no representa un comienzo o final absoluto."
            )
        ),
        Cultura(
            id: "chavin",
            nombre: "Chavín",
            region: "Áncash",
            descripcion: "Cultura destacada por su arquitectura religiosa y esculturas como el Lanzón Monolítico.",
            imagen: "chavin",
            periodoHistorico: PeriodoHistorico(
                inicio: -1000, fin: -500,
                fuente: "The Met: Andes, 1000 a. C.-1 d. C.",
                enlaceFuente: "https://www.metmuseum.org/toah/ht/04/sac.html",
                nota: "Cronología adoptada del Met. Los límites varían según se estudien el centro ceremonial, su influencia o la tradición cultural."
            )
        ),
        Cultura(
            id: "paracas",
            nombre: "Paracas",
            region: "Ica",
            descripcion: "Cultura reconocida por sus textiles, mantos funerarios y conocimientos médicos.",
            imagen: "paracas",
            periodoHistorico: PeriodoHistorico(
                inicio: -700, fin: 100,
                fuente: "The Met: Andes, 1000 a. C.-1 d. C.",
                enlaceFuente: "https://www.metmuseum.org/toah/ht/04/sac.html",
                nota: "Se adopta el rango del Met. El Ministerio de Cultura también publica 800 a. C.-200 d. C.; las delimitaciones varían según las fases consideradas."
            )
        ),
        Cultura(
            id: "nazca",
            nombre: "Nazca",
            region: "Ica",
            descripcion: "Cultura conocida por las Líneas de Nazca, su cerámica y sus sistemas hidráulicos.",
            imagen: "nazca",
            periodoHistorico: PeriodoHistorico(
                inicio: 100, fin: 700,
                fuente: "The Met: Andes, 1-500 d. C.",
                enlaceFuente: "https://www.metmuseum.org/toah/ht/05/sac.html",
                nota: "Rango de la cronología general del Met; no abarca todas las fases antecedentes de la tradición Nazca."
            )
        ),
        Cultura(
            id: "moche",
            nombre: "Moche",
            region: "La Libertad",
            descripcion: "Cultura de la costa norte del Perú, destacada por su cerámica y sus construcciones ceremoniales.",
            imagen: "moche",
            periodoHistorico: PeriodoHistorico(
                inicio: 100, fin: 800,
                fuente: "The Met: Andes, 1-500 d. C.",
                enlaceFuente: "https://www.metmuseum.org/toah/ht/05/sac.html",
                nota: "Referencia general; las fases de desarrollo y transición varían entre los valles de la costa norte."
            )
        ),
        Cultura(
            id: "inca",
            nombre: "Inca",
            region: "Cusco",
            descripcion: "Civilización andina que desarrolló el Tahuantinsuyo, con grandes avances en arquitectura e ingeniería.",
            imagen: "inca",
            periodoHistorico: PeriodoHistorico(
                inicio: 1200, fin: 1533,
                fuente: "Smithsonian: El Gran Camino Inka",
                enlaceFuente: "https://americanindian.si.edu/nk360/inka-innovacion/timeline/timeline",
                nota: "Incluye el desarrollo anterior al imperio. El Met delimita el Estado imperial entre 1438 y 1532 d. C.; este rango no significa el fin de la cultura inca."
            )
        )
    ]
}
