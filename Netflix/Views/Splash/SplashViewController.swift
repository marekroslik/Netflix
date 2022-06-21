import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController {
    
    // Create view
    private let splashView = SplashUIView()
    
    var viewModel: SplashViewModel!
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        
//        viewModel.getLatestMovie(bag: bag)
//        viewModel.getLPopularMovies(atPage: 1, bag: bag)
//        viewModel.getUpcomingMovies(atPage: 1, bag: bag)
//        viewModel.searchMovies(withTitle: "Spider", atPage: 1, bag: bag)
//        viewModel.getAccountDetails(withSessionId: "34a37ff87cb7f7e6b42951a0b68731972d5aee63", bag: bag)
//        viewModel.getFavoritesMovies(withAccountId: "", atPage: 1, bag: bag)
//        viewModel.markAsFavorite(model: MarkAsFavoritePostResponseModel(mediaType: "", mediaID: 1, favorite: true), withSessionId: "", bag: bag)
        
        viewModel.timer(bag: bag)
        
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(splashView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        splashView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension SplashViewController {
    enum Event {
        case login
        case main
    }
}
