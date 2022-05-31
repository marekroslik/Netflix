import UIKit
import SnapKit

class SplashViewController: UIViewController {
    
    // Create view
    private let splashView = SplashUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(splashView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        splashView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
