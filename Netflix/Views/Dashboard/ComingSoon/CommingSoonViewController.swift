import UIKit
import RxSwift
import RxCocoa

final class ComingSoonViewController: UIViewController {
    
    private let comingSoonView = ComingSoonUIView()
    var viewModel: ComingSoonViewModel!
    
    private let bag = DisposeBag()
    let viewDidLoadRelay = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(comingSoonView)
        applyConstraints()
        bindViewModel()
        viewDidLoadRelay.accept(())
    }
    
    private func bindViewModel() {
        let inputs = ComingSoonViewModel.Input(
            loadingComingSoonMovies: viewDidLoadRelay.asObservable(),
            searchText: comingSoonView.searchTextField.rx.text.orEmpty.asObservable(),
            comingSoonMovieCellTrigger: comingSoonView.comingSoonCollectionView.rx.itemSelected.asObservable(),
            searchMovieCellTrigger: comingSoonView.searchMoviesCollectionView.rx.itemSelected.asObservable()
        )
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.showHideSearch
            .drive(comingSoonView.searchMoviesCollectionView.rx.isHidden)
            .disposed(by: bag)
        
        outputs.showComingSoonMovies.drive(comingSoonView.comingSoonCollectionView.rx.items(
            cellIdentifier: CustomComingSoonCollectionViewCell.identifier,
            cellType: CustomComingSoonCollectionViewCell.self)) { (_, element, cell) in
                if let poster = element.posterPath {
                    cell.imageView.downloaded(
                        from: "\(APIConstants.Api.urlImages)\(poster)",
                        loadingView: cell.loading)
                }
            }
            .disposed(by: bag)
        
        outputs.showComingSoonMovieInfo.drive().disposed(by: bag)
        
        outputs.showSearchMovies.drive(comingSoonView.searchMoviesCollectionView.rx.items(
            cellIdentifier: CustomComingSoonCollectionViewCell.identifier,
            cellType: CustomComingSoonCollectionViewCell.self)) { (_, element, cell) in
                if let poster = element.posterPath {
                    cell.imageView.downloaded(
                        from: "\(APIConstants.Api.urlImages)\(poster)",
                        loadingView: cell.loading)
                }
                
            }
            .disposed(by: bag)
        
        outputs.showSearchMovieInfo.drive().disposed(by: bag)
        
    }
    
    private func applyConstraints() {
        comingSoonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ComingSoonViewController {
    enum Event {
        case movieDetails(model: MovieDetailsModel)
    }
}
