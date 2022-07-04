import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
    
    func showMovieDetails(posterPath: String?, title: String?, duration: String?, score: Double?, release: String?, synopsis: String?)
    
    func closeMovieDetails()
}

class MainCoordinator: BaseCoordinator, MainCoordinatorProtocol {
    
    var tabBarController: UITabBarController
    
    var type: CoordinatorType { .main }
    
    required init(_ navigationController: UINavigationController) {
        self.tabBarController = .init()
        super.init(navigationController)
    }
    
    func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .comingSoon, .favorites]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    func showMovieDetails(posterPath: String?, title: String?, duration: String?, score: Double?, release: String?, synopsis: String?) {
        let movieDetails = MovieDetailsViewController(posterPath: posterPath,
                                                      title: title,
                                                      duration: duration,
                                                      score: score,
                                                      release: release,
                                                      synopsis: synopsis)
        movieDetails.modalPresentationStyle = .fullScreen
        movieDetails.viewModel = MovieDetailsViewModel()
        movieDetails.viewModel.didSendEventClosure = { [weak self] event in
            switch event {
            case .close:
                self?.closeMovieDetails()
            }
        }
        navigationController.present(movieDetails, animated: true)
    }
    
    func closeMovieDetails() {
        navigationController.dismiss(animated: true)
    }
    
    deinit {
        print("MainCoordinator deinit")
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        // Set delegate for UITabBarController
        tabBarController.delegate = self
        // Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        // Let set index
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        // Styling
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = .red
        tabBarController.tabBar.backgroundColor = .black
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        }
        
        // In this step, we attach tabBarController to navigation controller associated with this coordanator
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(
            title: page.pageTitleValue(),
            image: UIImage(systemName: page.pageIconValue()),
            tag: page.pageOrderNumber()
        )
        
        navController.tabBarItem.selectedImage = UIImage(systemName: page.pageSelectIconValue())
        
        switch page {
        case .home:
            // If needed: Each tab bar flow can have it's own Coordinator.
            let home = HomeViewController()
            home.viewModel = HomeViewModel(apiClient: APIClient())
            home.viewModel.didSendEventClosure = { [weak self] event in
                switch event {
                case .movieDetails(let index):
                    print(index)
//                    self?.showMovieDetails(posterPath: home.viewModel.cellsData?.results?[index].posterPath,
//                                           title: home.viewModel.cellsData?.results?[index].title,
//                                           duration: "0",
//                                           score: home.viewModel.cellsData?.results?[index].voteAverage,
//                                           release: home.viewModel.cellsData?.results?[index].releaseDate,
//                                           synopsis: home.viewModel.cellsData?.results?[index].overview)
                case .logout:
                    self?.finish()
                }
            }
            navController.pushViewController(home, animated: true)
            
        case .comingSoon:
            let comingSoon = ComingSoonViewController()
            comingSoon.viewModel = ComingSoonViewModel(apiClient: APIClient())
            comingSoon.viewModel.didSendEventClosure = { [weak self] event in
                switch event {
                case .movieDetails(let index):
                    if comingSoon.viewModel.cellsDataSearch == nil {
                        self?.showMovieDetails(posterPath: comingSoon.viewModel.cellsData?.results?[index].posterPath,
                                               title: comingSoon.viewModel.cellsData?.results?[index].title,
                                               duration: "0",
                                               score: comingSoon.viewModel.cellsData?.results?[index].voteAverage,
                                               release: comingSoon.viewModel.cellsData?.results?[index].releaseDate,
                                               synopsis: comingSoon.viewModel.cellsData?.results?[index].overview)
                    } else {
                        self?.showMovieDetails(posterPath: comingSoon.viewModel.cellsDataSearch?.results?[index].posterPath,
                                               title: comingSoon.viewModel.cellsDataSearch?.results?[index].title,
                                               duration: "0",
                                               score: comingSoon.viewModel.cellsDataSearch?.results?[index].voteAverage,
                                               release: comingSoon.viewModel.cellsDataSearch?.results?[index].releaseDate,
                                               synopsis: comingSoon.viewModel.cellsDataSearch?.results?[index].overview)
                    }
                    
                }
            }
            navController.pushViewController(comingSoon, animated: true)
            
        case .favorites:
            let favorites = FavoritesViewController()
            favorites.viewModel = FavoritesViewModel(apiClient: APIClient())
            favorites.viewModel.didSendEventClosure = { [weak self] event in
                switch event {
                case .movieDetails(let index):
                    self?.showMovieDetails(posterPath: favorites.viewModel.cellsData?.results?[index].posterPath,
                                           title: favorites.viewModel.cellsData?.results?[index].title,
                                           duration: "0",
                                           score: favorites.viewModel.cellsData?.results?[index].voteAverage,
                                           release: favorites.viewModel.cellsData?.results?[index].releaseDate,
                                           synopsis: favorites.viewModel.cellsData?.results?[index].overview)
                }
            }
            navController.pushViewController(favorites, animated: true)
        }
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
}

enum TabBarPage {
    case home
    case comingSoon
    case favorites
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .comingSoon
        case 2:
            self = .favorites
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .comingSoon:
            return "Coming Soon"
        case .favorites:
            return "Favorites"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .comingSoon:
            return 1
        case .favorites:
            return 2
        }
    }
    
    func pageIconValue() -> String {
        switch self {
        case .home:
            return "house"
        case .comingSoon:
            return "play.square"
        case .favorites:
            return "heart"
        }
    }
    
    func pageSelectIconValue() -> String {
        switch self {
        case .home:
            return "house.fill"
        case .comingSoon:
            return "play.square.fill"
        case .favorites:
            return "heart.fill"
        }
    }
}

// UITabBarControllerDelegate
extension MainCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}
