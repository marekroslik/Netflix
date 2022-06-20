import UIKit
import SnapKit

final class MovieDetailsViewController: UIViewController {
    
    // Create view
    private let movieDetailsView = MovieDetailsUIView()
    
    var viewModel: MovieDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        closeView()
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(movieDetailsView)
    }
    
    func closeView() {
        movieDetailsView.topBackButton.addTarget(self, action: #selector(topBacButtonAction), for: .touchUpInside)
    }
    
    @objc func topBacButtonAction() {
        viewModel.closeView()
    }
    // Set Constraints
    private func applyConstraints() {
        movieDetailsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MovieDetailsViewController {
    enum Event {
        case close
    }
}
