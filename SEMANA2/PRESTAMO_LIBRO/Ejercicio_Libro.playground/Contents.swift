import Foundation

// Modelos de Datos
enum TipoUsuario: String {
    case alumno = "Alumno"
    case docente = "Docente"
    case administrador = "Administrador"
}

struct Prestamo {
    let tituloLibro: String
    let tipoUsuario: TipoUsuario
    let fechaPrestamo: Date
    let fechaDevolucionProgramada: Date
    let fechaEntregaReal: Date
}

// Días máximos permitidos por norma de la biblioteca
func diasMaximosPermitidos(_ tipo: TipoUsuario) -> Int {
    switch tipo {
    case .alumno: return 7
    case .docente: return 15
    case .administrador: return 10
    }
}

// Validaciones de Entrada

func leerTextoNoVacio(mensaje: String) -> String {
    while true {
        print(mensaje, terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces), !input.isEmpty {
            return input
        }
        print("El campo no puede estar vacío.")
    }
}

func leerTipoUsuario() -> TipoUsuario {
    print("\n--- Tipo de Usuario ---")
    print("1. Alumno (Máx. 7 días)")
    print("2. Docente (Máx. 15 días)")
    print("3. Administrador (Máx. 10 días)")
    
    while true {
        print("Seleccione (1-3):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces) {
            switch input {
            case "1": return .alumno
            case "2": return .docente
            case "3": return .administrador
            default: print("Opción inválida.")
            }
        }
    }
}

// Obtener medianoche de hoy para comparar solo fechas sin hora
func obtenerInicioDeHoy() -> Date {
    return Calendar.current.startOfDay(for: Date())
}

// Lee fecha y asegura que no sea una fecha pasada
func leerFechaPresenteOFutura(_ mensaje: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")
    let hoy = obtenerInicioDeHoy()

    while true {
        print(mensaje, terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces),
           let fecha = formatter.date(from: input) {
            
            let fechaInicio = Calendar.current.startOfDay(for: fecha)
            if fechaInicio < hoy {
                print("No se permiten fechas pasadas. Ingrese hoy o una fecha futura.")
                continue
            }
            return fecha
        }
        print("Formato incorrecto. Use dd/MM/yyyy (Ejemplo: 25/10/2026)")
    }
}
