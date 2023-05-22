import UIKit
import Firebase

class StoryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!

    var story: Story?

    override func viewDidLoad() {
        super.viewDidLoad()
    // Получаем ID автора из базы данных Firebase и получаем информацию об авторе


    // Отображаем заголовок и содержание истории
        titleLabel.text = story?.title
        contentTextView.text = story?.content
        authorLabel.text = "By: \(story?.author ?? "Unknown")"

    }

}
