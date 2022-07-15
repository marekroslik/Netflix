import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SDWebImage

final class HomeViewController: UIViewController {
    var viewModel: HomeViewModel!
    
    private let latestMovieView = HomeLatestMovieUIView()
    private let popularMoviesView = HomePopularMoviesUIView()
    private let viewLoading = LoadingUIView()
    private var showPopularFooter: Bool = true
    
    private let bag = DisposeBag()
    let viewDidLoadRelay = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        collectionSetUp()
        bindViewModel()
        addAnimation()
        viewDidLoadRelay.accept(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoadRelay.accept(())
        popularMoviesView.popularMoviesCollectionView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
    }
    
    private func bindViewModel() {
        let inputs = HomeViewModel.Input(
            loadingLatestMovie: viewDidLoadRelay.asObservable(),
            loadingPopularMovies: viewDidLoadRelay.asObservable().do(onNext: { [self] _ in
                self.viewLoading.isHidden = false
            }),
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
                        latestMovieView
                            .likeButton
                            .setImage(
                                UIImage(systemName: "heart.fill"),
                                for: .normal)
                    } else {
                        latestMovieView
                            .likeButton
                            .setImage(
                                UIImage(systemName: "heart"),
                                for: .normal)
                    }
                }
                guard let posterPath = model?.posterPath else { return }
                if let poster = URL(string: "\(APIConstants.Api.urlImages)\(posterPath)") {
                    latestMovieView.movieImage.sd_setImage(
                        with: poster,
                        completed: { [latestMovieView] _, _, _, _ in
                            latestMovieView.loading.isHidden = true
                        }
                    )
                }
            })
            .disposed(by: bag)
        
        outputs.showPopularMovies
            .do(onNext: { [self] _ in
                self.viewLoading.isHidden = true
            })
            .drive(popularMoviesView.popularMoviesCollectionView.rx.items(
                cellIdentifier: CustomPopularMoviesCollectionViewCell.identifier,
                cellType: CustomPopularMoviesCollectionViewCell.self)) { (_, element, cell) in
                    cell.loading.isHidden = false
                    if let poster = URL(string: "\(APIConstants.Api.urlImages)\(element.posterPath!)") {
                        cell.imageView.sd_setImage(
                            with: poster,
                            completed: { [cell] _, _, _, _ in
                                cell.loading.isHidden = true
                            })
                    }
                    if element.favorites == true {
                        cell.shadowView.layer.shadowOpacity = 1
                    } else {
                        cell.shadowView.layer.shadowOpacity = 0
                    }
                }
                .disposed(by: bag)
        
        outputs.showMovieInfo
            .drive()
            .disposed(by: bag)
        
        outputs.showAccount
            .drive()
            .disposed(by: bag)
        
        outputs.likeLatestMovie
            .drive(onNext: { [latestMovieView] bool in
                if bool {
                    latestMovieView
                        .likeButton
                        .setImage(UIImage(systemName: "heart.fill")?
                            .withRenderingMode(.alwaysTemplate), for: .normal)
                } else {
                    latestMovieView
                        .likeButton
                        .setImage(UIImage(systemName: "heart")?
                            .withRenderingMode(.alwaysTemplate), for: .normal)
                }
                
            })
            .disposed(by: bag)
        
        outputs.playLatestMovie
            .drive()
            .disposed(by: bag)
        
        outputs.showTableLoading
            .drive(onNext: { [weak self] bool in
                guard let self = self else { return }
                self.showPopularFooter = bool
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
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        print("CREATE VIEW")
        if kind == UICollectionView.elementKindSectionFooter {
            print(popularMoviesView.popularMoviesCollectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FooterCollectionReusableView.identifier,
                for: indexPath
            ))
            return popularMoviesView.popularMoviesCollectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FooterCollectionReusableView.identifier,
                for: indexPath
            )
        }
        return UICollectionReusableView()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        if showPopularFooter {
            return CGSize(
                width: 100,
                height: popularMoviesView.popularMoviesCollectionView.frame.height
            )
        }
        return CGSize(width: 0, height: 0)
    }
}

extension HomeViewController {
    enum Event {
        case movieDetails(model: MovieDetailsModel)
        case profile
        case showVideo(id: Int)
    }
}
