import UIKit
import SnapKit

final class FavoritesUIView: UIView {
    
    // Cteate table
    let table: UITableView = {
        let table = UITableView()
        table.register(CustomFavoritesTableViewCell.self, forCellReuseIdentifier: CustomFavoritesTableViewCell.identifier)
        table.estimatedRowHeight = 200
        table.rowHeight = UITableView.automaticDimension
        let refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = .red
            return refreshControl
        }()
        table.refreshControl = refreshControl
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView(frame: .zero)
        return table
    }()
    
    let tableSpinner: UIView = {
        let view = UIView()
        let spinner = UIActivityIndicatorView()
        spinner.color = .red
        spinner.transform = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        view.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        spinner.startAnimating()
        return view
    }()
    
    let loading: LoadingUIView = {
        let view = LoadingUIView()
        view.isHidden = true
        return view
    }()
    
    private let switchTabText: UILabel = {
        let label = UILabel()
        label.text = "Ooops, movies not found"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let switchTabButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitle("Add movies", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        createTableView()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(switchTabText)
        addSubview(switchTabButton)
        addSubview(table)
        addSubview(loading)
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
        
        switchTabText.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(switchTabButton.snp.top)
        }
        
        switchTabButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
        }
        
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loading.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
