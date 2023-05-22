//
//  UserViewController.swift
//  FanfictionApp
//
//  Created by khasan on 19.05.2023.
////
//import UIKit
//import Firebase
//
//class AlertManager {
//
//    static func showAlert(title: String, message: String, in viewController: UIViewController) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        viewController.present(alertController, animated: true, completion: nil)
//    }
//
//
//}
//
//
//class UserViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//
//
//    @IBOutlet weak var profileImageView: UIImageView!
//
//
//    @IBOutlet weak var fullNameTextField: UITextField!
//
//    @IBOutlet weak var aboutMeTextView: UITextField!
//
//
//    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Load user's data
//        loadUserData()
//
//    }
//
//    @IBAction func saveButton(_ sender: Any) {
//        guard let fullName = fullNameTextField.text, !fullName.isEmpty else { showAlertNot(withTitle: "Error", message: "Please enter your full name")
//            return
//
//        }
//        guard let aboutMe = aboutMeTextView.text, !aboutMe.isEmpty else { showAlertNot(withTitle: "Error", message: "Please enter information about yourself")
//            return }
//        let gender = genderSegmentedControl.selectedSegmentIndex == 0 ? "Male" : "Female"
//        let data: [String: Any] = ["fullName": fullName, "aboutMe": aboutMe, "gender": gender]
//        let db = Firestore.firestore()
//        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
//        docRef.setData(data, merge: true) {
//            error in
//            if error != nil {
//                print("Error updating user data: (error.localizedDescription)")
//                // You can update this to show an alert with the error message
//                return }
//            self.showAlertNot(withTitle: "Success", message: "User data has been updated")
//
//        }
//
//    }
//
//    @IBAction func addImageButtonTapped(_ sender: Any) {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        let actionSheet = UIAlertController(title: "Pick a picture", message: nil, preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        actionSheet.addAction(UIAlertAction(title: "Take Picture", style: .default, handler: { (action: UIAlertAction) in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                imagePickerController.sourceType = .camera
//                self.present(imagePickerController, animated: true, completion: nil)
//            }
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (action: UIAlertAction) in
//            imagePickerController.sourceType = .photoLibrary
//            self.present(imagePickerController, animated: true, completion: nil)
//        }))
//
//        present(actionSheet, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            profileImageView.image = image
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func loadUserData() {
//        let db = Firestore.firestore()
//        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
//        docRef.getDocument {
//            snapshot, error in
//            if error != nil {
//                print("Error loading user data: (error.localizedDescription)")
//                // You can update this to show an alert with the error message
//                return
//
//            }
//            guard let data = snapshot?.data() else { return }
//            self.fullNameTextField.text = data["fullName"] as? String
//            self.aboutMeTextView.text = data["aboutMe"] as? String
//            let gender = data["gender"] as? String
//            if gender == "Male" { self.genderSegmentedControl.selectedSegmentIndex = 0 }
//            else if gender == "Female" {
//                self.genderSegmentedControl.selectedSegmentIndex = 1
//
//            }
//
//        }
//
//    }
//    func showAlertNot(withTitle title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alertController, animated: true, completion: nil)
//
//    }
//
//    @IBAction func logOut(_ sender: Any) {
//        let alertController = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (_) in
//            AuthManager.shared.logoutUser { error in
//                if let error = error {
//                    print("Error logging out: \(error.localizedDescription)")
//                    AlertManager.showAlert(title: "Error", message: "Failed to log out", in: self)
//                } else {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let newVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                    self.view.window?.rootViewController = newVC
//                    self.view.window?.makeKeyAndVisible()
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
//        }))
//        present(alertController, animated: true, completion: nil)
//    }
//
//}
//


import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class AlertManager {
    static func showAlert(title: String, message: String, in viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}

class UserViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let storageRef = Storage.storage().reference()

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var aboutMeTextView: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    private let dbRef = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load user's data
        loadUserData()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            AlertManager.showAlert(title: "Error", message: "Please enter your full name", in: self)
            return
        }

        guard let aboutMe = aboutMeTextView.text, !aboutMe.isEmpty else {
            AlertManager.showAlert(title: "Error", message: "Please enter information about yourself", in: self)
            return
        }
        
        let gender = genderSegmentedControl.selectedSegmentIndex == 0 ? "Male" : "Female"

        uploadProfileImage(profileImageView.image ?? UIImage()) { url in
            if let profileImageUrl = url?.absoluteString {
                let data: [String: Any] = ["fullName": fullName, "aboutMe": aboutMe, "gender": gender, "profileImageUrl": profileImageUrl]
                self.dbRef.child("users").child(Auth.auth().currentUser!.uid).setValue(data) { error, _ in
                    if let error = error {
                        print("Error updating user data: \(error.localizedDescription)")
                        AlertManager.showAlert(title: "Error", message: "Failed to save user data", in: self)
                    } else {
                        AlertManager.showAlert(title: "Success", message: "User data has been updated", in: self)
                    }
                }
            }
        }
    }
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")

        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        storageRef.putData(imageData, metadata: metaData) { meta, error in
            if error == nil, meta != nil {
                storageRef.downloadURL { url, error in
                    completion(url)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Pick a picture", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        actionSheet.addAction(UIAlertAction(title: "Take Picture", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))

        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func loadProfileImage(_ url: String) {
        let imageURL = URL(string: url)!
        let session = URLSession.shared
        let task = session.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    func loadUserData() {
        dbRef.child("users").child(Auth.auth().currentUser!.uid).observe(.value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }

            self.fullNameTextField.text = data["fullName"] as? String
            self.aboutMeTextView.text = data["aboutMe"] as? String
            let gender = data["gender"] as? String
            if gender == "Male" {
                self.genderSegmentedControl.selectedSegmentIndex = 0
            } else if gender == "Female" {
                self.genderSegmentedControl.selectedSegmentIndex = 1
            }

            if let profileImageUrl = data["profileImageUrl"] as? String {
                self.loadProfileImage(profileImageUrl)
            }
        }
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
