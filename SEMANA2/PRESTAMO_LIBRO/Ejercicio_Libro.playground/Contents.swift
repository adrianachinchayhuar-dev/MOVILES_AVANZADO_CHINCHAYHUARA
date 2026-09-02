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

// Validaciones de Préstamo y Devolución

func leerFechaDevolucion(fechaPrestamo: Date, tipo: TipoUsuario) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")

    let maxDias = diasMaximosPermitidos(tipo)
    let fechaLimitePermitida = Calendar.current.date(byAdding: .day, value: maxDias, to: fechaPrestamo)!

    while true {
        print("Fecha programada de devolución (dd/MM/yyyy):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces),
           let fecha = formatter.date(from: input) {

            if fecha <= fechaPrestamo {
                print("La fecha de devolución debe ser posterior al préstamo.")
                continue
            }
            
            if fecha > fechaLimitePermitida {
                print("Excede el límite de \(maxDias) días permitidos para \(tipo.rawValue). Límite máximo: \(formatter.string(from: fechaLimitePermitida))")
                continue
            }
            return fecha
        }
        print("Formato de fecha inválido.")
    }
}

func leerFechaEntregaReal(fechaPrestamo: Date) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")

    while true {
        print("Fecha de entrega real del libro (dd/MM/yyyy):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces),
           let fecha = formatter.date(from: input) {

            if fecha < fechaPrestamo {
                print("La entrega real no puede ser anterior a la fecha de préstamo.")
                continue
            }
            return fecha
        }
        print("Formato de fecha inválido.")
    }
}

func ingresarDatosCompletos() -> Prestamo {
    print("=== REGISTRO DE PRÉSTAMO - LABORATORIO 01 ===\n")
    let titulo = leerTextoNoVacio(mensaje: "Título del libro:")
    let tipo = leerTipoUsuario()
    let fechaPrestamo = leerFechaPresenteOFutura("\nFecha de préstamo (dd/MM/yyyy):")
    let fechaDevolucion = leerFechaDevolucion(fechaPrestamo: fechaPrestamo, tipo: tipo)
    let fechaEntregaReal = leerFechaEntregaReal(fechaPrestamo: fechaPrestamo)

    return Prestamo(
        tituloLibro: titulo,
        tipoUsuario: tipo,
        fechaPrestamo: fechaPrestamo,
        fechaDevolucionProgramada: fechaDevolucion,
        fechaEntregaReal: fechaEntregaReal
    )
}

// Operaciones y Cálculo de Recargos

func calcularDiasAtraso(fechaProgramada: Date, fechaEntregaReal: Date) -> Int {
    let diferencia = Calendar.current.dateComponents([.day], from: fechaProgramada, to: fechaEntregaReal)
    return max(0, diferencia.day ?? 0)
}

func tarifaBasePorDia(_ tipo: TipoUsuario) -> Double {
    switch tipo {
    case .alumno: return 1.50
    case .docente: return 2.00
    case .administrador: return 3.00
    }
}

// Incremento del cobro cuando el retraso se prolonga
func recargoMoraPorDia(diaMora: Int, tipo: TipoUsuario) -> Double {
    let base = tarifaBasePorDia(tipo)
    switch diaMora {
    case 1...3: return base            // Tarifa estándar
    case 4...6: return base * 1.5      // Recargo del 50%
    default:    return base * 2.0      // Recargo del 100% (Aumento por demora excesiva)
    }
}

struct FilaRecargo {
    let dia: Int
    let fecha: Date
    let cuotaDia: Double
    let totalAcumulado: Double
}

func generarCalendarioMora(fechaProgramada: Date, diasAtraso: Int, tipo: TipoUsuario) -> [FilaRecargo] {
    var tabla: [FilaRecargo] = []
    var acumulado = 0.0

    guard diasAtraso > 0 else { return [] }

    for dia in 1...diasAtraso {
        let fecha = Calendar.current.date(byAdding: .day, value: dia, to: fechaProgramada)!
        let cuota = recargoMoraPorDia(diaMora: dia, tipo: tipo)
        acumulado += cuota
        tabla.append(FilaRecargo(dia: dia, fecha: fecha, cuotaDia: cuota, totalAcumulado: acumulado))
    }
    return tabla
}

// Ejecución Principal

let prestamo = ingresarDatosCompletos()
let diasAtraso = calcularDiasAtraso(
    fechaProgramada: prestamo.fechaDevolucionProgramada,
    fechaEntregaReal: prestamo.fechaEntregaReal
)

let tablaMora = generarCalendarioMora(
    fechaProgramada: prestamo.fechaDevolucionProgramada,
    diasAtraso: diasAtraso,
    tipo: prestamo.tipoUsuario
)

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"

print("\n========================================")
print("       RESUMEN DE PRÉSTAMO Y MORA       ")
print("========================================")
print("Libro:                \(prestamo.tituloLibro)")
print("Usuario:              \(prestamo.tipoUsuario.rawValue)")
print("Fecha Préstamo:       \(formatter.string(from: prestamo.fechaPrestamo))")
print("Fecha Dev. Programada:\(formatter.string(from: prestamo.fechaDevolucionProgramada))")
print("Fecha Entrega Real:   \(formatter.string(from: prestamo.fechaEntregaReal))")
print("Días de Atraso:       \(diasAtraso)")
print("Situación Usuario:    \(diasAtraso > 10 ? "SUSPENDIDO" : "HABILITADO")")

if diasAtraso > 0 {
    print("\n--- DESGLOSE DE RECARGOS POR DELAY ---")
    print("Día\tFecha\t\tMora Día\tAcumulado")
    for fila in tablaMora {
        print("\(fila.dia)\t\(formatter.string(from: fila.fecha))\tS/ \(String(format: "%.2f", fila.cuotaDia))\t\tS/ \(String(format: "%.2f", fila.totalAcumulado))")
    }
    let totalPagar = tablaMora.last?.totalAcumulado ?? 0.0
    print("\nTotal recargo a pagar: S/ \(String(format: "%.2f", totalPagar))")
} else {
    print("\n Libro entregado a tiempo o antes de la fecha límite. Sin recargos.")
}
