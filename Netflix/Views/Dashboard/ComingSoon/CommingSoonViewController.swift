import UIKit

final class ComingSoonViewController: UIViewController {
    
    private let comingSoon = ComingSoonUIView()
    var viewModel: ComingSoonViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(comingSoon)
        navigationController?.isNavigationBarHidden = true
        applyConstraints()
    }
    
    private func applyConstraints() {
        comingSoon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ComingSoonViewController {
    enum Event {
        case movieDetails
    }
}
