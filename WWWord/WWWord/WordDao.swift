import Foundation
import RealmSwift

class WordDao {
    private let realm = try! Realm()
    
    private static let sortProperties = [SortDescriptor(keyPath: "listId")]
    
    private func sortedByListId(_ results: Results<Word>) -> Results<Word> {
        return results.sorted(by: WordDao.sortProperties)
    }
    
    private func isExisted(_ word: Word) -> Bool {
        return !findAll().filter("id = %@", word.id).isEmpty
    }
    
    func findAll() -> Results<Word> {
        return realm.objects(Word.self)
    }
    
    func findAll(_ byGroup: Group) -> Results<Word> {
        return findAll().filter("group.id = %@", byGroup.id)
    }

    private func generateId() -> Int {
        return (findAll().sorted(byKeyPath: "id").last?.id).map{ $0 + 1 } ?? 1
    }
    
    private func generateListId(_ byGroup: Group) -> Int {
        return (findAll(byGroup).sorted(byKeyPath: "listId").last?.id).map{ $0 + 1 } ?? 1
    }
    
    func findAllOrderByListId() -> Results<Word> {
        return sortedByListId(findAll())
    }

    func findAllOrderByListId(byGroup: Group) -> Results<Word> {
        return sortedByListId(findAll(byGroup))
    }

    func insert(_ word: Word) -> Bool {
        if isExisted(word) {
            return update(word)

        } else {
            if let group = word.group {
                do {
                    try realm.write {
                        word.also {
                            $0.id = generateId()
                            $0.listId = generateListId(group)
                            realm.add($0)
                        }
                    }
                } catch {
                    return false
                }
                return true
            } else {
                return false
            }
        }
    }
    
    func update(_ word: Word) -> Bool {
        if let group = word.group {
            return update(word, group: group, word: word.word, meaning: word.meaning, example: word.example, detail: word.detail, memo: word.memo, audioFile: word.audioFile)

        } else {
            return false
        }
    }
    
    private func update(_ obj: Word, group: Group, word: String, meaning: String, example: String, detail: String, memo: String, audioFile: String) -> Bool {
        do {
            try realm.write {
                obj.group = group
                obj.word = word
                obj.meaning = meaning
                obj.example = example
                obj.detail = detail
                obj.memo = memo
                obj.audioFile = audioFile
            }
        } catch {
            return false
        }
        return true
    }
}
