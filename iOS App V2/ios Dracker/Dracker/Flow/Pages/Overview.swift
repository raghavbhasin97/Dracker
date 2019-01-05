import UIKit

class Overview: BaseViewController {

    let cellId = "OverviewCell"
    let emptyCellId = "EmptyOverviewCell"
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        label.text = "Summary"
        return label
    }()
    
    lazy var summaryTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.showsVerticalScrollIndicator = false
        table.register(OverviewCell.self, forCellReuseIdentifier: cellId)
        table.register(EmptyOverviewCell.self, forCellReuseIdentifier: emptyCellId)
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    fileprivate func setupTable() {
        view.addSubview(summaryTable)
        summaryTable.fillSuperview()
    }
    
    override func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        setupTable()
    }
}

extension Overview: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, overview.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if overview.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellId, for: indexPath)
            tableView.separatorStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OverviewCell
        cell.item = overview[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return overview.count == 0 ? 400 : UITableView.automaticDimension
    }
}

extension Overview: PhoneDelegate {
    func phoneUser(phone: String?) {
        if let phone = phone {
            let url = URL(string: "tel://\(phone)")!
            UIApplication.shared.open(url)
        }
    }
}
