import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SDWebImage

final class MovieDetailsViewController: UIViewController {
    
    // Create view
    private let movieDetailsView = MovieDetailsUIView()
    
    var viewModel: MovieDetailsViewModel!
    
    private let bag = DisposeBag()
    let viewDidLoadRelay = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        bindViewModel()
        addAnimation()
        viewDidLoadRelay.accept(())
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    private func bindViewModel() {
        let inputs = MovieDetailsViewModel.Input(
            closeViewTrigger: movieDetailsView.topBackButton.rx.tap.asObservable(),
            getMovieInfo: viewDidLoadRelay.asObservable(),
            setAsFavoriteTrigger: movieDetailsView.topLikeButton.rx.tap.asObservable())
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.showMovieInfo
            .drive(onNext: { [movieDetailsView] model in
                movieDetailsView.loading.isHidden = false
                guard let posterPath = model?.posterPath else { return }
                movieDetailsView.imageMovieDetails.sd_setImage(
                    with: URL(string: "\(APIConstants.Api.urlImages)\(posterPath)"),
                    completed: { [movieDetailsView] _, _, _, _ in
                        movieDetailsView.loading.isHidden = true
                    })
                movieDetailsView.movieTitle.text = model?.title
                movieDetailsView.movieDuration.text = model?.duration
                movieDetailsView.movieScore.text = model?.score?.description
                movieDetailsView.releaseDateData.text = model?.release
                movieDetailsView.synopsisData.text = model?.synopsis
                
            })
            .disposed(by: bag)
        
        outputs.setAsFavorite.drive(onNext: { [movieDetailsView] _ in
            movieDetailsView.topLikeButton.setImage(
                UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate),
                for: .normal
            )
        }).disposed(by: bag)
        
        outputs.closeView.drive().disposed(by: bag)
    }
    
    private func addAnimation() {
        addButtonsAnimation(
            movieDetailsView.topBackButton,
            movieDetailsView.topLikeButton,
            disposeBag: bag
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(movieDetailsView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        movieDetailsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MovieDetailsViewController {
    enum Event {
        case close
    }
}
