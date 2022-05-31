import UIKit

class CommingSoonViewController: UIViewController {
    
    private let commingSoon = CommingSoonUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(commingSoon)
        navigationController?.isNavigationBarHidden = true
        applyConstraints()
    }
    
    private func applyConstraints() {
        commingSoon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
