import UIKit
import RxSwift
import RxCocoa
import SDWebImage

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoadRelay.accept(())
    }
    
    private func bindViewModel() {
        let inputs = ComingSoonViewModel.Input(
            loadingComingSoonMovies: viewDidLoadRelay.asObservable().do(onNext: { [self] _ in
                self.comingSoonView.loading.isHidden = false
            }),
            searchText: comingSoonView.searchTextField.rx.text.orEmpty.asObservable(),
            comingSoonMovieCellTrigger: comingSoonView.comingSoonCollectionView.rx.itemSelected.asObservable(),
            searchMovieCellTrigger: comingSoonView.searchMoviesCollectionView.rx.itemSelected.asObservable()
        )
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.showHideComingSoon
            .drive(comingSoonView.comingSoonCollectionView.rx.isHidden)
            .disposed(by: bag)
        
        outputs.showComingSoonMovies.do(onNext: { [self] _ in
            self.comingSoonView.loading.isHidden = true
        }).drive(comingSoonView.comingSoonCollectionView.rx.items(
            cellIdentifier: CustomComingSoonCollectionViewCell.identifier,
            cellType: CustomComingSoonCollectionViewCell.self)) { (_, element, cell) in
                cell.loading.isHidden = false
                guard let posterPath = element.posterPath else { return }
                if let poster = URL(string: "\(APIConstants.Api.urlImages)\(posterPath)") {
                    cell.imageView.sd_setImage(
                        with: poster,
                        completed: { [cell] _, _, _, _ in
                        cell.loading.isHidden = true
                    })
                    if element.favorites == true {
                        cell.shadowView.layer.shadowOpacity = 1
                    } else {
                        cell.shadowView.layer.shadowOpacity = 0
                    }
                }
            }
            .disposed(by: bag)
        
        outputs.showComingSoonMovieInfo.drive().disposed(by: bag)
        
        outputs.showSearchMovies.do(onNext: { [comingSoonView] model in
            if model == [] {
                comingSoonView.searchMoviesCollectionView.isHidden = true
            } else {
                comingSoonView.searchMoviesCollectionView.isHidden = false
            }
        }).drive(comingSoonView.searchMoviesCollectionView.rx.items(
            cellIdentifier: CustomComingSoonCollectionViewCell.identifier,
            cellType: CustomComingSoonCollectionViewCell.self)) { (_, element, cell) in
                cell.loading.isHidden = false
                guard let posterPath = element.posterPath else { return }
                if let poster = URL(string: "\(APIConstants.Api.urlImages)\(posterPath)") {
                    cell.imageView.sd_setImage(with: poster, completed: { [cell] _, _, _, _ in
                        cell.loading.isHidden = true
                    })
                    if element.favorites == true {
                        cell.shadowView.layer.shadowOpacity = 1
                    } else {
                        cell.shadowView.layer.shadowOpacity = 0
                    }
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
