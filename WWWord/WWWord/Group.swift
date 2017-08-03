import Foundation
import RealmSwift

class Group: Object {
    dynamic var id = 0
    dynamic var listId = 0
    dynamic var name = ""
    dynamic var notify: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
