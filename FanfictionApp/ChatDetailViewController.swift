import UIKit
import Firebase

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textMessage: UILabel!
    @IBOutlet weak var senderName: UILabel!
    
    func configure(with message: Message) {
        textMessage.text = message.text
        senderName.text = message.senderName
        
        // Если нужно, добавьте логику для отображения времени отправки сообщения
    }
}

class ChatDetailViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTitleLabel: UILabel!
    
    var receiverUser: User?
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard receiverUser != nil else {
            let alertController = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные чата", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion:nil)
            return
        }
        
        setupView()
        loadMessages()
    }
    
    func setupView() {
        chatTitleLabel.text = receiverUser?.fullName
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadMessages() {
        let ref = Database.database().reference().child("messages")
        
        if let receiverUserId = receiverUser?.userId {
            ref.child(Auth.auth().currentUser!.uid).child(receiverUserId).observe(.childAdded) { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    guard let message = Message(data: data) else { return }
                    self.messages.append(message)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
            fatalError("The dequeued cell is not an instance of MessageTableViewCell.")
        }
        
        let message = messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
    
    // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //     let message = messages[indexPath.row]
    //     let messageTextHeight = message.text.height(withConstrainedWidth: tableView.frame.width - 78, font: UIFont.systemFont(ofSize: 17))
    //     return messageTextHeight + 45
    // }
    
    @IBAction func sendMessageTapped(_ sender: Any) {
        if let message = messageTextField.text, !message.isEmpty {
            let ref = Database.database().reference().child("messages")
            
            if let receiverUserId = receiverUser?.userId {
                let senderRef = ref.child(Auth.auth().currentUser!.uid).child(receiverUserId).childByAutoId()
                let senderMessage = [
                    "text": message,
                    "senderId": Auth.auth().currentUser!.uid,
                    "senderName": Auth.auth().currentUser!.displayName ?? ""
                ]
                senderRef.setValue(senderMessage)
                
                let receiverRef = ref.child(receiverUserId).child(Auth.auth().currentUser!.uid).childByAutoId()
                let receiverMessage = [
                    "text": message,
                    "senderId": Auth.auth().currentUser!.uid,
                    "senderName": Auth.auth().currentUser!.displayName ?? ""
                ]
                receiverRef.setValue(receiverMessage)
                
                messageTextField.text = ""
            }
        }
    }
}

extension ChatDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}

struct Message {
    let text: String
    let senderName: String
    
    init?(data: [String: Any]) {
        guard let text = data["text"] as? String,
              let senderName = data["senderName"] as? String else {
                return nil
        }
        
        self.text = text
        self.senderName = senderName
    }
}
