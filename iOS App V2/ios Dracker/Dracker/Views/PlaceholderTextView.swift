import UIKit

/**
  An implementation of UITextView that allows placeholders like UITextField
 */

class PlaceholderTextView: UITextView {
    
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    /**
        Placeholder Text View initializer
        - placeholder: Placeholder Text
     */
    init(placeholder: String) {
        super.init(frame: .zero, textContainer: nil)
        setup()
        placeHolderLabel.text = placeholder
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        addSubview(placeHolderLabel)
        addConstraintsWithFormat(format: "H:|-2-[v0]", views: placeHolderLabel)
        addConstraintsWithFormat(format: "V:|-6-[v0]-6-|", views: placeHolderLabel)
    }
    
    @objc func textChanged() {
        if self.text.count > 0 {
            placeHolderLabel.alpha = 0
        } else {
            placeHolderLabel.alpha = 1.0
        }
    }
    
    /**
     clear the text and reset the UITextView
     */
    func clearText() {
        self.text = ""
        placeHolderLabel.alpha = 1.0
    }
    
}
