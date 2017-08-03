import Foundation
import RealmSwift

class Group: Object {
    dynamic var id = 1
    dynamic var listId = 1
    dynamic var name = ""
    dynamic var notify: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
