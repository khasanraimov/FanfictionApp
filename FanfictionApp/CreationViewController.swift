//
//  CreationViewController.swift
//  FanfictionApp
//
//  Created by khasan on 18.05.2023.
//

import UIKit
import Firebase

class Story {
    var title: String
    var content: String
//    var author: String
//      var likes: Int
//    var comments: String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
//        self.author = author
//          self.likes = likes
//        self.comments = comments
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
    }
}

class CreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let title = titleTextField.text!
        let content = contentTextView.text!
        let story = Story(title: title, content: content)
        story.save()
    }
    

}

