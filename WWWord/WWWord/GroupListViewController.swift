import UIKit

class GroupListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addMenuAction(_ sender: UIButton) { addMenuAction() }
    
    internal var groups: Array<Group> = []
    fileprivate let cellIdentifer = "GroupCell"

}

/**---------------------------------------------------------------
 * Override methods
 * --------------------------------------------------------------- */
extension GroupListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Deck"
        // initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let groupCount = GroupDao().findAll().count
        
        if (Option.DEBUG) {
            print("viewWillAppear() ### groupCount = \(groupCount) vs groups.count = \(groups.count)")
        }

        if (groups.count != groupCount) {
            initializeData()
        }
    }
}

/**---------------------------------------------------------------
 * Initializer
 * --------------------------------------------------------------- */
extension GroupListViewController {
    func initializeData() {
        groups = Array(GroupDao().findAll())
        for group in groups {
            print(group.name)
        }
    }
}

/**---------------------------------------------------------------
 * Add function
 * --------------------------------------------------------------- */
extension GroupListViewController {
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
            let textField = alert?.textFields![0]
            let text = textField?.text
            
            if (text != nil && !(text?.isEmpty ?? true)) {
                // Force unwrapping because we know it exists.
                let newGroup = Group().alsoRet { $0.name = text! }
                if GroupDao().insert(newGroup) {
                    // ...
                    self.tableView.reloadData()
                    self.groups.append(newGroup)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: self.groups.count - 2, section: 0)], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}

/**---------------------------------------------------------------
 * Implementation methods for UITableViewDataSource
 * --------------------------------------------------------------- */
extension GroupListViewController: UITableViewDataSource {
    // getView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(
            withIdentifier: cellIdentifer,
            for: indexPath) as! GroupCell).alsoRet { $0.setGroup(getItem(indexPath)) }
    }
    
    // getCount
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    // getItem
    func getItem(_ indexPath: IndexPath) -> Group {
        return groups[indexPath.row]
    }
}

/**---------------------------------------------------------------
 * Implementation methods for UITableViewDelegate
 * --------------------------------------------------------------- */
extension GroupListViewController: UITableViewDelegate {

    // Turn on swipe delete mode
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Selected delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // delete record
            let group = getItem(indexPath)
            if GroupDao().delete(group) {
                // ...
            }
            
            // remove row item
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if (Option.DEBUG) {
                print("Deleted \(indexPath.row): [\(group.id)]\(group.name)")
            }
        }
    }

    // Selected Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        print(group.name)
        
        // move to next
        let storyboard = UIStoryboard(name: "WordList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TopViewController") as! WordListViewController
        vc.initializeData(group: group)
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

