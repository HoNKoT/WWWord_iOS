import UIKit

class GroupListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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

