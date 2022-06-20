import UIKit

final class ComingSoonViewController: UIViewController {
    
    var didSendEventClosure: ((ComingSoonViewController.Event) -> Void)?
    private let comingSoon = ComingSoonUIView()
    
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
