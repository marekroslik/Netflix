import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import SDWebImage

final class HomeViewController: UIViewController {
    var viewModel: HomeViewModel!
    private let latestMovieView = HomeLatestMovieUIView()
    private let popularMoviesView = HomePopularMoviesUIView()
    private let viewLoading = LoadingUIView()
    
    private let bag = DisposeBag()
    private let updateAllData = PublishRelay<Void>()
    private var showPopularFooter: Bool = true
    private let dataSourcePopularMovies = RxCollectionViewSectionedAnimatedDataSource<PopularMoviesCellModel>(
        configureCell: { _, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomPopularMoviesCollectionViewCell.identifier,
                for: indexPath
            ) as? CustomPopularMoviesCollectionViewCell
            if model.favorites == true {
                cell?.shadowView.layer.shadowOpacity = 1
            } else {
                cell?.shadowView.layer.shadowOpacity = 0
            }
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
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        collectionSetUp()
        bindViewModel()
        addAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateAllData.accept(())
        popularMoviesView.popularMoviesCollectionView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
    }
    
    private func bindViewModel() {
        let inputs = HomeViewModel.Input(
            loadingLatestMovie: updateAllData.asObservable(),
            loadingPopularMovies: updateAllData.asObservable()
                .do { [weak self] _ in
                    self?.viewLoading.isHidden = false
                },
            playLatestMovieTrigger: latestMovieView.playButton.rx.tap.asObservable(),
            likeLatestMovieTrigger: latestMovieView.likeButton.rx.tap.asObservable(),
            showAccountTrigger: latestMovieView.accountButton.rx.tap.asObservable(),
            popularMovieCellTrigger: popularMoviesView.popularMoviesCollectionView.rx.itemSelected.asObservable(),
            popularMovieScrollTrigger: popularMoviesView.popularMoviesCollectionView.rx.willDisplayCell.asObservable()
        )
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.showLatestMovie
            .drive(onNext: { [latestMovieView] model in
                latestMovieView.filmName.text = model?.title ?? ""
                latestMovieView.loading.isHidden = false
                if let tags = model?.tagline {
                    if !tags.isEmpty {
                        latestMovieView.hashtags.text = tags.replacingOccurrences(of: ", ", with: " • ")
                    }
                }
                if let like = model?.favorites {
                    if like {
                        latestMovieView.likeButton.setImage(
                            UIImage(systemName: "heart.fill"),
                            for: .normal
                        )
                    } else {
                        latestMovieView.likeButton.setImage(
                            UIImage(systemName: "heart"),
                            for: .normal
                        )
                    }
                }
                guard let posterPath = model?.posterPath else { return }
                if let poster = URL(string: "\(APIConstants.Api.urlImages)\(posterPath)") {
                    latestMovieView.movieImage.sd_setImage(
                        with: poster,
                        completed: { [latestMovieView] _, error, _, _ in
                            if error == nil {
                                latestMovieView.loading.isHidden = false
                            } else {
                                latestMovieView.loading.isHidden = true
                            }
                        }
                    )
                }
            })
            .disposed(by: bag)
        
        outputs.showPopularMovies
            .do { [weak self] _ in
                self?.viewLoading.isHidden = true
            }
            .map { model in
                [PopularMoviesCellModel(title: "Popular movies", data: model)]
            }
            .drive(popularMoviesView.popularMoviesCollectionView.rx.items(dataSource: dataSourcePopularMovies))
            .disposed(by: bag)
        
        outputs.showPopularMovieInfo
            .drive()
            .disposed(by: bag)
        
        outputs.showAccount
            .drive()
            .disposed(by: bag)
        
        outputs.likeLatestMovie
            .drive(onNext: { [latestMovieView] bool in
                if bool {
                    latestMovieView.likeButton.setImage(
                        UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate),
                        for: .normal
                    )
                } else {
                    latestMovieView.likeButton.setImage(
                        UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate),
                        for: .normal
                    )
                }
            })
            .disposed(by: bag)
        
        outputs.playLatestMovie
            .drive()
            .disposed(by: bag)
        
        outputs.showPopularCollectionLoading
            .drive(onNext: { [weak self] bool in
                self?.showPopularFooter = bool
            })
            .disposed(by: bag)
    }
    
    private func addAnimation() {
        addButtonsAnimation(
            latestMovieView.playButton,
            latestMovieView.likeButton,
            latestMovieView.logoButton,
            latestMovieView.accountButton,
            disposeBag: bag
        )
    }
    
    private func addSubviews() {
        view.addSubview(latestMovieView)
        view.addSubview(popularMoviesView)
        view.addSubview(viewLoading)
    }
    
    private func applyConstraints() {
        latestMovieView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        popularMoviesView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        viewLoading.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func collectionSetUp() {
        popularMoviesView.popularMoviesCollectionView.delegate = self
        popularMoviesView.popularMoviesCollectionView.register(
            CustomPopularMoviesCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomPopularMoviesCollectionViewCell.identifier
        )
        popularMoviesView.popularMoviesCollectionView.register(
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
        case popularMoviesView.popularMoviesCollectionView:
            if showPopularFooter {
                return CGSize(
                    width: view.frame.width,
                    height: 100
                )
            } else {
                return .zero
            }
            
        default:
            return CGSize(
                width: 0,
                height: 0
            )
        }
    }
}

extension HomeViewController {
    enum Event {
        case movieDetails(model: MovieDetailsModel)
        case profile
        case showVideo(id: Int)
    }
}
