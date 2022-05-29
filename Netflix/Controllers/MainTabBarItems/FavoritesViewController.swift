import UIKit

class FavoritesViewController: UIViewController {
    
    let favoritesView = FavoritesUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(favoritesView)
        self.navigationController?.isNavigationBarHidden = true
        applyConstraints()
    }
    private func applyConstraints() {
        favoritesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
