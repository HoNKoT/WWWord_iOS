import Foundation
import RealmSwift

class GroupDao {
    private let realm = try! Realm()
    
    private static let sortProperties = [SortDescriptor(keyPath: "listId")]
    
    init() {
        if (Option.DEBUG) {
            if (findAll().count > 0) {
                return
            }
            
            let wordDao = WordDao()
            
            // Insert some Test Groups
            for i in 1...3 {
                let group = Group().alsoRet {
                    $0.name = "Deck \(i)"
                    $0.notify = true
                    if (insert($0)) {
                        // ...
                    }
                }
                
                print("initalize \(group.id) - \(group.name) which has 200 items(words)")
                
                for j in 1...200 {
                    // Insert some Test Words
                    Word().also {
                        $0.group = group
                        $0.word = "Word \(i)-\(j)"
                        $0.meaning = "Meaning \(i)-\(j)"
                        $0.example = "Example \(i)-\(j)"
                        $0.detail = "Detail \(i)-\(j)"
                        $0.memo = "Memo \(i)-\(j)"
                        $0.audioFile = "AudioFile \(i)-\(j)"
                        if (wordDao.insert($0)) {
                            // ...
                        }
                    }
                }
            }
        }
    }
    
    private func isExisted(_ group: Group) -> Bool {
        return !findAll().filter("id = %@", group.id).isEmpty
    }
    
    func findAll() -> Results<Group> {
        return realm.objects(Group.self).filter("valid = %@", true)
    }
    
    func generateId() -> Int {
        return (findAll().sorted(byKeyPath: "id").last?.id).map{ $0 + 1 } ?? 1
    }
    
    func generateListId() -> Int {
        return (findAll().sorted(byKeyPath: "listId").last?.id).map{ $0 + 1 } ?? 1
    }

    private func findAllOrderByListId() -> Results<Group> {
        return findAll().sorted(by: GroupDao.sortProperties)
    }
    
    func insert(_ group: Group) -> Bool {
        if isExisted(group) {
            return update(group, name: group.name)
        }

        do {
            try realm.write {
                group.also {
                    $0.id = generateId()
                    $0.listId = generateListId()
                    realm.add($0)
                }
            }
        } catch {
            return false
        }
        
        return true
    }

    func update(_ group: Group, name: String) -> Bool {
        do {
            try realm.write {
                group.name = name
            }
        } catch {
            return false
        }
        return true
    }
    
    func delete(_ group: Group) -> Bool {
        do {
            try realm.write {
//                realm.delete(Array(WordDao().findAll(group)))
//                realm.delete(group)
                for word in Array(WordDao().findAll(group)) {
                    word.valid = false
                }
                group.valid = false
            }
        } catch {
            return false
        }
        
        return true
    }
}
