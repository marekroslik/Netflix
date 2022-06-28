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
        addCollectionViewData()
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
                self.showUpcomingMovies(with: value)
            } onError: { error in
                print(error)
            }.disposed(by: bag)
    }
    
    private func getSearchMovies() {
        self.viewModel.searchMovies
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] value in
                guard let self = self else { return }
                self.showSearchMovies(with: value)
            } onError: { error in
                print(error)
            }.disposed(by: bag)
    }
    
    private func checkSearchTextField() {
        self.comingSoon.searchTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                guard let text = self.comingSoon.searchTextField.text else { return }
                let textWithoutSpaces = text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
                if textWithoutSpaces.isEmpty {
                    print("isEmpty")
                    self.showDefaultData()
                } else {
                    print(text)
                    self.viewModel.getSearchMovies(atPage: 1, withTitle: textWithoutSpaces, bag: self.bag)
                }
            }).disposed(by: bag)
    }
}

extension ComingSoonViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func addCollectionViewData() {
        comingSoon.comingSoonCollectionView.dataSource = self
        comingSoon.comingSoonCollectionView.delegate = self
    }
    
    func showUpcomingMovies(with cellsData: UpcomingMoviesResponseModel) {
        viewModel.cellsData = cellsData
        comingSoon.comingSoonCollectionView.reloadData()
        comingSoon.comingSoonCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func showSearchMovies(with cellsDataSearch: SearchMoviesResponseModel) {
        viewModel.cellsDataSearch = cellsDataSearch
        comingSoon.comingSoonCollectionView.reloadData()
        comingSoon.comingSoonCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func showDefaultData() {
        viewModel.cellsDataSearch = nil
        comingSoon.comingSoonCollectionView.reloadData()
        comingSoon.comingSoonCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = viewModel.cellsDataSearch?.results?.count {
            return count
        }
        if let count = viewModel.cellsData?.results?.count {
            return count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomComingSoonCollectionViewCell.identifier, for: indexPath)
        if let cell = cell as? CustomComingSoonCollectionViewCell {
            if let posterPathSearch = viewModel.cellsDataSearch?.results?[indexPath.row].posterPath {
                cell.imageView.downloaded(from: "\(APIConstants.Api.urlImages)\(posterPathSearch)", loadingView: cell.loading)
                return cell
            }
            if let posterPath = viewModel.cellsData?.results?[indexPath.row].posterPath {
                cell.imageView.downloaded(from: "\(APIConstants.Api.urlImages)\(posterPath)", loadingView: cell.loading)
                return cell
            }
        }
        return cell
    }
}

extension ComingSoonViewController {
    enum Event {
        case movieDetails
    }
}
