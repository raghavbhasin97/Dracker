import UIKit

extension UIColor {
    
    //MARK: function
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    //MARK: Colors
    static let theme = UIColor(r: 55, g: 52, b: 71)
    static let themeUnselected = UIColor(r: 138, g: 138, b: 138)
    static let drBlack = UIColor(r: 64, g: 66, b: 69)
    static let pay = UIColor(r: 130, g: 11, b: 29)
    static let charge = UIColor(r: 6, g: 91, b: 7)
    static let lightBackground = UIColor(r: 240, g: 240, b: 240)
    static let themeLight = UIColor(r: 83, g: 81, b: 95)
    static let overlay = UIColor(white: 0, alpha: 0.2)
    static let optionBlue = UIColor(r: 8, g: 148, b: 251)
    static let optionGreen = UIColor(r: 20, g: 201, b: 159)
    static let optionRed = UIColor(r: 140, g: 7, b: 44)
    static let lightBlack = UIColor.drBlack.withAlphaComponent(0.65)
    static let lighterGray = UIColor.lightGray.withAlphaComponent(0.155)
    static let lightRed = UIColor(r: 216, g: 77, b: 98)
    static let lightWhite = UIColor(white: 0.92, alpha: 1.0)
}
