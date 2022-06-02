import UIKit

final class ComingSoonViewController: UIViewController {
    
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
