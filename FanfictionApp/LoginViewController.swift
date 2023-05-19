//
//  LoginViewController.swift
//  FanfictionApp
//
//  Created by khasan on 18.05.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(withTitle: "Error", message: "Please enter your email")
            return
        }
        
        if !isValidEmail(email: email) {
            showAlert(withTitle: "Error", message: "Please enter a valid email")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(withTitle: "Error", message: "Please enter your password")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)") // You can update this to show an alert
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
            self.view.window?.rootViewController = newVC
            self.view.window?.makeKeyAndVisible()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        // You can use a regex to check if the email is valid
        // This is just a simple example
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
