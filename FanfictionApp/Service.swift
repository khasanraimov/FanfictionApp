//import UIKit
//import Firebase
//
//enum AuthResponce{
//    case success, noVerify, error
//}
//
//struct LoginField {
//    var email: String
//    var password: String
//}
//
//struct ResponceCode{
//    var code: Int
//}
//
//struct CurentUser {
//    var id: String
//    var email: String
//}
//
//class Service {
//    static let shared = Service()
//
//    init() {}
//
//    func createNewUser(_ data: LoginField, complition: @escaping (ResponceCode)->()) {
//        Auth.auth().createUser(withEmail: data.email, password: data.password) { result, err in
//            if err == nil {
//                if result != nil {
//                    let userId = result?.user.uid
//                    let email = data.email
//                    let data: [String: Any] = ["email":email]
//                    Firestore.firestore().collection("users").document(userId!).setData(data)
//                    complition(ResponceCode(code: 1))
//                }
//            } else {
//
//                complition(ResponceCode(code: 0))
//            }
//        }
//    }
//    func confrimEmail(){
//        Auth.auth().currentUser?.sendEmailVerification(completion: {err in
//            if err != nil {
//                print(err!.localizedDescription)
//            }
//        })
//    }
//
//    func authInApp(_ data: LoginField, complition: @escaping (AuthResponce) ->()){
//        Auth.auth().signIn(withEmail: data.email, password: data.password) { result, err in
//            if err != nil {
//                complition(.error)
//            }else  {
//                if let result = result {
//                    if  result.user.isEmailVerified {
//                        complition(.success)
//                    } else {
//                        self.confrimEmail()
//                        complition(.noVerify)
//                    }
//                }
//            }
//        }
//    }
//    func getUsersStatus(){
//
//    }
//
//    func getAllUsers(compliteon: @escaping ([CurentUser]) ->( )) {
//
//        guard let email = Auth.auth().currentUser?.email else{return}
//
//        var curentUsers = [CurentUser]()
//        Firestore.firestore().collection("users")
//            .whereField("email", isNotEqualTo: email)
//            .getDocuments { snap, err in
//                if err == nil {
//                    if let docs = snap?.documents{
//                        for doc in docs {
//                            let data = doc.data()
//                            let userId = doc.documentID
//                            let email = data["email"] as! String
//
//                            curentUsers.append(CurentUser(id: userId, email: email))
//                        }
//                    }
//                    compliteon(curentUsers)
//                }
//        }
//    }
//
//
//    // Messages
//
//    func sendMessage(otherId: String?, convoId: String?, text: String, complition: @escaping (String)->()){
//
//        let ref = Database.database().reference()
//        if let uid = Auth.auth().currentUser?.uid {
//            if convoId == nil {
//                // Создаем новую переписку
//                let convoId = UUID().uuidString
//
//                let selfData: [String: Any] = [
//                        "date": Date(),
//                        "otherId": otherId!
//                ]
//
//                let otherData: [String: Any] = [
//                        "date": Date(),
//                        "otherId": uid
//                        ]
//                // У нас есть переписка с человеком
//                ref.collection("users")
//                    .document(uid)
//                    .collection("conversations")
//                    .document(convoId)
//                    .setData(selfData)
//
//                // У человека есть переписка с нами
//                ref.collection("users")
//                    .document(otherId!)
//                    .collection("conversations")
//                    .document(convoId)
//                    .setData(otherData)
//
//
//                let msg: [String: Any] = [
//                    "date": Date(),
//                    "sender": uid,
//                    "text": text
//                ]
//
//                let convoInfo: [String: Any] = [
//                    "date": Date(),
//                    "selfSender": uid,
//                    "otherSender": otherId!
//                ]
//
//                ref.collection("conversations")
//                    .document(convoId)
//                    .setData(convoInfo) { err in
//                        if let err = err {
//                            print(err.localizedDescription)
//                            return
//                        }
//                        ref.collection("conversations")
//                            .document(convoId)
//                            .collection("messages")
//                            .addDocument(data: msg) { err in
//                                if err == nil {
//                                    complition(convoId)
//                                }
//                            }
//                    }
//
//            } else {
//                let msg: [String: Any] = [
//                    "date": Date(),
//                    "sender": uid,
//                    "text": text
//                ]
//               ref.collection("conversations").document(convoId!).collection("messages").addDocument(data: msg) {err in
//                   if err == nil {
//                       complition(convoId!)
//                   }
//                }
//            }
//        }
//    }
//
//    func updateConvo(){
//
//    }
//
//    func getConvoId(otherId: String, complition: @escaping (String)->()){
//        if let uid = Auth.auth().currentUser?.uid{
//            let ref = Firestore.firestore()
//
//            ref.collection("users")
//                .document(uid)
//                .collection("conversations")
//                .whereField("otherId", isEqualTo: otherId)
//                .getDocuments { snap, err in
//                    if err != nil {
//                        return
//                    }
//                    if let snap = snap, !snap.documents.isEmpty {
//                        let doc = snap.documents.first
//                        if let convoId = doc?.documentID {
//                            complition(convoId)
//
//                        }
//                    }
//                }
//        }
//
//    }
//    func getAllMessage(chatId: String, complition: @escaping ([Message]) -> ()){
//        if let uid = Auth.auth().currentUser?.uid{
//            let ref = Firestore.firestore()
//            ref.collection("conversations")
//                .document(chatId)
//                .collection("messages")
//                .limit(to: 50)
//                .order(by: "date", descending: false)
//                .addSnapshotListener{ snap, err in
//                    if err != nil {
//                        return
//                    }
//                    if let snap = snap, !snap.documents.isEmpty {
//                        var msgs = [Message]()
//                        var sender = Sender(senderId: uid, displayName: "Me")
//                        for doc in snap.documents{
//                            let data = doc.data()
//                            let userId = data["sender"] as! String
//                            let messageId = doc.documentID
//
//                            let date = data["date"] as! Timestamp
//                            let sentDate = date.dateValue()
//                            let text = data["text"] as! String
//
//                            if userId == uid{
//                                sender = Sender(senderId: "1", displayName: "")
//                            } else {
//                                sender = Sender(senderId: "2", displayName: "")
//                            }
//
//
//                            msgs.append(Message(sender: sender, messageId: messageId, sentDate: sentDate, kind:.text(text)))
//                        }
//                        complition(msgs)
//                    }
//                }
//        }
//    }
//
//    func getOneMessage(){
//
//    }
//}
