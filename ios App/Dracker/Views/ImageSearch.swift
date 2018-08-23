import UIKit
import DZNEmptyDataSet

class ImageSearch: UIView {
    
    var initialSearch: String = ""
    let ID = "ImageSearchCell"
    weak var parent: AddTransaction?
    weak var first_responder: UITextField?
    var list_of_images: [String] = []
    
    lazy var navigation: UINavigationBar = {
        let bar = UINavigationBar()
        bar.isTranslucent = false
        bar.tintColor = .white
        let items = UINavigationItem()
        bar.setItems([items], animated: true)
        return bar
    }()
    
    lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = false
        search.definesPresentationContext = false
        search.searchBar.isTranslucent = true
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Tag Image..."
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.keyboardType = .default
        search.searchBar.delegate = self
        return search
    }()
    
    let status_bar: UIView = {
        let view = UIView()
        view.backgroundColor = .theme
        return view
    }()
    
    let search_view: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var imageLibrary: UICollectionView = {
        let library = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        library.dataSource = self
        library.emptyDataSetSource = self
        library.emptyDataSetDelegate = self
        library.delegate = self
        library.backgroundColor = .white
        library.register(ImageLibraryCell.self, forCellWithReuseIdentifier: ID)
        library.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        library.showsHorizontalScrollIndicator = false
        library.showsVerticalScrollIndicator = false
        return library
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        backgroundColor = .white
        addSubview(navigation)
        addSubview(status_bar)
        addSubview(search_view)
        addSubview(imageLibrary)
        let height = UIApplication.shared.statusBarFrame.height
        addConstraintsWithFormat(format: "H:|[v0]|", views: navigation)
        addConstraintsWithFormat(format: "H:|[v0]|", views: search_view)
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageLibrary)
        addConstraintsWithFormat(format: "H:|[v0]|", views: status_bar)
        addConstraintsWithFormat(format: "V:|-\(height)-[v0][v1(50)]-5-[v2]|", views: navigation, search_view ,imageLibrary)
        addConstraintsWithFormat(format: "V:|[v0(\(height))]", views: status_bar)
        search_view.addSubview(search.searchBar)
        search.searchBar.sizeToFit()
    }
    
    func render_view() {
        search.searchBar.text = initialSearch
        self.searchBarSearchButtonClicked(search.searchBar)
    }
    
    fileprivate func send_back() {
        search.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layer.transform = CATransform3DMakeTranslation(0, self.frame.height, 0)
        }){[unowned self] (_) in
            self.first_responder?.becomeFirstResponder()
            self.parent?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.parent?.navigationController?.navigationBar.isUserInteractionEnabled = true
            self.removeFromSuperview()
        }
    }
    
}

//MARK: Searching Delegates

extension ImageSearch: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        initialSearch = searchController.searchBar.text!
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if initialSearch == "" { return }
        search_images_call(search_term: initialSearch) {[unowned self] (data) in
            if data.isFailure {
                return
            }
            let result = data.value as! [String: Any]
            if result["message"] != nil  {
                return
            }
            let items = result["value"] as! [[String: Any]]
            self.list_of_images = []
            for item in items {
                let url = item["thumbnailUrl"] as! String
                self.list_of_images.append(url)
            }
            execute_on_main {
                self.imageLibrary.reloadData()
            }
        }
    }
    
}

//MARK: Image Library Delegates
extension ImageSearch: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageLibrary.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! ImageLibraryCell
        cell.load_image_from_url(url: list_of_images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(list_of_images.count, 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = imageLibrary.cellForItem(at: indexPath) as! ImageLibraryCell
        let image = item.tag_image.image!
        parent?.image_url = image.get_temporary_path(quality: 0.50)
        parent?.navigation_title.text = "Add Transaction"
        parent?.set_options(state: .selected, type: .a_camera)
        send_back()
    }
}


//MARK: Collection View Flow Layout
extension ImageSearch: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 112, height: 112)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

//MARK: Empty Image Library Delegates
extension ImageSearch: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return list_of_images.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25)]
        return NSAttributedString(string: "No Results!", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: "Search for something to see a taggable image.", attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "no-image")
    }
}
