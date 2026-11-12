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

    private var iniciandoSesion = false

    override func viewDidLoad() {
        super.viewDidLoad()
        claveTextField.isSecureTextEntry = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iniciandoSesion = false
        usuarioTextField.text = ""
        claveTextField.text = ""
    }

    @IBAction func ingresar(_ sender: UIButton) {
        guard !iniciandoSesion else { return }
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
                guard ["Vendedor", "Supervisor"].contains(usuario.rol ?? "") else {
                    mostrarAlerta("El usuario no tiene un rol habilitado.")
                    return
                }
                iniciandoSesion = true
                view.endEditing(true)
                performSegue(withIdentifier: "loginAMenuPrincipal", sender: usuario)
            } else {
                mostrarAlerta("Usuario o clave incorrectos")
            }
        } catch {
            mostrarAlerta("Error al consultar los usuarios")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "loginAMenuPrincipal",
              iniciandoSesion,
              let usuario = sender as? Usuario,
              let destino = segue.destination as? MenuPrincipalViewController else { return }
        destino.usuarioSesion = usuario
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

