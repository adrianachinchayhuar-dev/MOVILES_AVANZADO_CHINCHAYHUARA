//
//  RegistroViewController.swift
//  Ventas
//
//  Created by Adriana Chinchayhuara on 12/11/26.
//


import UIKit
import CoreData

class RegistroViewController: UIViewController {

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var claveTextField: UITextField!
    @IBOutlet weak var confirmarTextField: UITextField!
    @IBOutlet weak var rolSegmented: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        claveTextField.isSecureTextEntry = true
        confirmarTextField.isSecureTextEntry = true
    }

    @IBAction func registrarme(_ sender: UIButton) {

        let nombre = nombreTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let usuario = usuarioTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let clave = claveTextField.text ?? ""
        let confirmar = confirmarTextField.text ?? ""

        guard !nombre.isEmpty, !usuario.isEmpty else {
            mostrarAlerta("Completa todos los campos")
            return
        }

        guard clave.count >= 6 else {
            mostrarAlerta("La contraseña debe tener mínimo 6 caracteres")
            return
        }

        guard clave == confirmar else {
            mostrarAlerta("Las contraseñas no coinciden")
            return
        }

        let contexto = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext

        let solicitud: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        solicitud.predicate = NSPredicate(
            format: "usuario =[c] %@", usuario
        )

        do {
            if try contexto.count(for: solicitud) > 0 {
                mostrarAlerta("El nombre de usuario ya existe")
                return
            }

            let nuevoUsuario = Usuario(context: contexto)
            nuevoUsuario.nombre = nombre
            nuevoUsuario.usuario = usuario
            nuevoUsuario.clave = clave
            nuevoUsuario.rol = rolSegmented.selectedSegmentIndex == 0
                ? "Vendedor" : "Supervisor"

            try contexto.save()

            let alerta = UIAlertController(
                title: "Registro exitoso",
                message: "Tu cuenta fue creada correctamente",
                preferredStyle: .alert
            )

            alerta.addAction(UIAlertAction(
                title: "Aceptar",
                style: .default,
                handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            ))

            present(alerta, animated: true)

        } catch {
            contexto.rollback()
            mostrarAlerta("Error al registrar usuario")
        }
    }

    func mostrarAlerta(_ mensaje: String) {
        let alerta = UIAlertController(
            title: "Registro",
            message: mensaje,
            preferredStyle: .alert
        )

        alerta.addAction(UIAlertAction(
            title: "Aceptar",
            style: .default
        ))

        present(alerta, animated: true)
    }
}
