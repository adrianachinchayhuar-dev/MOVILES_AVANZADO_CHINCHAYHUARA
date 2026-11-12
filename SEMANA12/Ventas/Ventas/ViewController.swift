//
//  ViewController.swift
//  Ventas
//
//  Created by Adriana Chinchayhuara on 12/11/26.
//


import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var claveTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        claveTextField.isSecureTextEntry = true
    }

    @IBAction func ingresar(_ sender: UIButton) {
        let nombreUsuario = usuarioTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let clave = claveTextField.text ?? ""

        guard !nombreUsuario.isEmpty, !clave.isEmpty else {
            mostrarAlerta("Completa todos los campos")
            return
        }

        let contexto = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext

        let solicitud: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        solicitud.fetchLimit = 1
        solicitud.predicate = NSPredicate(
            format: "usuario =[c] %@ AND clave == %@",
            nombreUsuario, clave
        )

        do {
            if let usuario = try contexto.fetch(solicitud).first {
                mostrarAlerta("Bienvenido, \(usuario.nombre ?? "")")
                // Después abriremos las pestañas según el rol.
            } else {
                mostrarAlerta("Usuario o clave incorrectos")
            }
        } catch {
            mostrarAlerta("Error al consultar los usuarios")
        }
    }

    func mostrarAlerta(_ mensaje: String) {
        let alerta = UIAlertController(
            title: "Ventas",
            message: mensaje,
            preferredStyle: .alert
        )
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}

