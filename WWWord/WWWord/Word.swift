import Foundation
import RealmSwift

class Word: Object {
    dynamic var id = 0
    dynamic var listId = 0
    dynamic var group: Group? = nil
    dynamic var word = ""
    dynamic var meaning = ""
    dynamic var example = ""
    dynamic var detail = ""
    dynamic var memo = ""
    dynamic var audioFile = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
