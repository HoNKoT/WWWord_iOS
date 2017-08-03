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
        // initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let groupCount = GroupDao().findAll().count
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
            for: indexPath) as! GroupCell).alsoRet { $0.setGroup(groups[indexPath.row]) }
    }
    
    // getCount
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
}

/**---------------------------------------------------------------
 * Implementation methods for UITableViewDelegate
 * --------------------------------------------------------------- */
extension GroupListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            // delete record
//            let expense = expenses[indexPath.row]
//            ExpenseDao().delete(expense: expense)
//            
//            // remove row item
//            expenses.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            print(indexPath.row)
//            
//            // initialize view
//            initializeView()
//        }
    }
}

