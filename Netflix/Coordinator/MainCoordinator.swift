import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
    
    func showMovieDetails()
    
    func closeView()
}

class MainCoordinator: NSObject, MainCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController

    var type: CoordinatorType { .main }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }

    func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .comingSoon, .favorites]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    func showMovieDetails() {
        let presentView = MovieDetailsViewController()
        presentView.viewModel = MovieDetailsViewModel()
        presentView.didSendEventClosure = { [weak self] event in
            switch event {
            case .close:
                self?.closeView()
            }
        }
        navigationController.pushViewController(presentView, animated: true)
    }
    
    func closeView() {
        navigationController.popViewController(animated: true)
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
        
        // In this step, we attach tabBarController to navigation controller associated with this coordanator
        navigationController.viewControllers = [tabBarController]
    }
      
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)

        navController.tabBarItem = UITabBarItem.init(
            title: page.pageTitleValue(),
            image: UIImage(systemName: page.pageIconValue()),
            tag: page.pageOrderNumber()
        )
        
        navController.tabBarItem.selectedImage = UIImage(systemName: page.pageSelectIconValue())

        switch page {
        case .home:
            // If needed: Each tab bar flow can have it's own Coordinator.
            let readyVC = HomeViewController()
            readyVC.viewModel = HomeViewModel()
            readyVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .movieDetails:
                    self?.showMovieDetails()
                case .logout:
                    self?.finish()
                }
            }
            navController.pushViewController(readyVC, animated: true)
        
        case .comingSoon:
            let steadyVC = ComingSoonViewController()
            steadyVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .movieDetails:
                    self?.showMovieDetails()
                }
            }
            navController.pushViewController(steadyVC, animated: true)
        
        case .favorites:
            let goVC = FavoritesViewController()
            goVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .movieDetails:
                    self?.showMovieDetails()
                }
            }
            navController.pushViewController(goVC, animated: true)
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
