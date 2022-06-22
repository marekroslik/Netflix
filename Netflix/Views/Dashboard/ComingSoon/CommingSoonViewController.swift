import UIKit
import RxSwift
import RxCocoa

final class ComingSoonViewController: UIViewController {
    
    private let comingSoon = ComingSoonUIView()
    var viewModel: ComingSoonViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(comingSoon)
        navigationController?.isNavigationBarHidden = true
        applyConstraints()
        viewModel.getUpcomingMovies(atPage: 1, bag: bag)
        getUpcomingMovies()
    }
    
    private func applyConstraints() {
        comingSoon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getUpcomingMovies() {
        self.viewModel.comingSoon
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] value in
                guard let self = self else { return }
                self.comingSoon.updateUICollectionView(with: value)
            } onError: { error in
                print(error)
            }.disposed(by: bag)
    }
}

extension ComingSoonViewController {
    enum Event {
        case movieDetails
    }
}
