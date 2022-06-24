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
        viewModel.getFavoritesMovies(atPage: 1, withSessionId: UserDefaultsUseCase().sessionId!, bag: bag)
        getSearchMovies()
    }
    
    private func getSearchMovies() {
        self.viewModel.favoritesMovies
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] value in
                guard let self = self else { return }
                self.favoritesView.updateUITableView(with: value)
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

extension FavoritesViewController {
    enum Event {
        case movieDetails
    }
}
