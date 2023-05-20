//
//  CreationViewController.swift
//  FanfictionApp
//
//  Created by khasan on 18.05.2023.
//
//
//import UIKit
//import Firebase
//
//class Story {
//    var title: String
//    var content: String
////    var author: String
////      var likes: Int
////    var comments: String
//
//    init(title: String, content: String) {
//        self.title = title
//        self.content = content
////        self.author = author
////          self.likes = likes
////        self.comments = comments
//    }
//
//    func save() {
//        // Ссылка на базу данных Firebase
//        let databaseRef = Database.database().reference()
//
//        // Создаем уникальный идентификатор для истории
//        guard let storyId = databaseRef.child("stories").childByAutoId().key else { return }
//
//        // Сохраняем историю в Firebase
//        let storyRef = databaseRef.child("stories").child(storyId)
//        storyRef.child("title").setValue(title)
//        storyRef.child("content").setValue(content)
//    }
//}
//
//class CreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    @IBOutlet weak var titleTextField: UITextField!
//    @IBOutlet weak var contentTextView: UITextView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    @IBAction func saveButtonTapped(_ sender: Any) {
//        let title = titleTextField.text!
//        let content = contentTextView.text!
//        let story = Story(title: title, content: content)
//        story.save()
//    }
//
//
//}






//
//import UIKit
//import Firebase
//
//class Story {
//    var title: String
//    var content: String
//    var image: Data?
//
//    init(title: String, content: String, image: Data? = nil) {
//        self.title = title
//        self.content = content
//        self.image = image
//    }
//
//    func save() {
//        // Ссылка на базу данных Firebase
//        let databaseRef = Database.database().reference()
//
//        // Создаем уникальный идентификатор для истории
//        guard let storyId = databaseRef.child("stories").childByAutoId().key else { return }
//
//        // Сохраняем историю в Firebase
//        let storyRef = databaseRef.child("stories").child(storyId)
//        storyRef.child("title").setValue(title)
//        storyRef.child("content").setValue(content)
//
//        if let imageData = image {
//            let storageRef = Storage.storage().reference().child("images/\(storyId).jpg")
//
//            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
//                if let error = error {
//                    print("Error uploading image: \(error.localizedDescription)")
//                } else {
//                    storageRef.downloadURL { (url, error) in
//                        if let error = error {
//                            print("Error getting image URL: \(error.localizedDescription)")
//                        } else {
//                            storyRef.child("imageUrl").setValue(url?.absoluteString)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//class CreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    @IBOutlet weak var titleTextField: UITextField!
//    @IBOutlet weak var contentTextView: UITextView!
//    @IBOutlet weak var imageView: UIImageView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    @IBAction func saveButtonTapped(_ sender: Any) {
//        let title = titleTextField.text!
//        let content = contentTextView.text!
//        let image = imageView.image?.jpegData(compressionQuality: 0.8)
//        let story = Story(title: title, content: content, image: image)
//        story.save()
//    }
//
//    @IBAction func addImageButtonTapped(_ sender: Any) {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//
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
//            imageView.image = image
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//}



import UIKit
import Firebase

class Story {
    var title: String
    var content: String
    var image: Data?
    
    init(title: String, content: String, image: Data? = nil) {
        self.title = title
        self.content = content
        self.image = image
    }
    
    func save() {
        // Ссылка на базу данных Firebase
        let databaseRef = Database.database().reference()
        
        // Создаем уникальный идентификатор для истории
        guard let storyId = databaseRef.child("stories").childByAutoId().key else { return }
        
        // Сохраняем историю в Firebase
        let storyRef = databaseRef.child("stories").child(storyId)
        storyRef.child("title").setValue(title)
        storyRef.child("content").setValue(content)
        
        if let imageData = image {
            let storageRef = Storage.storage().reference().child("images/\(storyId).jpg")
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error getting image URL: \(error.localizedDescription)")
                        } else {
                            storyRef.child("imageUrl").setValue(url?.absoluteString)
                        }
                    }
                }
            }
        }
    }
}

class CreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        let title = titleTextField.text!
        let content = contentTextView.text!
        
        // Проверяем, что imageView не является nil
        guard let image = imageView.image, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let story = Story(title: title, content: content, image: imageData)
        story.save()
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
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
