//
//  UserViewController.swift
//  FanfictionApp
//
//  Created by khasan on 19.05.2023.
//

import UIKit
import Firebase

class AlertManager {
    
    static func showAlert(title: String, message: String, in viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: Any) {
        let alertController = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (_) in
            AuthManager.shared.logoutUser { error in
                if let error = error {
                    print("Error logging out: \(error.localizedDescription)")
                    AlertManager.showAlert(title: "Error", message: "Failed to log out", in: self)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.view.window?.rootViewController = newVC
                    self.view.window?.makeKeyAndVisible()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }))
        present(alertController, animated: true, completion: nil)
    }

}



