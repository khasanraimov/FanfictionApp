//
//  RegViewController.swift
//  FanfictionApp
//
//  Created by khasan on 18.05.2023.
//

import UIKit
import Firebase

class AuthManager {
    static let shared = AuthManager()

    func registerUser(nickname: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(error)
            } else {
                // Saving user's data in UserDefaults
                UserDefaults.standard.set(nickname, forKey: "nickname")
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                completion(nil)
            }
        }
    }

    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
    
    func logoutUser(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "nickname")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}

import UIKit
import Firebase

class RegViewController: UIViewController {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user is already logged in, and if yes, present TabbarController
        if AuthManager.shared.isUserLoggedIn() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
            self.view.window?.rootViewController = newVC
            self.view.window?.makeKeyAndVisible()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
            showAlert(withTitle: "Error", message: "Please enter your nickname")
            return
        }
        
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
        
        if password.count < 8 {
            showAlert(withTitle: "Error", message: "Password must contain at least 8 characters")
            return
        }
        
        AuthManager.shared.registerUser(nickname: nickname, email: email, password: password) { error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)") // You can update this to show an alert with the error message
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
