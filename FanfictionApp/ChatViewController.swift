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
                self.users = data.map { User(userId: $0.key, data: $0.value as? [String: Any] ?? [:]) }
                self.tableView.reloadData()
            } else {
                print("User not found in database")
                self.users = []
                self.tableView.reloadData()
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! ChatTableViewCell
        let user = users[indexPath.row]
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
        return users.count
    }
}

extension ChatViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            users = []
            tableView.reloadData()
            return
        }

        searchUserByName(name: searchText)    }
}

struct User {
    let userId: String
    let email: String
    let nickname: String
    let fullName: String
    let imageURL: String?

    init(userId: String, data: [String: Any]) {
        self.userId = userId
        self.email = data["email"] as? String ?? ""
        self.nickname = data["nickname"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.imageURL = data["profileImageUrl"] as? String
    }
}
