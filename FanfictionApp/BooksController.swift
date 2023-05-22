import UIKit
import Firebase

class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
}

class BooksController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stories = [Story]()

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadStories()

    }


    @IBAction func createANewStory(_ sender: Any) {
        // TODO: Add logic for creating a new story
    }
    
    func loadStories() {
            // загрузка данных из Firebase
            let databaseRef = Database.database().reference().child("stories")
            databaseRef.observe(.value, with: { (snapshot) in
                guard let snapshotValue = snapshot.value as? [String: Any] else { return }
                self.stories.removeAll()
                for item in snapshotValue {
                    if let storyData = item.value as? [String: Any], let title = storyData["title"] as? String, let content = storyData["content"] as? String, let author = storyData["author"] as? String {
                        let imageString = storyData["imageUrl"] as? String
                        let story = Story(title: title, content: content, author: author)
                        if let imageString = imageString, let imageUrl = URL(string: imageString) {
                            // загрузка картинки
                            URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                                if let imageData = data, let image = UIImage(data: imageData) {
                                    story.image = imageData
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }).resume()
                        }
                        self.stories.append(story)
                    }
                }
                self.tableView.reloadData()
            })
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return stories.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryTableViewCell
            let story = stories[indexPath.row]
            cell.titleLabel.text = story.title
            if let image = story.image, let uiImage = UIImage(data: image) {
                cell.photoImageView.image = uiImage
            } else {
                cell.photoImageView.image = UIImage(named: "no-image")
            }
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = stories[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ShowStory", sender: story)
        // переход на экран с деталями истории
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStory" {
            let destinationVC = segue.destination as! StoryViewController
            destinationVC.story = sender as? Story
        }
    }
}
