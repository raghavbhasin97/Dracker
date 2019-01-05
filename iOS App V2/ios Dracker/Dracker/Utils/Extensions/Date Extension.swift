import Foundation

extension Date {
    
    func formatDate(option: DateFormats) -> String {
        let format = DateFormatter()
        format.dateFormat = option.rawValue
        let date = format.string(from: self)
        return date
    }
}
