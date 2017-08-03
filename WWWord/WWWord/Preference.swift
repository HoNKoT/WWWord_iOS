import Foundation
import RealmSwift

class Preference: Object {
    public static let DEFAULT_INTERVAL: Int = 5 * 60 * 1000
    private static let INNER_DEFAULT_INTERVAL: Int = 300000
    
    dynamic var notificationInterval: Int = INNER_DEFAULT_INTERVAL
    dynamic var wakeup = true
    dynamic var popup = true
    dynamic var vib = true
    dynamic var ring = true
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
