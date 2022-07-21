import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SDWebImage

final class ComingSoonViewController: UIViewController {
    private let comingSoonView = ComingSoonUIView()
    var viewModel: ComingSoonViewModel!
    
    private let bag = DisposeBag()
    let viewDidLoadRelay = PublishRelay<Void>()
    private var showComingSoonFooter: Bool = true
    private var showSearchFooter: Bool = true
    private let dataSourceComingSoon = RxCollectionViewSectionedAnimatedDataSource<ComingSoonCellModel>(
        configureCell: { _, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomComingSoonCollectionViewCell.identifier,
                for: indexPath
            ) as? CustomComingSoonCollectionViewCell
            cell?.shadowView.layer.shadowOpacity = model.favorites ? 1 : 0
            guard let posterPath = model.posterPath else {
                cell?.loading.isHidden = false
                return cell ?? UICollectionViewCell(frame: .zero)
            }
            if let poster = URL(string: "\(APIConstants.Api.urlImages)\(posterPath)") {
                cell?.imageView.sd_setImage(
                    with: poster,
                    completed: { [cell] _, error, _, _ in
                        if error == nil {
                            cell?.loading.isHidden = true
                        } else {
                            cell?.loading.isHidden = false
                        }
                    }
                )
            }
            return cell ?? UICollectionViewCell(frame: .zero)
        },
        configureSupplementaryView: { _, collectionView, kind, indexPath in
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FooterCollectionReusableView.identifier,
                for: indexPath
            ) as? FooterCollectionReusableView
            return footer ?? UICollectionReusableView(frame: .zero)
        }
    )
    
    private let dataSourceSearchMovies = RxCollectionViewSectionedAnimatedDataSource<SearchMoviesCellModel>(
        configureCell: { _, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomComingSoonCollectionViewCell.identifier,
                for: indexPath
            ) as? CustomComingSoonCollectionViewCell
            cell?.shadowView.layer.shadowOpacity = model.favorites ? 1 : 0
            guard let posterPath = model.posterPath else {
                cell?.loading.isHidden = false
                return cell ?? UICollectionViewCell(frame: .zero)
            }
            if let poster = URL(string: "\(APIConstants.Api.urlImages)\(posterPath)") {
                cell?.imageView.sd_setImage(
                    with: poster,
                    completed: { [cell] _, error, _, _ in
                        if error == nil {
                            cell?.loading.isHidden = true
                        } else {
                            cell?.loading.isHidden = false
                        }
                    }
                )
            }
            return cell ?? UICollectionViewCell(frame: .zero)
        },
        configureSupplementaryView: { _, collectionView, kind, indexPath in
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FooterCollectionReusableView.identifier,
                for: indexPath
            ) as? FooterCollectionReusableView
            return footer ?? UICollectionReusableView(frame: .zero)
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(comingSoonView)
        applyConstraints()
        collectionSetup()
        bindViewModel()
        viewDidLoadRelay.accept(())
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoadRelay.accept(())
        comingSoonView.comingSoonCollectionView.setContentOffset(.zero, animated: false)
        comingSoonView.searchMoviesCollectionView.setContentOffset(.zero, animated: false)
    }
    
    private func bindViewModel() {
        let inputs = ComingSoonViewModel.Input(
            loadingComingSoonMovies: viewDidLoadRelay.asObservable().do(onNext: { [self] _ in
                self.comingSoonView.loading.isHidden = false
            }),
            searchText: comingSoonView.searchTextField.rx.text.orEmpty.asObservable(),
            comingSoonMovieCellTrigger: comingSoonView.comingSoonCollectionView.rx.itemSelected.asObservable(),
            searchMovieCellTrigger: comingSoonView.searchMoviesCollectionView.rx.itemSelected.asObservable(),
            comingSoonMovieScrollTrigger: comingSoonView.comingSoonCollectionView.rx.willDisplayCell.asObservable(),
            searchMovieScrollTrigger: comingSoonView.searchMoviesCollectionView.rx.willDisplayCell.asObservable()
        )
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.showHideComingSoon
            .drive(comingSoonView.comingSoonCollectionView.rx.isHidden)
            .disposed(by: bag)
        
        outputs.showComingSoonMovies
            .do { [self] _ in
                self.comingSoonView.loading.isHidden = true
            }
            .map { model in
                [ComingSoonCellModel(title: "Coming soon", data: model)]
            }
            .drive(comingSoonView.comingSoonCollectionView.rx.items(dataSource: dataSourceComingSoon))
            .disposed(by: bag)
        
        outputs.showComingSoonMovieInfo.drive().disposed(by: bag)
        
        outputs.showSearchMovies
            .do { [comingSoonView] model in
                if model == [] {
                    comingSoonView.searchMoviesCollectionView.isHidden = true
                } else {
                    comingSoonView.searchMoviesCollectionView.isHidden = false
                }
            }
            .map { model in
                [SearchMoviesCellModel(title: "Search movies", data: model)]
            }
            .drive(comingSoonView.searchMoviesCollectionView.rx.items(dataSource: dataSourceSearchMovies))
            .disposed(by: bag)
        
        outputs.showSearchMovieInfo.drive().disposed(by: bag)
        
        outputs.showComingSoonCollectionLoading
            .drive(onNext: { [weak self] bool in
                self?.showComingSoonFooter = bool
            })
            .disposed(by: bag)
        
        outputs.showSearchCollectionLoading
            .drive(onNext: { [weak self] bool in
                self?.showSearchFooter = bool
            })
            .disposed(by: bag)
    }
    
    private func applyConstraints() {
        comingSoonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ComingSoonViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func collectionSetup() {
        comingSoonView.comingSoonCollectionView.delegate = self
        comingSoonView.comingSoonCollectionView.register(
            CustomComingSoonCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomComingSoonCollectionViewCell.identifier
        )
        comingSoonView.comingSoonCollectionView.register(
            FooterCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterCollectionReusableView.identifier
        )
        
        comingSoonView.searchMoviesCollectionView.delegate = self
        comingSoonView.searchMoviesCollectionView.register(
            CustomComingSoonCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomComingSoonCollectionViewCell.identifier
        )
        comingSoonView.searchMoviesCollectionView.register(
            FooterCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterCollectionReusableView.identifier
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        switch collectionView {
        case comingSoonView.comingSoonCollectionView:
            if showComingSoonFooter {
                return CGSize(
                    width: view.frame.width,
                    height: 100
                )
            } else {
                return .zero
            }
            
        case comingSoonView.searchMoviesCollectionView:
            if showComingSoonFooter {
                return CGSize(
                    width: view.frame.width,
                    height: 100
                )
            } else {
                return .zero
            }
            
        default:
            return .zero
        }
    }
}

extension ComingSoonViewController {
    enum Event {
        case movieDetails(model: MovieDetailsModel)
    }
}
