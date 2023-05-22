////import UIKit
////import Firebase
////
////class MessageTableViewCell: UITableViewCell {
////
////    @IBOutlet weak var textMessage: UILabel!
////    @IBOutlet weak var senderName: UILabel!
////
////    func configure(with message: Message) {
////        textMessage.text = message.text
////        senderName.text = message.senderName
////
////        // Если нужно, добавьте логику для отображения времени отправки сообщения
////    }
////}
////
////class ChatDetailViewController: UIViewController, UITableViewDelegate {
////
////    @IBOutlet weak var tableView: UITableView!
////    @IBOutlet weak var messageTextField: UITextField!
////    @IBOutlet weak var chatTitleLabel: UILabel!
////
////    var receiverUser: User?
////    var messages: [Message] = []
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        guard receiverUser != nil else {
////            let alertController = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные чата", preferredStyle: .alert)
////            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
////                self.navigationController?.popViewController(animated: true)
////            }
////            alertController.addAction(OKAction)
////            present(alertController, animated: true, completion:nil)
////            return
////        }
////
////        setupView()
////        loadMessages()
////    }
////
////    func setupView() {
////        chatTitleLabel.text = receiverUser?.fullName
////        tableView.dataSource = self
////        tableView.delegate = self
////    }
////
////    func loadMessages() {
////        let ref = Database.database().reference().child("messages")
////
////        if let receiverUserId = receiverUser?.userId {
////            ref.child(Auth.auth().currentUser!.uid).child(receiverUserId).observe(.childAdded) { (snapshot) in
////                if let data = snapshot.value as? [String: Any] {
////                    guard let message = Message(data: data) else { return }
////                    self.messages.append(message)
////                    self.tableView.reloadData()
////                }
////            }
////        }
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cellIdentifier = "MessageTableViewCell"
////
////        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
////            fatalError("The dequeued cell is not an instance of MessageTableViewCell.")
////        }
////
////        let message = messages[indexPath.row]
////        cell.configure(with: message)
////        return cell
////    }
////
////    // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////    //     let message = messages[indexPath.row]
////    //     let messageTextHeight = message.text.height(withConstrainedWidth: tableView.frame.width - 78, font: UIFont.systemFont(ofSize: 17))
////    //     return messageTextHeight + 45
////    // }
////
////    @IBAction func sendMessageTapped(_ sender: Any) {
////        if let message = messageTextField.text, !message.isEmpty {
////            let ref = Database.database().reference().child("messages")
////
////            if let receiverUserId = receiverUser?.userId {
////                let senderRef = ref.child(Auth.auth().currentUser!.uid).child(receiverUserId).childByAutoId()
////                let senderMessage = [
////                    "text": message,
////                    "senderId": Auth.auth().currentUser!.uid,
////                    "senderName": Auth.auth().currentUser!.displayName ?? ""
////                ]
////                senderRef.setValue(senderMessage)
////
////                let receiverRef = ref.child(receiverUserId).child(Auth.auth().currentUser!.uid).childByAutoId()
////                let receiverMessage = [
////                    "text": message,
////                    "senderId": Auth.auth().currentUser!.uid,
////                    "senderName": Auth.auth().currentUser!.displayName ?? ""
////                ]
////                receiverRef.setValue(receiverMessage)
////
////                messageTextField.text = ""
////            }
////        }
////    }
////}
////
////extension ChatDetailViewController: UITableViewDataSource {
////
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return messages.count
////    }
////}
////
////struct Message {
////    let text: String
////    let senderName: String
////
////    init?(data: [String: Any]) {
////        guard let text = data["text"] as? String,
////              let senderName = data["senderName"] as? String else {
////                return nil
////        }
////
////        self.text = text
////        self.senderName = senderName
////    }
////}
//
////
////import UIKit
////import Firebase
////import MessageKit
////import InputBarAccessoryView
////
////class MessageTableViewCell: UITableViewCell {
////
////    @IBOutlet weak var textMessage: UILabel!
////    @IBOutlet weak var senderName: UILabel!
////
////    func configure(with message: Message) {
////        textMessage.text = message.text
////        senderName.text = message.senderName
////
////        // Если нужно, добавьте логику для отображения времени отправки сообщения
////    }
////}
////
////class ChatDetailViewController: UIViewController, UITableViewDelegate {
////
////    @IBOutlet weak var tableView: UITableView!
////    @IBOutlet weak var messageTextField: UITextField!
////    @IBOutlet weak var chatTitleLabel: UILabel!
////
////    var currentUser: User?
//////    var chat: Chat?
////
////    var receiverUser: User?
////    var messages: [Message] = []
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        guard receiverUser != nil else {
////            let alertController = UIAlertController(title: "Error", message: "Failed to load chat data", preferredStyle: .alert)
////            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
////                self.navigationController?.popViewController(animated: true)
////            }
////            alertController.addAction(OKAction)
////            present(alertController, animated: true, completion:nil)
////            return
////        }
////
////        setupView()
////        loadMessages()
////    }
////
////    func setupView() {
////        chatTitleLabel.text = receiverUser?.fullName
////        tableView.dataSource = self
////        tableView.delegate = self
////    }
////
////    func loadMessages() {
////        let ref = Database.database().reference().child("messages")
////
////        if let receiverUserId = receiverUser?.userId {
////            ref.child(Auth.auth().currentUser!.uid).child(receiverUserId).observe(.childAdded) { (snapshot) in
////                if let data = snapshot.value as? [String: Any] {
////                    guard let message = Message(data: data) else { return }
////                    self.messages.append(message)
////                    self.tableView.reloadData()
////                }
////            }
////        }
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cellIdentifier = "MessageTableViewCell"
////
////        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
////            fatalError("The dequeued cell is not an instance of MessageTableViewCell.")
////        }
////
////        let message = messages[indexPath.row]
////        cell.configure(with: message)
////        return cell
////    }
////
////    // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////    //     let message = messages[indexPath.row]
////    //     let messageTextHeight = message.text.height(withConstrainedWidth: tableView.frame.width - 78, font: UIFont.systemFont(ofSize: 17))
////    //     return messageTextHeight + 45
////    // }
////
////    @IBAction func sendMessageTapped(_ sender: Any) {
////        if let message = messageTextField.text, !message.isEmpty {
////            let ref = Database.database().reference().child("messages")
////
////            if let receiverUserId = receiverUser?.userId {
////                let senderRef = ref.child(Auth.auth().currentUser!.uid).child(receiverUserId).childByAutoId()
////                let senderMessage = [
////                    "text": message,
////                    "senderId": Auth.auth().currentUser!.uid,
////                    "senderName": Auth.auth().currentUser!.displayName ?? ""
////                ]
////                senderRef.setValue(senderMessage)
////
////                let receiverRef = ref.child(receiverUserId).child(Auth.auth().currentUser!.uid).childByAutoId()
////                let receiverMessage = [
////                    "text": message,
////                    "senderId": Auth.auth().currentUser!.uid,
////                    "senderName": Auth.auth().currentUser!.displayName ?? ""
////                ]
////                receiverRef.setValue(receiverMessage)
////
////                messageTextField.text = ""
////            }
////        }
////    }
////}
////
////extension ChatDetailViewController: UITableViewDataSource {
////
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return messages.count
////    }
////}
////
////struct Message {
////    let text: String
////    let senderName: String
////
////    init?(data: [String: Any]) {
////        guard let text = data["text"] as? String,
////              let senderName = data["senderName"] as? String else {
////            return nil
////        }
////
////        self.text = text
////        self.senderName = senderName
////    }
////}
//
////
////import UIKit
////import MessageKit
////import InputBarAccessoryView
////
////
////struct Sender: SenderType{
////    var senderId: String
////    var displayName: String
////
////}
////struct Message: MessageType {
////    var sender: SenderType
////    var messageId: String
////    var sentDate: Date
////    var kind: MessageKind
////}
////
////class ChatDetailViewController: MessagesViewController {
////
////    @IBOutlet weak var chatTitleLabel: UILabel!
////
////    var chatID: String?
////    var otherId: String?
////    let service = Service.shared
////
////    let selfSender = Sender(senderId: "1", displayName: "" )
////    let otherSender = Sender(senderId: "2", displayName: "")
////
////    var messages = [Message]()
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        messagesCollectionView.messagesDataSource = self
////        messagesCollectionView.messagesLayoutDelegate = self
////        messagesCollectionView.messagesDisplayDelegate = self
////        messageInputBar.delegate = self
////        showMessageTimestampOnSwipeLeft = true
////
////        if otherId == nil {
////            // handle case when otherId is nil
////        } else {
////            service.getConvoId(otherId: otherId!) { [weak self] chatId in
////                self?.chatID = chatId
////                self?.getMessages(convoId: chatId)
////            }
////        }
////    }
////
////    func getMessages(convoId: String){
////        service.getAllMessage(chatId: convoId) { [weak self] messages in
////            self?.messages = messages
////            self?.messagesCollectionView.reloadDataAndKeepOffset()
////        }
////    }
////}
////
////extension ChatDetailViewController: MessagesDisplayDelegate, MessagesLayoutDelegate, MessagesDataSource {
////
////    func currentSender() -> MessageKit.SenderType {
////        return selfSender
////    }
////
////    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
////        return messages[indexPath.section]
////    }
////
////    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
////        return messages.count
////    }
////
////}
////
////extension ChatDetailViewController: InputBarAccessoryViewDelegate {
////
////    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
////
////        if let otherId = self.otherId {
////            let msg = Message(sender: selfSender, messageId: "", sentDate: Date(), kind: .text(text))
////            messages.append(msg)
////
////            service.sendMessage(otherId: otherId, convoId: chatID, text: text) { [weak self] convoId in
////                DispatchQueue.main.async {
////                    inputBar.inputTextView.text = ""
////                    inputBar.invalidatePlugins()
////                    inputBar.inputTextView.resignFirstResponder()
////                }
////                self?.chatID = convoId
////            }
////        } else {
////            // handle case when otherId is nil
////        }
////
////    }
////
////}
//
//import Firebase
//import UIKit
//import Foundation
//import MessageKit
//import InputBarAccessoryView
//
//class ChatDetailViewController: MessagesViewController {
//
//    var otherUser: User?
//    var currentUser: User?
//    var messages: [Message] = []
//    let databaseRef = Database.database().reference()
//
//    private var messageListener: ListenerRegistration?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set up the message input bar
//        messageInputBar.delegate = self
//
//        // Set up the message display
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
//        maintainPositionOnKeyboardFrameChanged = true
//        messageInputBar.inputTextView.tintColor = .purple
//        messageInputBar.sendButton.setTitleColor(.purple, for: .normal)
//        scrollsToLastItemOnKeyboardBeginsEditing = true
//        messagesCollectionView.backgroundColor = .white
//
//        // Get the current user
//        if let currentUser = Auth.auth().currentUser {
//            self.currentUser = User(userId: currentUser.uid, data: [:])
//        }
//
//        // Set the title to the other user's name
//        setUserInfo()
//
//        // Load messages
//        if let currentUser = self.currentUser, let otherUser = self.otherUser {
//            let dbRef = Database.database().reference(withPath: "messages")
//            let query = dbRef.queryOrdered(byChild: "otherUserId").queryEqual(toValue: otherUser.userId)
//            messageListener = query.observe(.value) { snapshot in
//                self.messages.removeAll()
//                for child in snapshot.children {
//                    guard let currentUser = self.currentUser, let otherUser = self.otherUser,
//                          let childSnapshot = child as? DataSnapshot, let data = childSnapshot.value as? [String:Any],
//                          let sender = Sender(id: data["senderId"] as? String ?? "", displayName: data["senderName"] as? String ?? "")
//                          let receiver = Sender(id: otherUser.userId, displayName: otherUser.fullName)
//                          let message = Message(sender: sender,
//                                                receiver: receiver,
//                                                messageId: "",
//                                                sentDate: Date(timeIntervalSince1970: timestamp),
//                                                kind: .text(data["text"] as? String ?? ""))
//                    else {
//                        continue
//                    }
//                    self.messages.append(message)
//                }
//                self.messagesCollectionView.reloadData()
//                self.messagesCollectionView.scrollToLastItem(animated: true)
//            } as! ListenerRegistration as! ListenerRegistration as! ListenerRegistration as? ListenerRegistration
//        }
//    }
//
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.identifier == "ProfileViewController", let profileVC = segue.destination as? ProfileViewController {
////            profileVC.user = otherUser
////        }
////    }
//
//    deinit {
//        messageListener?.remove()
//    }
//
//    func setUserInfo() {
//        guard let otherUser = self.otherUser else {
//            return
//        }
//        title = otherUser.fullName
//    }
//
//}
//
//// MARK: - MessagesDataSource
//
//extension ChatDetailViewController: MessagesDataSource {
//
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        return messages.count
//    }
//
//    func currentSender() -> SenderType {
//        return Sender(senderId: currentUser?.userId ?? "", displayName: currentUser?.fullName ?? "")
//    }
//
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        return messages[indexPath.section] as! MessageType
//    }
//
//}
//
//// MARK: - MessagesLayoutDelegate
//
//extension ChatDetailViewController: MessagesLayoutDelegate {
//
//    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 0
//    }
//
//}
//
//// MARK: - MessagesDisplayDelegate
//
//extension ChatDetailViewController: MessagesDisplayDelegate {
//
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = message.sender.senderId == currentUser?.userId ? .bottomRight : .bottomLeft
//        return .bubbleTail(corner, .curved)
//    }
//
//}
//
//// MARK: - InputBarAccessoryViewDelegate
//
//extension ChatDetailViewController: InputBarAccessoryViewDelegate {
//
//    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        guard let currentUser = currentUser, let otherUser = otherUser else {
//            return
//        }
//
//        let messageRef = databaseRef.child("messages").childByAutoId()
//        let timestamp = Date().timeIntervalSince1970
//        let messageData = [ "senderId": currentUser.userId,
//                            "senderName": currentUser.fullName,
//                            "receiverId": otherUser.userId,
//                            "receiverName": otherUser.fullName,
//                            "text": text,
//                            "timestamp": timestamp] as [String : Any]
//        messageRef.setValue(messageData) { (error, ref) in
//            if let error = error {
//                print("Error sending message: \(error.localizedDescription)")
//                return
//            }
//            let messageId = messageRef.key ?? ""
//            let message = Message(messageId: messageId, data: messageData, currentUser: currentUser, otherUser: otherUser)
//            self.insertNewMessage(message)
//            self.scrollCollectionViewToBottom()
//        }
//    }
//
//    private func insertNewMessage(_ message: Message) {
//        messages.append(message)
//        messagesCollectionView.reloadData()
//    }
//
//    private func scrollCollectionViewToBottom() {
//        if !messages.isEmpty {
//            messagesCollectionView.scrollToLastItem(animated: true)
//        }
//    }
//}
//
//extension QueryDocumentSnapshot {
//
//func toMessage() -> Message? {
//    let data = self.data()
//    return Message(senderId: data["senderId"] as? String ?? "",
//                   senderName: data["senderName"] as? String ?? "",
//                   otherUserId: data["otherUserId"] as? String ?? "",
//                   otherUserName: data["otherUserName"] as? String ?? "",
//                   text: data["content"] as? String ?? "",
//                   timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date())
//
//}
//}
//
//
//
//// MARK: - Message struct
//
//struct Message: MessageType {
//    var sender: SenderType
//    var receiver: SenderType
//    var messageId: String
//    var sentDate: Date
//    var kind: MessageKind
//
//    init(sender: SenderType, receiver: SenderType, messageId: String, sentDate: Date, kind: MessageKind) {
//        self.sender = sender
//        self.receiver = receiver
//        self.messageId = messageId
//        self.sentDate = sentDate
//        self.kind = kind
//    }
//
//    init?(data: [String: Any], currentUser: User, otherUser: User) {
//        guard let senderId = data["senderId"] as? String,
//              let senderName = data["senderName"] as? String,
//              let receiverId = data["receiverId"] as? String,
//              let receiverName = data["receiverName"] as? String,
//              let text = data["text"] as? String,
//              let timestamp = data["timestamp"] as? TimeInterval
//        else {
//            return nil
//        }
//
//        let sender = Sender(id: senderId, displayName: senderName)
//        let receiver = Sender(id: receiverId, displayName: receiverName)
//
//        self.sender = sender
//        self.receiver = receiver
//        self.messageId = ""
//        self.sentDate = Date(timeIntervalSince1970: timestamp)
//        self.kind = .text(text)
//    }
//
//    func toData() -> [String: Any] {
//        return [
//            "senderId": sender.senderId,
//            "senderName": sender.displayName,
//            "receiverId": receiver.senderId,
//            "receiverName": receiver.displayName,
//            "text": MessageKind.text,
//            "timestamp": sentDate.timeIntervalSince1970
//        ]
//    }
//}
//
//// MARK: - User struct
//
////struct User {
////
////let userId: String
////let fullName: String
////let imageURL: String?
////
////init(userId: String, data: [String: Any]) {
////    self.userId = userId
////    self.fullName = data["fullName"] as? String ?? ""
////    self.imageURL = data["imageURL"] as? String
////}
////}



import Firebase
import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    var messageId: String
    var sender: SenderType
    var sentDate: Date
    var kind: MessageKind
    
    init(id: String, sender: SenderType, sentDate: Date, kind: MessageKind) {
             self.messageId = id
             self.sender = sender
             self.sentDate = sentDate
             self.kind = kind
         }
}

class ChatDetailViewController: MessagesViewController {
    var selectedUser: User?
    var currentSenderId: SenderType? {
        return Sender(senderId: Auth.auth().currentUser?.uid ?? "", displayName: "Me")
    }
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = selectedUser?.fullName
//        currentSender = Sender(senderId: Auth.auth().currentUser?.uid ?? "", displayName: "Me")

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        setupInputBar()

        
        
    }
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }

//    private func sendNewMessage(_ message: Message) {
//        let ref = Database.database().reference().child("chats").childByAutoId()
//        let messageItem = [
//            "id": message.messageId,
//            "senderId": message.sender.senderId,
//            "senderName": message.sender.displayName,
//            "sentDate": message.sentDate.timeIntervalSince1970,
//            "message": message.kind.self
//        ] as [String : Any]
//        ref.setValue(messageItem)
//    }
    private func sendNewMessage(_ message: Message) {
        let ref = Database.database().reference().child("chats").childByAutoId()
        let messageItem: [String: Any] = [
            "id": message.messageId,
            "senderId": message.sender.senderId,
            "senderName": message.sender.displayName,
            "sentDate": message.sentDate.timeIntervalSince1970,
            "message": MessageKind.text // prеобразуем в текст сообщения
        ]
        ref.setValue(messageItem)
    }

    private func setupInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.placeholder = "Type a message"
        messageInputBar.sendButton.title = "Send"
    }
}



extension ChatDetailViewController: MessagesDataSource, MessagesLayoutDelegate {
    func currentSender() -> SenderType {
        return currentSenderId!
    }
    
    
    func getCurrentSender() -> SenderType {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError("User must be logged in")
        }
        return Sender(senderId: currentUser.uid, displayName: "Me")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let sender = message.sender
        let attrs = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ]
        return NSAttributedString(string: sender.displayName, attributes: attrs)
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy hh:mm a"
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.gray
        ])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        // Добавьте код здесь, если хотите отображать нижнюю метку ячейки
        return nil
    }
}

extension ChatDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let message = Message(id: UUID().uuidString, sender: currentSenderId!, sentDate: Date(), kind: .text(text))
        insertNewMessage(message)
        sendNewMessage(message)
        
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToLastItem(animated: true)
    }
}
