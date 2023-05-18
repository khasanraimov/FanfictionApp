//
//  RegViewController.swift
//  FanfictionApp
//
//  Created by khasan on 18.05.2023.
//

import UIKit
import Firebase

class RegViewController: UIViewController {

    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupButton(_ sender: Any) {
        
        guard let nickname = nicknameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else {
            return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print("Error")
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let newVC = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
//                self.present(newVC, animated: false, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newVC = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
                self.present(newVC, animated: false, completion: nil)

            }
        }
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
