import Foundation

extension Double {
    func asAmount() -> String {
        return String(format: "$%0.2f", self)
    }
}
