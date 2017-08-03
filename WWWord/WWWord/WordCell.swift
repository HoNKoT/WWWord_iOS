import UIKit

class WordCell: UITableViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    private var word: Word? = nil
    
    func setWord(_ word: Word) {
        self.word = word
        updateDisplay()
    }
    
    func updateDisplay() {
        if let word = self.word {
            wordLabel.text = word.word
            meaningLabel.text = word.meaning
        }
    }
}
