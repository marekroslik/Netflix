import UIKit

final class FavoritesViewController: UIViewController {
    
    let favoritesView = FavoritesUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(favoritesView)
        navigationController?.isNavigationBarHidden = true
        applyConstraints()
    }
    private func applyConstraints() {
        favoritesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
