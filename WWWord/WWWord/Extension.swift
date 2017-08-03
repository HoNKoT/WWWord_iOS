
import Foundation

protocol AlsoProtocol {}

extension AlsoProtocol {
    func alsoRet(_ closure: (_ this: Self) -> Void) -> Self {
        closure(self)
        return self
    }
    
    func also(_ closure: (_ this: Self) -> Void) {
        closure(self)
    }
}

extension NSObject: AlsoProtocol {}
