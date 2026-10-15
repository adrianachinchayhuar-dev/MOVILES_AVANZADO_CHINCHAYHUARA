# 🇵🇪 Culturas Peruanas

Aplicación móvil desarrollada para iOS utilizando **Swift, UIKit y Storyboard**, cuyo objetivo es presentar información educativa sobre algunas de las principales culturas del antiguo Perú mediante una interfaz interactiva, organizada e intuitiva.

El proyecto permite explorar culturas, consultar información histórica, realizar búsquedas, guardar favoritas y visualizar una línea de tiempo con sus períodos aproximados.

## Tecnologías utilizadas

- **Lenguaje:** Swift
- **Framework:** UIKit
- **Diseño de interfaces:** Storyboard y Auto Layout
- **Entorno de desarrollo:** Xcode
- **Persistencia local:** UserDefaults
- **Arquitectura:** Modelo-Vista-Controlador (MVC)
- **Plataforma:** iOS

## Funcionalidades implementadas

### 1. Pantalla de inicio

La aplicación cuenta con una pantalla principal que presenta el propósito del proyecto y facilita el acceso a sus diferentes secciones.

**Características:**
- Presentación de bienvenida.
- Imagen representativa de la cultura Caral.
- Accesos directos a Explorar, Mis favoritas y Línea de tiempo.
- Navegación mediante una barra inferior de cuatro pestañas.
- Diseño visual con colores crema, beige, marrón y terracota.

### 2. Exploración de culturas

Permite consultar un catálogo de seis culturas peruanas:

- Caral
- Chavín
- Paracas
- Nazca
- Moche
- Inca

Cada cultura se presenta mediante una tarjeta personalizada que contiene su imagen, nombre y región geográfica.

**Características:**
- Listado mediante `UITableView`.
- Celdas personalizadas y reutilizables.
- Imágenes almacenadas localmente en `Assets.xcassets`.
- Selección de tarjetas para acceder a información detallada.
- Navegación mediante `UINavigationController`.

### 3. Buscador de culturas

Se implementó un buscador interactivo utilizando `UISearchController`.

**Características:**
- Búsqueda por nombre en tiempo real.
- Reconocimiento de búsquedas con o sin tildes.
- Búsqueda sin distinción entre mayúsculas y minúsculas.
- Mensaje informativo cuando no existen coincidencias.
- Restauración automática del catálogo al limpiar la búsqueda.
- Apertura del detalle correspondiente al resultado seleccionado.

### 4. Mis culturas favoritas

Permite guardar las culturas de mayor interés para consultarlas posteriormente.

**Características:**
- Botón de corazón para agregar o quitar favoritas.
- Actualización visual inmediata del estado del corazón.
- Almacenamiento local mediante `UserDefaults`.
- Persistencia de favoritas al cerrar y volver a abrir la aplicación.
- Prevención de registros duplicados.
- Listado independiente de culturas favoritas.
- Mensaje informativo cuando no existen favoritas.
- Acceso directo a Explorar desde el estado vacío.

La funcionalidad utiliza identificadores estables para reconocer cada cultura.

### 5. Línea de tiempo histórica

Presenta las seis culturas organizadas cronológicamente según el inicio aproximado de sus períodos históricos.

**Características:**
- Ordenamiento cronológico.
- Presentación de fechas aproximadas en a. C. y d. C.
- Tarjetas con imagen, nombre, período y descripción.
- Línea vertical con marcadores históricos.
- Información sobre coexistencia de culturas.
- Notas sobre incertidumbre de los períodos.
- Referencias históricas.
- Navegación al detalle de cada cultura.

La línea de tiempo es informativa y no representa los intervalos mediante una escala proporcional.

### 6. Información detallada de cada cultura

Cada cultura dispone de una pantalla informativa que reúne su contenido histórico.

**Información presentada:**
- Imagen representativa.
- Nombre de la cultura.
- Región geográfica.
- Período histórico aproximado.
- Descripción general.
- Tres datos curiosos.
- Legado cultural.
- Notas históricas.
- Referencias y fuentes consultadas.

**Características adicionales:**
- Tarjetas informativas con diseño personalizado.
- Contenido desplazable mediante `UIScrollView`.
- Enlaces a fuentes históricas que se abren en Safari.
- Botón para agregar o quitar favoritas.
- Acceso desde Explorar, Favoritos y Línea de tiempo.
- Diseño adaptable mediante Auto Layout.

## Estructura principal del proyecto

```text
SEMANA7/
└── CulturasPeruanas/
    ├── CulturasPeruanas.xcodeproj
    └── CulturasPeruanas/
        ├── AppDelegate.swift
        ├── SceneDelegate.swift
        ├── Cultura.swift
        ├── CatalogoCulturas.swift
        ├── PeriodoHistorico.swift
        ├── ContenidoCultural.swift
        ├── FavoritosStore.swift
        ├── EstiloUI.swift
        ├── PrincipalTabBarController.swift
        ├── InicioViewController.swift
        ├── ViewController.swift
        ├── CulturaTableViewCell.swift
        ├── DetalleViewController.swift
        ├── TarjetaInformativaView.swift
        ├── FavoritasViewController.swift
        ├── LineaTiempoViewController.swift
        ├── LineaTiempoTableViewCell.swift
        ├── Assets.xcassets/
        └── Base.lproj/
            ├── Main.storyboard
            └── LaunchScreen.storyboard
```

## Organización del desarrollo

El proyecto se desarrolló progresivamente en cinco etapas:

| Etapa | Implementación |
|---|---|
| 1 | Navegación principal, pantalla de inicio y cuatro pestañas |
| 2 | Mejora visual del catálogo, buscador y detalle |
| 3 | Sistema de favoritas con persistencia local |
| 4 | Línea de tiempo histórica |
| 5 | Ampliación del detalle con datos curiosos, legado y fuentes |

Se mantuvieron las funcionalidades originales durante la incorporación de nuevas características.

## Ejecución del proyecto

1. Clonar o descargar el repositorio.
2. Abrir `SEMANA7/CulturasPeruanas/CulturasPeruanas.xcodeproj` en Xcode.
3. Seleccionar el esquema `CulturasPeruanas`.
4. Elegir un simulador de iPhone compatible con la configuración del proyecto.
5. Compilar y ejecutar mediante `Command + R`.

La información cultural y las imágenes están almacenadas localmente. No se necesita conexión a internet para consultar el contenido principal.

**Nota:** Los enlaces a fuentes históricas sí requieren conexión a internet.

## Consideraciones

- Los períodos históricos son aproximados y pueden variar según las fuentes consultadas.
- Algunas culturas coexistieron durante determinados períodos.
- La aplicación utiliza almacenamiento local y no requiere registro de usuarios.
- No se implementaron mapas interactivos, servicios externos ni bases de datos remotas.
- Las imágenes se administran mediante el catálogo de recursos de Xcode.

## Objetivo académico

Aplicar los conocimientos adquiridos en el desarrollo de aplicaciones móviles para iOS, incluyendo:

- Diseño de interfaces con UIKit y Storyboard.
- Manejo de controladores de vista.
- Navegación entre pantallas.
- Implementación de tablas y celdas personalizadas.
- Uso de estructuras y modelos de datos en Swift.
- Búsqueda y filtrado de información.
- Persistencia local mediante UserDefaults.
- Uso de Auto Layout.
- Reutilización de componentes visuales.

## Autoría

**Autora:** Adriana Chinchayhuara  
**Proyecto:** Culturas Peruanas  
**Curso:** Programación en Móviles Avanzado  
**Ciclo:** V  
**Sección:** B

Desarrollado con fines académicos y educativos.