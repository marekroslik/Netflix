import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class FavoritesViewController: UIViewController {
    
    let favoritesView = FavoritesUIView()
    var viewModel: FavoritesViewModel!
    
    private let bag = DisposeBag()
    let updateFavorites = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(favoritesView)
        applyConstraints()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateFavorites.accept(())
    }
    
    private func bindViewModel() {
        let inputs = FavoritesViewModel.Input(
            loadingFavoritesMovies: updateFavorites.asObservable().do(onNext: { [self] _ in
                self.favoritesView.loading.isHidden = false
            }),
            favoritesMovieCellTrigger: favoritesView.table.rx.itemSelected.asObservable(),
            favoritesMoviesDeleteTrigger: favoritesView.table.rx.itemDeleted.asObservable()
        )
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.showFavoritesMovies.do(onNext: { _ in
            self.favoritesView.loading.isHidden = true
        }).drive(favoritesView.table.rx.items(
            cellIdentifier: CustomFavoritesTableViewCell.identifier,
            cellType: CustomFavoritesTableViewCell.self)) { (_, element, cell) in
                cell.loading.isHidden = false
                guard let posterPath = element.posterPath else { return }
                if let imageUrl = URL(string: "\(APIConstants.Api.urlImages)\(posterPath)") {
                    cell.image.sd_setImage(with: imageUrl, completed: { [cell] _, _, _, _ in
                        cell.loading.isHidden = true
                    })
                }
            }
            .disposed(by: bag)
        
        outputs.deleteFavoritesMovie
            .drive(onNext: { [updateFavorites] _ in
                updateFavorites.accept(())
            })
            .disposed(by: bag)
        
        outputs.showMovieInfo
            .drive()
            .disposed(by: bag)
    }
    
    private func applyConstraints() {
        favoritesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FavoritesViewController {
    enum Event {
        case movieDetails(model: MovieDetailsModel)
    }
}
