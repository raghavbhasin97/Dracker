import UIKit

class NetworkConnection: UIViewController {
    
    let height: CGFloat = 60
    let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = #imageLiteral(resourceName: "network")
        return image
    }()
    let connection: UILabel = {
        let label = UILabel()
        label.text = "Network Issues"
        label.textColor = UIColor.text_color.withAlphaComponent(0.68)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 20)!
        label.textAlignment = .center
        return label
    }()
    let description_label: UILabel = {
        let label = UILabel()
        label.text = "There seems to be an issue connection with Dracker. Check your connection or try again later."
        label.numberOfLines = 3
        label.textColor = UIColor.text_color.withAlphaComponent(0.68)
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup_view() {
        view.backgroundColor = .white
        UIApplication.shared.statusBarStyle = .default
    }
    
    fileprivate func setup_image() {
        view.addSubview(image)
        let padding = (view.frame.width - height)/2
        view.addConstraintsWithFormat(format: "H:|-\(padding)-[v0]-\(padding)-|", views: image)
        view.center_Y(item: image, constant: -10)
        image.widthAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    fileprivate func setup_header() {
        view.addSubview(connection)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: connection)
        connection.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: 30).isActive = true
    }
    
    fileprivate func setup_description() {
        view.addSubview(description_label)
        view.addConstraintsWithFormat(format: "H:|-2-[v0]-2-|", views: description_label)
        description_label.topAnchor.constraint(equalTo: connection.bottomAnchor, constant: 5).isActive = true
    }
    
    fileprivate func setup() {
        setup_view()
        setup_image()
        setup_header()
        setup_description()
    }
}
