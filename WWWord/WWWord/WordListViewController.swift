import UIKit

class WordListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func titleAction(_ sender: UIButton) { titleAction() }
    @IBOutlet weak var titleButton: UIButton!
    
    @IBAction func addMenuAction(_ sender: UIButton) { addMenuAction() }

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
        self.titleButton.titleLabel?.text = group?.name ?? "Deck"
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
 * Add function
 * --------------------------------------------------------------- */
extension WordListViewController {
    func titleAction() {
        //1. Create the alert controller.
        let alert = UIAlertController(
            title: "Create Deck",
            message: nil,
            preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = self.group?.name ?? "Deck"
            textField.placeholder = "Enter a title"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let text = textField?.text
            
            if (text != nil && !(text?.isEmpty ?? true)) {
                // Force unwrapping because we know it exists.
                if GroupDao().update(self.group!, name: text!) {
                    self.titleButton.titleLabel?.text = text
                }
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func addMenuAction() {
        //1. Create the alert controller.
        let alert = UIAlertController(
            title: "Create Deck",
            message: nil,
            preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter a title"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0]
//            let text = textField?.text
//            
//            if (text != nil && !(text?.isEmpty ?? true)) {
//                // Force unwrapping because we know it exists.
//                let newGroup = Group().alsoRet { $0.name = text! }
//                if GroupDao().insert(newGroup) {
//                    // ...
////                    self.tableView.reloadData()
////                    self.group.append(newGroup)
////                    self.tableView.beginUpdates()
////                    self.tableView.insertRows(at: [IndexPath(row: self.group.count - 2, section: 0)], with: .automatic)
////                    self.tableView.endUpdates()
//                }
//            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
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
            if WordDao().delete(word) {
                // ...
            }
            
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
