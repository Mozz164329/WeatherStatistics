
import Foundation

infix operator =>

public func =><T: AnyObject>(left: T, f: (T) -> Void) -> T {
    f(left)
    return left
}

