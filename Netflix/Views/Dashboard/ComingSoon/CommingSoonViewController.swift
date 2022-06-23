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
        getSearchMovies()
        checkSearchTextField()
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
    
    private func getSearchMovies() {
        self.viewModel.searchMovies
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] value in
                guard let self = self else { return }
                self.comingSoon.updateUICollectionView(with: value)
            } onError: { error in
                print(error)
            }.disposed(by: bag)
    }
    
    private func checkSearchTextField() {
        self.comingSoon.searchTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                guard let text = self.comingSoon.searchTextField.text else { return }
                let textWithoutSpaces = text.replacingOccurrences(of: " ", with: "")
                if textWithoutSpaces.isEmpty {
                    print("isEmpty")
                    self.comingSoon.showDefaultData()
                } else {
                    print(text)
                    self.viewModel.getSearchMovies(atPage: 1, withTitle: textWithoutSpaces, bag: self.bag)
                }
            }).disposed(by: bag)
    }
}

extension ComingSoonViewController {
    enum Event {
        case movieDetails
    }
}
