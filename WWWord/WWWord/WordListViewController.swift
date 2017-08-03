import UIKit

class WordListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    internal var group: Group?
    internal var words: Array<Word> = []
    fileprivate let cellIdentifer = "WordCell"

}

/**---------------------------------------------------------------
 * Override methods
 * --------------------------------------------------------------- */
extension WordListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = group?.name ?? "Deck"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let wordCount = WordDao().findAll(group!).count
        
        if (Option.DEBUG) {
            print("viewWillAppear() ### wordCount = \(wordCount) vs words.count = \(words.count)")
        }
        
        if (words.count != wordCount) {
            initializeData()
        }
    }
}

/**---------------------------------------------------------------
 * Initializer
 * --------------------------------------------------------------- */
extension WordListViewController {
    func initializeData() {
        words = Array(WordDao().findAll(group!))
    }
    
    func initializeData(group: Group) {
        self.group = group
    }
}

/**---------------------------------------------------------------
 * Implementation methods for UITableViewDataSource
 * --------------------------------------------------------------- */
extension WordListViewController: UITableViewDataSource {
    // getView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(
            withIdentifier: cellIdentifer,
            for: indexPath) as! WordCell
            ).alsoRet { $0.setWord(getItem(indexPath)) }
    }
    
    // getCount
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    // getItem
    func getItem(_ indexPath: IndexPath) -> Word {
        return words[indexPath.row]
    }
}

/**---------------------------------------------------------------
 * Implementation methods for UITableViewDelegate
 * --------------------------------------------------------------- */
extension WordListViewController: UITableViewDelegate {
    
    // Turn on swipe delete mode
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Selected delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // delete record
            let word = getItem(indexPath)
            // TODO
            //            GroupDao().delete(group)
            
            // remove row item
            words.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if (Option.DEBUG) {
                print("Deleted \(indexPath.row): [\(word.id)] \(word.word) / \(word.meaning)")
            }
        }
    }
    
    // Selected Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = getItem(indexPath)
        print(word.word)
    }
}
