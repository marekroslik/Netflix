import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    // Create view
    private let loginView = LoginUIVIew()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
    }

    // Move view when keyboard is shown
    override func viewWillAppear(_ animated: Bool) {
            self.addKeyboardObserver()
        }

        override func viewWillDisappear(_ animated: Bool) {
            self.removeKeyboardObserver()
        }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(loginView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
