//
//  ViewController+Relacion.swift.swift
//  apple_lab11_01_UIKit_CoreData
//
//  Created by Adriana Chinchayhuara on 5/11/26.
//



import UIKit
import CoreData

extension ViewController {

    // MARK: - PASO 11: FETCH REQUESTS

    // Buscar contactos por nombre
    // Ignora mayúsculas, minúsculas y tildes
    func buscarContactos(texto: String) -> [Contacto] {

        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()

        request.predicate = NSPredicate(
            format: "nombre CONTAINS[cd] %@",
            texto
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "nombre",
                ascending: true
            )
        ]

        return (try? conexion().fetch(request)) ?? []
    }

    // MARK: - PASO 12: RELACIÓN GRUPO Y CONTACTO

    // Crear un grupo y asignarlo al primer contacto
    // IMPORTANTE: ejecutar solo una vez
    func probarRelacion() {

        let contexto = conexion()

        let grupo = NSEntityDescription.insertNewObject(
            forEntityName: "Grupo",
            into: contexto
        ) as! Grupo

        grupo.nombre = "Amigos"

        if let primero = contactos.first {
            primero.grupo = grupo
        }

        do {
            try contexto.save()

            print(
                "El grupo \(grupo.nombre ?? "") tiene \(grupo.contactos?.count ?? 0) contacto(s)"
            )

        } catch {
            print("Error al guardar la relación: \(error)")
        }
    }

    // Buscar contactos que pertenecen a un grupo
    func contactosDelGrupo(_ nombreGrupo: String) -> [Contacto] {

        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()

        request.predicate = NSPredicate(
            format: "grupo.nombre == %@",
            nombreGrupo
        )

        return (try? conexion().fetch(request)) ?? []
    }
}

