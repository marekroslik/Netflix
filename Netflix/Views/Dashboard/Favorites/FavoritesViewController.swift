import UIKit
import RxSwift
import RxCocoa

final class FavoritesViewController: UIViewController {
    
    let favoritesView = FavoritesUIView()
    var viewModel: FavoritesViewModel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(favoritesView)
        navigationController?.isNavigationBarHidden = true
        applyConstraints()
        addTableViewData()
        viewModel.getFavoritesMovies(atPage: 1, withSessionId: UserDefaultsUseCase().sessionId!, bag: bag)
        getFavoritesMovies()
        getFavoritesMovieInfo()
    }
    
    private func getFavoritesMovies() {
        self.viewModel.favoritesMovies
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] value in
                guard let self = self else { return }
                self.updateUITableView(with: value)
            } onError: { error in
                print(error)
            }.disposed(by: bag)
    }
    
    private func applyConstraints() {
        favoritesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func addTableViewData() {
        favoritesView.table.dataSource = self
        favoritesView.table.delegate = self
    }
    
    func updateUITableView(with cellsData: FavoritesMoviesResponseModel) {
        viewModel.cellsData = cellsData
        favoritesView.table.reloadData()
    }
    
    func getFavoritesMovieInfo() {
        self.favoritesView.table.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.showMovieDetails(with: indexPath.row)
            }).disposed(by: bag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel.cellsData?.results?.count {
            return count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomFavoritesTableViewCell.identifier, for: indexPath)
        if let cell = cell as? CustomFavoritesTableViewCell {
            if let posterPathSearch = viewModel.cellsData?.results?[indexPath.row].posterPath {
                cell.image.downloaded(from: "\(APIConstants.Api.urlImages)\(posterPathSearch)", loadingView: cell.loading)
                return cell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "DELETE") {_, _, _ in
        }
        return UISwipeActionsConfiguration(actions: [deleteButton])
        
    }
}

extension FavoritesViewController {
    enum Event {
        case movieDetails(id: Int)
    }
}
