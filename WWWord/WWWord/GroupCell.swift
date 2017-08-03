import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    private var group: Group? = nil
    
    func setGroup(_ group: Group) {
        self.group = group
        updateDisplay()
    }
    
    func updateDisplay() {
        if let group = self.group {
            nameLabel.text = group.name
        }
    }
}
