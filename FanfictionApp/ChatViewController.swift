//import Firebase
//import UIKit
//
//struct Chat {
//    let chatId: String
//    let user: User
////    let lastMessage: String
//    let timestamp: TimeInterval
//
//    init(chatId: String, user: User, timestamp: TimeInterval) {
//        self.chatId = chatId
//        self.user = user
////        self.lastMessage = lastMessage
//        self.timestamp = timestamp
//    }
//
//    init?(data: [String: Any]) {
//        guard let chatId = data["chatId"] as? String,
//              let userDict = data["user"] as? [String: Any],
//              let userId = userDict["userId"] as? String,
//              let timestamp = data["timestamp"] as? TimeInterval
//              else {
//                  return nil
//              }
//
//        let user = User(userId: userId, data: userDict)
////        let lastMessage = data["lastMessage"] as? String ?? ""
//
//        self.chatId = chatId
//        self.user = user
////        self.lastMessage = lastMessage
//        self.timestamp = timestamp
//
//
//    }
//
//}
//
//struct User {
//    let userId: String
//    let email: String
//    let nickname: String
//    let fullName: String
//    let imageURL: String?
//
//    init(userId: String, data: [String: Any]) {
//        self.userId = userId
//        self.email = data["email"] as? String ?? ""
//        self.nickname = data["nickname"] as? String ?? ""
//        self.fullName = data["fullName"] as? String ?? ""
//        self.imageURL = data["profileImageUrl"] as? String
//    }
//}
//
//class ChatTableViewCell: UITableViewCell, UISearchBarDelegate {
//    @IBOutlet weak var profileImageView: UIImageView!
//    @IBOutlet weak var fullNameLabel: UILabel!
////    @IBOutlet weak var lastMessageLabel: UILabel?
//
//    var currentUser: User?
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        profileImageView.image = nil
//        fullNameLabel.text = nil
////        lastMessageLabel.text = nil
//
//        self.currentUser = nil // сброс пользовательских данных
//
//        if let currentUser = Auth.auth().currentUser {
//            self.currentUser = User(userId: currentUser.uid, data: [
//                "email": currentUser.email ?? "",
//                "nickname": "",
//                "fullName": currentUser.displayName ?? "",
//                "imageURL": currentUser.photoURL?.absoluteString ?? ""
//            ])
//        }
//    }
//}
//
//class ChatViewController: UIViewController {
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
//
//    var chatsRef = Database.database().reference().child("users")
//    var currentUser: User?
//    var chats: [Chat] = []
//    var users: [User] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.dataSource = self
//        tableView.delegate = self
//        searchBar.delegate = self
//
//        // Получить текущего пользователя и сохранить его в currentUser
//        if let currentUser = Auth.auth().currentUser {
//            self.currentUser = User(userId: currentUser.uid, data: [
//                "email": currentUser.email ?? "",
//                "nickname": "",
//                "fullName": currentUser.displayName ?? "",
//                "imageURL": currentUser.photoURL?.absoluteString ?? ""
//            ])
//        }
//
//        // Следить за изменениями в базе данных Firebase и обновлять список чатов
//        chatsRef.observe(.value) { (snapshot) in
//            if let data = snapshot.value as? [String: Any] {
//                self.chats = data.compactMap { Chat(data: $0.value as? [String: Any] ?? [:]) }
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//    func filteredChats(with searchText: String) -> [Chat] {
//        return chats.filter { chat in
//            let userName = chat.user.fullName.lowercased()
////            let lastMessage = chat.lastMessage.lowercased()
//            return userName.contains(searchText.lowercased())
////            lastMessage.contains(searchText.lowercased())
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let chat = sender as? Chat, let vc = segue.destination as? ChatDetailViewController {
//            vc.currentUser = currentUser
//            vc.chat = chat
//        }
//    }
//}
//
//extension ChatViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Numbers of rows: \(chats.count)")
//        return chats.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       let cellIdentifier = "ChatTableViewCell"
//       guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatTableViewCell else {
//           fatalError("The dequeued cell is not an instance of ChatTableViewCell.")
//       }
//
//       // Проверяем, что индекс строки находится в пределах допустимых значений
//       if indexPath.row < chats.count {
//           let chat = chats[indexPath.row]
//           cell.fullNameLabel.text = chat.user.fullName
//           cell.currentUser = currentUser
//
//           // Проверяем, что imageURL не равен nil
//           if let imageURL = chat.user.imageURL, let url = URL(string: imageURL) {
//               DispatchQueue.global().async {
//                   if let imageData = try? Data(contentsOf: url) {
//                       DispatchQueue.main.async {
//                           // Проверяем, что currentUser не равен nil
//                           guard let currentUser = cell.currentUser else { return }
//
//                           // Если текущий пользователь равен пользователю чата, отображаем зеленый фон
//                           if chat.user.userId == currentUser.userId {
//                               cell.backgroundColor = UIColor.green
//                           } else {
//                               cell.backgroundColor = UIColor.white
//                           }
//
//                           cell.profileImageView.image = UIImage(data: imageData)
//                       }
//                   }
//               }
//           }
//       } else {
//           // Обработка ошибки, если индекс строки выходит за пределы допустимых значений
//           cell.fullNameLabel.text = "Invalid index"
//           cell.backgroundColor = UIColor.red
//           cell.profileImageView.image = nil
//       }
//
//       return cell
//    }
//}
//
//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       if indexPath.row < chats.count {
//           let chat = chats[indexPath.row]
//           performSegue(withIdentifier: "ChatDetailViewController", sender: chat)
//       } else {
//           // Обработка ошибки, если индекс строки выходит за пределы допустимых значений
//           print("Error: Index out of range")
//       }
//    }
//}
//
//extension ChatViewController: UISearchBarDelegate {
//
//
//
//    func searchUserByName(name: String) {
//        let usersRef = Database.database().reference().child("users")
//        usersRef.queryOrdered(byChild: "fullName").queryStarting(atValue: name).queryEnding(atValue: name+"\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in if let data = snapshot.value as? [String: Any] { self.users = data.map { User(userId: $0.key, data: $0.value as? [String: Any] ?? [:])
//
//        }
//        self.tableView.reloadData()
//
//        }
//        else {
//            print("User not found in database")
//            self.users = []
//            self.tableView.reloadData()
//
//        }
//
//        }
//
//    }
//
////    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
////        let name = searchText.trimmingCharacters(in: .whitespaces)
////        if name.isEmpty {
////            // Если поисковая строка пуста, показываем всех пользователей
////            users = []
////            tableView.reloadData()
////            return
////        } else {
////            // Если поисковая строка содержит текст, ищем пользователей с помощью метода поиска по имени
////            searchUserByName(name: name)
////        }
////    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            if searchText.isEmpty {
//                users = []
//                tableView.reloadData()
//                return
//            }
//
//            searchUserByName(name: searchText)
//
//    }
//}
//
//


import Firebase
import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var fullName: UILabel!
}
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var users: [User] = []
    var searchResults: [User] = []
    var currentUserId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        searchBar.delegate = self

        // Get the current user's id
        if let currentUser = Auth.auth().currentUser {
            currentUserId = currentUser.uid
        }
    }

    func searchUserByName(name: String) {
        let usersRef = Database.database().reference().child("users")
        usersRef.queryOrdered(byChild: "fullName").queryStarting(atValue: name).queryEnding(atValue: name+"\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                self.searchResults = data.map { User(userId: $0.key, data: $0.value as? [String: Any] ?? [:]) }
                self.tableView.reloadData()
            } else {
                print("User not found in database")
                self.searchResults = []
                self.tableView.reloadData()
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! ChatTableViewCell
        let user = searchResults[indexPath.row]
        cell.fullName.text = user.fullName
        if let urlString = user.imageURL, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.imageUser.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
}

extension ChatViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
            tableView.reloadData()
            return
        }

        searchUserByName(name: searchText)
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = searchResults[indexPath.row]
        self.performSegue(withIdentifier: "ChatDetailViewController", sender: selectedUser)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatDetailViewController", let selectedUser = sender as? User {
            let chatDetailVC = segue.destination as! ChatDetailViewController
            chatDetailVC.selectedUser = selectedUser }
        
    }
}

struct User {
    let userId: String
    let email: String
    let nickname: String
    let fullName: String
    let imageURL: String?
    var dialogId: String? // новое поле

    init(userId: String, data: [String: Any]) {
        self.userId = userId
        self.email = data["email"] as? String ?? ""
        self.nickname = data["nickname"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.imageURL = data["profileImageUrl"] as? String
    }
}
//class ChatViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
//
//    var users: [User] = []
//    var currentUserId: String?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.dataSource = self
//        searchBar.delegate = self
//
//        // Get the current user's id
//        if let currentUser = Auth.auth().currentUser {
//            currentUserId = currentUser.uid
//        }
//    }
//
//    func searchUserByName(name: String) {
//        let usersRef = Database.database().reference().child("users")
//        usersRef.queryOrdered(byChild: "fullName").queryStarting(atValue: name).queryEnding(atValue: name+"\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
//            if let data = snapshot.value as? [String: Any] {
//                self.users = data.map { User(userId: $0.key, data: $0.value as? [String: Any] ?? [:]) }
//                self.tableView.reloadData()
//            } else {
//                print("User not found in database")
//                self.users = []
//                self.tableView.reloadData()
//            }
//        }
//    }
//}
//
//extension ChatViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! ChatTableViewCell
//        let user = users[indexPath.row]
//        cell.fullName.text = user.fullName
//        if let urlString = user.imageURL, let url = URL(string: urlString) {
//            DispatchQueue.global().async {
//                if let imageData = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        cell.imageUser.image = UIImage(data: imageData)
//                    }
//                }
//            }
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return users.count
//    }
//}
//
//extension ChatViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            users = []
//            tableView.reloadData()
//            return
//        }
//
//        searchUserByName(name: searchText)    }
//}
//
//
//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedUser = users[indexPath.row]
//        self.performSegue(withIdentifier: "ChatDetailViewController", sender: selectedUser)
//    }
//}


