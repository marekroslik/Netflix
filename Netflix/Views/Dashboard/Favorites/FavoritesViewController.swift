import UIKit

final class FavoritesViewController: UIViewController {
    
    var didSendEventClosure: ((FavoritesViewController.Event) -> Void)?
    
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

extension FavoritesViewController {
    enum Event {
        case movieDetails
    }
}
