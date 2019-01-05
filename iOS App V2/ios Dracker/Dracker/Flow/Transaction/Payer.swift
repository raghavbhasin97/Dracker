import UIKit

protocol PayerSelectonDelegate {
    func didSelected(user: User)
    func didDissmiss()
}

class Payer: BaseViewController {

    fileprivate let cellId = "UserCell"
    fileprivate let emptyCellId = "EmptyUserCell"
    
    var phrase: String?
    var selectionDelegate: PayerSelectonDelegate?
    var users: [User] = []
    var filteredUsers: [User] = []
    var loadingComplete = false
    
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        label.text = "With Whom?"
        return label
    }()
    
    lazy var userView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.alwaysBounceVertical = true
        collection.showsVerticalScrollIndicator = false
        collection.keyboardDismissMode = .onDrag
        collection.register(UserCell.self, forCellWithReuseIdentifier: cellId)
        collection.register(EmptyUserCell.self, forCellWithReuseIdentifier: emptyCellId)
        return collection
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "Search users with Phone Number"
        search.backgroundColor = .themeLight
        search.showsCancelButton = false
        search.searchBarStyle = .minimal
        let textField = search.value(forKey: "searchField") as? UITextField
        textField?.textColor = .white
        return search
    }()
    
    
    lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .done, target: self, action: #selector(closePressed))
        return button
    }()
    
    fileprivate func setupUsersView() {
        view.addSubview(userView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: userView)
        userView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        userView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func setupSearch() {
        view.addSubview(searchBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
        setupSearch()
        setupUsersView()
        getUsers(params: ["phone": currentUser.phone]) {[unowned self] (users) in
            self.users = []
            users.forEach({ (user) in
                self.users.append(User(data: user))
            })
            self.filteredUsers = self.users
            self.userView.reloadData()
        }
    }
    
    @objc fileprivate func closePressed() {
        searchBar.resignFirstResponder()
        selectionDelegate?.didDissmiss()
        dismiss(animated: true, completion: nil)
    }
}

extension Payer: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(1, filteredUsers.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(filteredUsers.count == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath) as! EmptyUserCell
            cell.delegate = self
            if searchBar.isFocused {
                cell.noUsers()
            } else {
                cell.noResults(phrase ?? "")
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = filteredUsers.count == 0 ? 400.0 : 60.0
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.item]
        selectionDelegate?.didSelected(user: user)
        dismiss(animated: true, completion: nil)
    }
}


extension Payer: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            filteredUsers = users
            userView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let phrase = searchBar.text!
        self.phrase = phrase
        getUsers(params: ["search": phrase]) {[unowned self] (users) in
            var queriedUsers: [User] = []
            users.forEach({ (user) in
                let newUser = User(data: user)
                if newUser.phone != currentUser.phone {
                    queriedUsers.append(newUser)
                }
            })
            self.filteredUsers = queriedUsers
            self.userView.reloadData()
        }
    }
}

extension Payer: emptyCellAction {
    func performAction() {
        searchBar.resignFirstResponder()
        let share = UIActivityViewController(activityItems: ["Join Dracker", NSURL(string: "https://github.com/raghavbhasin97/Dracker") as Any ], applicationActivities: [])
        present(share, animated: true, completion: nil)
    }
    
}
