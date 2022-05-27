import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    // Create view
    private let latestMovieView = HomeLatestMovieUIView()
    private let popularMovies = HomePopularMoviesUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        configNavBar()
        applyConstraints()
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
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = accountButtonBarItem
    }
    
    // Set Constraints
    private func applyConstraints() {
        latestMovieView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(popularMovies.snp.top)
        }
        popularMovies.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
}
