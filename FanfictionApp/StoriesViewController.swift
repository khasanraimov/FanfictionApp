import UIKit
import Firebase

//struct Story {
//    let title: String
//    let content: String
//}
class StoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var likes: Int = 0

    @IBOutlet weak var tableViewOfSearch: UITableView!

    var stories = [Story]()
    var filteredStories = [Story]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar

        tableViewOfSearch.delegate = self
        tableViewOfSearch.dataSource = self

        Database.database().reference().child("stories").observe(.value) { snapshot in
            self.stories.removeAll()
            guard let snapshotValue = snapshot.value as? [String: Any] else { return }
            for storyData in snapshotValue {
                guard let storyDict = storyData.value as? [String: Any] else { continue }
                let title = storyDict["title"] as? String ?? ""
                let content = storyDict["content"] as? String ?? ""
                let story = Story(title: title, content: content)
                self.stories.append(story)
            }
            self.tableViewOfSearch.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredStories[indexPath.row].title
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredStories = stories
        } else {
            filteredStories = stories.filter({(story: Story) -> Bool in
                return story.title.lowercased().contains(searchText.lowercased())
            })
        }
        tableViewOfSearch.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredStories = stories
        tableViewOfSearch.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let story = filteredStories[indexPath.row]
        self.performSegue(withIdentifier: "ShowStory", sender: story)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStory" {
            let destinationVC = segue.destination as! StoryViewController
            destinationVC.story = sender as? Story
        }
    }
    

}
