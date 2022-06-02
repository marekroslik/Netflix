import UIKit
import SnapKit

final class FavoritesUIView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // Cteate table
    private let table: UITableView = {
        let table = UITableView()
        table.register(CustomFavoritesTableViewCell.self, forCellReuseIdentifier: CustomFavoritesTableViewCell.identifier)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        createTableView()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(table)
    }
    
    // Configuration table function
    private func createTableView() {
        table.dataSource = self
        table.delegate = self
        table.rowHeight = 200
        table.backgroundColor = .black
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
    }
    
    // Set constatints
    private func applyConstraints() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Set settings functions
extension FavoritesUIView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomFavoritesTableViewCell.identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "DELETE") {_, _, _ in
        }
        return UISwipeActionsConfiguration(actions: [deleteButton])
        
    }
}
