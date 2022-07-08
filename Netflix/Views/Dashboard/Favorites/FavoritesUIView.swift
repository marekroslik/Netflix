import UIKit
import SnapKit

final class FavoritesUIView: UIView {
    
    // Cteate table
    let table: UITableView = {
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
        table.rowHeight = 200
        table.backgroundColor = .black
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
    }
    
    // Set constantints
    private func applyConstraints() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
