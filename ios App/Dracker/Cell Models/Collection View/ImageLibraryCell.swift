import UIKit

class ImageLibraryCell: BaseCollectionViewCell {
    
    let tag_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "NoImage")
        return image
    }()
    
    override func setup_cell() {
        super.setup_cell()
        //Add the imageView
        addSubview(tag_image)
        addConstraintsWithFormat(format: "H:|[v0]|", views: tag_image)
        addConstraintsWithFormat(format: "V:|[v0]|", views: tag_image)
    }
    
    func load_image_from_url(url: String) {
        tag_image.downloadImage(url: url)
    }
}
