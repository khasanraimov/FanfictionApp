import UIKit
import Firebase

class StoryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
        
    var story: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Отображаем заголовок и содержимое истории на странице
        titleLabel.text = story?.title
        contentTextView.text = story?.content
    }
    

}
