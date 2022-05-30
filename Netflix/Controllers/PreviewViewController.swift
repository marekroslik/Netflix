import UIKit
import SnapKit

class PreviewViewController: UIViewController {
    
    // Create view
    // Uncomment to view other views.
//    private let mainView = SplashUIView()
    private let mainView = OnBoardingUIView()
//    private let mainView = LoginUIVIew()
//    private let mainView = MovieDetailsUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(mainView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
