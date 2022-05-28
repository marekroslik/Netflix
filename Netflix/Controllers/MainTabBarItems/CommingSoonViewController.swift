import UIKit

class CommingSoonViewController: UIViewController {
    
    private let loginView = LoginUIVIew()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(loginView)
        applyConstraints()
    }
    
    private func applyConstraints() {
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
