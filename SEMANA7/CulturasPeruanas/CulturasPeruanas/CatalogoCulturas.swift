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
            contenidoCultural: contenidoCaral,
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
            contenidoCultural: contenidoChavin,
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
            contenidoCultural: contenidoParacas,
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
            contenidoCultural: contenidoNazca,
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
            contenidoCultural: contenidoMoche,
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
            contenidoCultural: contenidoInca,
            periodoHistorico: PeriodoHistorico(
                inicio: 1200, fin: 1533,
                fuente: "Smithsonian: El Gran Camino Inka",
                enlaceFuente: "https://americanindian.si.edu/nk360/inka-innovacion/timeline/timeline",
                nota: "Incluye el desarrollo anterior al imperio. El Met delimita el Estado imperial entre 1438 y 1532 d. C.; este rango no significa el fin de la cultura inca."
            )
        )
    ]

    // Fuentes locales: los enlaces solo se consultan cuando el usuario los abre.
    private enum Fuentes {
        static let caralPlan = FuenteHistorica(titulo: "Zona Arqueológica Caral · Plan Maestro, volumen I (PDF)",
            enlace: "https://www.zonacaral.gob.pe/downloads/plan-maestro/pm-volumen_i.pdf")
        static let caralPatrimonio = FuenteHistorica(titulo: "Ministerio de Cultura · Caral-Supe",
            enlace: "https://patrimoniomundial.cultura.pe/sitiosdelpatrimoniomundial/ciudad-sagrada-de-caral-supe")
        static let chavin = FuenteHistorica(titulo: "UNESCO · Sitio arqueológico de Chavín",
            enlace: "https://whc.unesco.org/en/list/330/")
        static let andesAntiguos = FuenteHistorica(titulo: "The Met · Andes, 1000 a. C.–1 d. C.",
            enlace: "https://www.metmuseum.org/toah/ht/04/sac.html")
        static let paracasCeramica = FuenteHistorica(titulo: "The Met · Cerámica pintada Paracas",
            enlace: "https://www.metmuseum.org/art/collection/search/309468")
        static let andesTempranos = FuenteHistorica(titulo: "The Met · Andes, 1–500 d. C.",
            enlace: "https://www.metmuseum.org/toah/ht/05/sac.html")
        static let retratosMoche = FuenteHistorica(titulo: "The Met · Huacos retrato Moche",
            enlace: "https://www.metmuseum.org/essays/moche-portrait-head-vessels")
        static let textiles = FuenteHistorica(titulo: "The Met · Textiles andinos",
            enlace: "https://www.metmuseum.org/essays/andean-textiles")
        static let caminos = FuenteHistorica(titulo: "UNESCO · Qhapaq Ñan",
            enlace: "https://whc.unesco.org/en/list/1459/")
    }

    private static let contenidoCaral = ContenidoCultural(datosCuriosos: [
        DatoCurioso(titulo: "32 flautas", descripcion: "Un conjunto de flautas de hueso hallado en el sector del Anfiteatro evidencia la práctica musical colectiva. La cifra corresponde a ese hallazgo, no al total de instrumentos de la civilización.", fuentes: [Fuentes.caralPlan]),
        DatoCurioso(titulo: "Piedras entre fibras", descripcion: "Las shicras eran bolsas de fibras vegetales rellenas de piedras, utilizadas como relleno en las construcciones.", fuentes: [Fuentes.caralPlan]),
        DatoCurioso(titulo: "Plazas bajo el nivel del suelo", descripcion: "Las plazas circulares hundidas formaban parte de los espacios ceremoniales del asentamiento.", fuentes: [Fuentes.caralPatrimonio])
    ], legado: "Su organización del espacio permite estudiar cómo una sociedad temprana coordinó actividades públicas y reunió a comunidades del valle de Supe.", fuentesLegado: [Fuentes.caralPatrimonio])

    private static let contenidoChavin = ContenidoCultural(datosCuriosos: [
        DatoCurioso(titulo: "Un mundo interior", descripcion: "Dentro del complejo se construyeron galerías conectadas con conductos de ventilación y drenaje.", fuentes: [Fuentes.chavin]),
        DatoCurioso(titulo: "Símbolos de piedra", descripcion: "Los relieves combinan rasgos humanos y animales. Las cabezas clavas son parte de este lenguaje visual simbólico.", fuentes: [Fuentes.chavin]),
        DatoCurioso(titulo: "Peregrinos de distintos lugares", descripcion: "Chavín de Huántar recibió personas de regiones y lenguas diferentes, convirtiéndose en un punto de encuentro religioso.", fuentes: [Fuentes.chavin])
    ], legado: "Su patrimonio ayuda a comprender cómo las creencias compartidas podían conectar poblaciones andinas con distintas formas de vida.", fuentesLegado: [Fuentes.chavin])

    private static let contenidoParacas = ContenidoCultural(datosCuriosos: [
        DatoCurioso(titulo: "Capas para la memoria", descripcion: "Los cuerpos de algunos difuntos eran envueltos en sucesivas capas de telas, formando fardos funerarios.", fuentes: [Fuentes.andesAntiguos]),
        DatoCurioso(titulo: "Personajes entre hilos", descripcion: "Los bordados muestran animales y seres con elaborada indumentaria: los tejidos también transmitían imágenes y creencias.", fuentes: [Fuentes.andesAntiguos]),
        DatoCurioso(titulo: "Pintura después del fuego", descripcion: "En parte de la cerámica Paracas, los colores se aplicaban después de la cocción con pigmentos y un aglutinante.", fuentes: [Fuentes.paracasCeramica])
    ], legado: "La conservación de sus materiales funerarios permite acercarnos a la manera en que estas comunidades expresaban identidad y acompañaban a sus difuntos.", fuentesLegado: [Fuentes.andesAntiguos])

    private static let contenidoNazca = ContenidoCultural(datosCuriosos: [
        DatoCurioso(titulo: "Dibujar retirando piedras", descripcion: "Para crear geoglifos se retiraban piedras oscuras de la superficie, dejando visible el suelo más claro.", fuentes: [Fuentes.andesTempranos]),
        DatoCurioso(titulo: "Color antes de la cocción", descripcion: "Sus ceramistas aplicaban pigmentos minerales antes de cocer las piezas, con imágenes de plantas, animales y seres mitológicos.", fuentes: [Fuentes.andesTempranos]),
        DatoCurioso(titulo: "Encuentros en Cahuachi", descripcion: "Cahuachi fue un importante centro ceremonial que reunió peregrinos en el valle de Nazca.", fuentes: [Fuentes.andesTempranos])
    ], legado: "Sus representaciones permiten explorar la relación entre paisaje, reuniones ceremoniales y creencias de las comunidades de la costa sur.", fuentesLegado: [Fuentes.andesTempranos])

    private static let contenidoMoche = ContenidoCultural(datosCuriosos: [
        DatoCurioso(titulo: "Rostros con detalles", descripcion: "Algunos huacos retrato representan pliegues del rostro, cejas y cicatrices. La identidad exacta de las personas no siempre puede establecerse.", fuentes: [Fuentes.retratosMoche]),
        DatoCurioso(titulo: "Una matriz, varias piezas", descripcion: "Algunos retratos de fases tardías fueron hechos con moldes que permitían producir más de una vasija a partir de una misma matriz.", fuentes: [Fuentes.retratosMoche]),
        DatoCurioso(titulo: "Muros que narran", descripcion: "En Huaca de la Luna se realizaron relieves y pinturas con personajes y escenas vinculados al mundo ceremonial.", fuentes: [Fuentes.andesTempranos])
    ], legado: "Sus imágenes ofrecen una fuente para investigar personajes y ceremonias de la costa norte, aunque muchas de sus interpretaciones continúan en estudio.", fuentesLegado: [Fuentes.retratosMoche, Fuentes.andesTempranos])

    private static let contenidoInca = ContenidoCultural(datosCuriosos: [
        DatoCurioso(titulo: "Información en nudos", descripcion: "Los quipus utilizaban cuerdas y nudos para registrar información. Esta tradición también estuvo presente en otras sociedades andinas.", fuentes: [Fuentes.textiles]),
        DatoCurioso(titulo: "Geometría en la ropa", descripcion: "Los tocapus son motivos geométricos de determinados tejidos incas. Su significado no debe confundirse con una escritura completamente descifrada.", fuentes: [Fuentes.textiles]),
        DatoCurioso(titulo: "Caminos con historia previa", descripcion: "El Qhapaq Ñan integró rutas de comunicación y transporte, aprovechando también infraestructura anterior a los incas.", fuentes: [Fuentes.caminos])
    ], legado: "Su experiencia muestra cómo comunidades de territorios diversos podían vincularse mediante sistemas de circulación, administración y trabajo especializado.", fuentesLegado: [Fuentes.caminos, Fuentes.textiles])
}
