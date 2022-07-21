import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class FavoritesViewController: UIViewController {
    
    private let favoritesView = FavoritesUIView()
    var viewModel: FavoritesViewModel!
    
    private let bag = DisposeBag()
    private let updateFavorites = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(favoritesView)
        tableSetup()
        applyConstraints()
        addAnimation()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFavorites.accept(())
        favoritesView.table.setContentOffset(.zero, animated: false)
    }
    
    private func bindViewModel() {
        let inputs = FavoritesViewModel.Input(
            loadingFavoritesMovies: updateFavorites.asObservable().do(onNext: { [self] _ in
                self.favoritesView.loading.isHidden = false
            }),
            favoritesMovieCellTrigger: favoritesView.table.rx.itemSelected.asObservable(),
            favoritesMoviesDeleteTrigger: favoritesView.table.rx.itemDeleted.asObservable(),
            switchToComingSoon: favoritesView.switchTabButton.rx.tap.asObservable(),
            trackFavoritesTableScrollTrigger: favoritesView.table.rx.willDisplayCell.asObservable()
        )
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.showFavoritesMovies.do(onNext: { [self] model in
            self.favoritesView.loading.isHidden = true
            if model == [] {
                self.favoritesView.table.isHidden = true
            } else {
                self.favoritesView.table.isHidden = false
            }
        }).drive(favoritesView.table.rx.items(
            cellIdentifier: CustomFavoritesTableViewCell.identifier,
            cellType: CustomFavoritesTableViewCell.self)) { (_, element, cell) in
                cell.loading.isHidden = false
                guard let posterPath = element.posterPath else {
                    cell.loading.isHidden = false
                    return
                }
                if let imageUrl = URL(string: "\(APIConstants.Api.urlImages)\(posterPath)") {
                    cell.image.sd_setImage(with: imageUrl, completed: { [cell] _, error, _, _ in
                        if error == nil {
                            cell.loading.isHidden = true
                        } else {
                            cell.loading.isHidden = false
                        }
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
        
        outputs.switchToComingSoon
            .drive()
            .disposed(by: bag)
        
        outputs.showTableLoading
            .drive(onNext: { [favoritesView] bool in
                favoritesView.table.tableFooterView = bool ? favoritesView.tableSpinner : UIView(frame: .zero)
            })
            .disposed(by: bag)
    }
    
    private func tableSetup() {
        favoritesView.table.refreshControl?.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        favoritesView.tableSpinner.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)
        favoritesView.table.tableFooterView = favoritesView.tableSpinner
        
    }
    
    @objc private func refreshControlTriggered() {
        updateFavorites.accept(())
        favoritesView.table.refreshControl?.endRefreshing()
    }
    
    private func addAnimation() {
        addButtonsAnimation(
            favoritesView.switchTabButton,
            disposeBag: bag
        )
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
        case comingSoon
    }
}
