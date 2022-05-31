import UIKit
import SnapKit

class MoviewDetailsViewController: UIViewController {
    
    // Create view
    private let moviewDetailsView = MovieDetailsUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(moviewDetailsView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        moviewDetailsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
