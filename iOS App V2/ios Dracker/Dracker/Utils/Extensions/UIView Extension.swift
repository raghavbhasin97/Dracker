import UIKit

enum LinePosition {
    case Top
    case Bottom
    case Left
    case Right
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func centerX(item: UIView) {
        centerX(item: item, constant: 0)
    }
    
    func centerX(item: UIView, constant: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: constant))
    }
    
    func centerY(item: UIView, constant: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: constant))
    }
    
    func centerY(item: UIView) {
        centerY(item: item, constant: 0)
    }
    
    func fillSuperview(padding: CGFloat) {
        superview?.addConstraintsWithFormat(format: "H:|-\(padding)-[v0]-\(padding)-|", views: self)
        superview?.addConstraintsWithFormat(format: "V:|-\(padding)-[v0]-\(padding)-|", views: self)
    }
    
    func fillSuperview() {
        fillSuperview(padding: 0)
    }
    
    func addLine(position: LinePosition, padding: CGFloat = 0.0, color: UIColor = .drBlack, width: CGFloat = 0.75) {
        let blackLine: UIView = {
            let view = UIView()
            view.backgroundColor = color
            view.alpha = 0.35
            return view
        }()
        addSubview(blackLine)
        addConstraintsWithFormat(format: "H:|-\(padding)-[v0]-\(padding)-|", views: blackLine)
        if position == .Top {
            addConstraintsWithFormat(format: "V:|[v0(\(width))]", views: blackLine)
        } else  if position == .Bottom {
            addConstraintsWithFormat(format: "V:[v0(\(width))]|", views: blackLine)
        } else  if position == .Left {
            addConstraintsWithFormat(format: "H:|[v0(\(width))]", views: blackLine)
        } else {
            addConstraintsWithFormat(format: "H:[v0(\(width))]|", views: blackLine)
        }
    }
    
    
}

