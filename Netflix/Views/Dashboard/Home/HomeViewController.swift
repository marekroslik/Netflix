import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!
    
    // Create view
    private let latestMovieView = HomeLatestMovieUIView()
    private let popularMovies = HomePopularMoviesUIView()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        configNavBar()
        applyConstraints()
        addCollectionViewData()
        viewModel.getLatestMovie(bag: bag)
        viewModel.getLPopularMovies(atPage: 1, bag: bag)
        getLatestMovie()
        getPopularMovie()
        getPopularMovieInfo()
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(latestMovieView)
        view.addSubview(popularMovies)
    }
    
    // Customize navigation bar
    private func configNavBar() {
        
        // Create Netlifx logo (left navigation button)
        let logoButton = UIButton(type: .custom)
        // Set ftame size
        logoButton.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 35)
        // Set asset
        logoButton.setImage(Asset.smallLogoNetflix.image, for: .normal)
        let logoBarItem = UIBarButtonItem(customView: logoButton)
        // Set constraints
        let currentWidth = logoBarItem.customView?.widthAnchor.constraint(equalToConstant: 20)
        currentWidth?.isActive = true
        let currentHeight = logoBarItem.customView?.heightAnchor.constraint(equalToConstant: 35)
        currentHeight?.isActive = true
        // Add button to navigation bar
        navigationItem.leftBarButtonItem = logoBarItem
        
        // Create account button (right navigation button)
        let accountButton = UIButton(type: .custom)
        // Set size
        accountButton.frame = CGRect(x: 0.0, y: 0.0, width: 35, height: 35)
        // Set asset
        accountButton.setImage(Asset.accountLogoNetflix.image, for: .normal)
        let  accountButtonBarItem = UIBarButtonItem(customView: accountButton)
        // Set constraints
        let currentWidth2 = accountButtonBarItem.customView?.widthAnchor.constraint(equalToConstant: 35)
        currentWidth2?.isActive = true
        let currentHeight2 = accountButtonBarItem.customView?.heightAnchor.constraint(equalToConstant: 35)
        currentHeight2?.isActive = true
        
        accountButton.addTarget(self, action: #selector(accountButtonAction), for: .touchUpInside)
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = accountButtonBarItem
    }
    
    @objc func accountButtonAction(sender: UIButton!) {
        viewModel.logOut()
    }
    
    // Set Constraints
    private func applyConstraints() {
        latestMovieView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        popularMovies.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    private func getLatestMovie() {
        self.viewModel.latestMovie
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] value in
                guard let self = self else { return }
                if let poster = value.posterPath {
                    self.latestMovieView.movieImage.downloaded(
                        from: "\(APIConstants.Api.urlImages)\(poster)",
                        loadingView: self.latestMovieView.loading)
                }
                print(value.posterPath ?? "Poster path = nil")
                self.latestMovieView.filmName.text = value.title
            } onError: { error in
                print(error)
            }.disposed(by: bag)
    }
    
    private func getPopularMovie() {
        self.viewModel.popularMovie
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] value in
                guard let self = self else { return }
                self.updateUICollectionView(with: value)
            } onError: { error in
                print(error)
            }.disposed(by: bag)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func addCollectionViewData() {
        popularMovies.popularMoviesCollectionView?.dataSource = self
        popularMovies.popularMoviesCollectionView?.delegate = self
    }
    
    func updateUICollectionView(with cellsData: PopularMoviesResponseModel) {
        viewModel.cellsData = cellsData
        popularMovies.popularMoviesCollectionView?.reloadData()
    }
    
    func getPopularMovieInfo() {
        popularMovies.popularMoviesCollectionView?.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.showMovieDetails(with: indexPath.row)
                print(self?.viewModel.cellsData?.results?[indexPath.row].title ?? "")
            }).disposed(by: bag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = viewModel.cellsData?.results?.count {
            return count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomPopularMoviesCollectionViewCell.identifier, for: indexPath)
        if let cell = cell as? CustomPopularMoviesCollectionViewCell {
            if let posterPath = viewModel.cellsData?.results?[indexPath.row].posterPath {
                cell.imageView.downloaded(from: "\(APIConstants.Api.urlImages)\(posterPath)", loadingView: cell.loading)
            }
        }
        return cell
    }
}

extension HomeViewController {
    enum Event {
        case movieDetails(id: Int)
        case logout
    }
}
