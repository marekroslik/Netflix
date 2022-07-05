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
    
    init(model: MovieDetailsModel) {
        super.init(nibName: nil, bundle: nil)
        self.movieDetailsView.imageMovieDetails.downloaded(
            from: APIConstants.Api.urlImages + (model.posterPath ?? ""),
            loadingView: self.movieDetailsView.loading)
        self.movieDetailsView.movieTitle.text = model.title
        self.movieDetailsView.movieDuration.text = model.duration
        self.movieDetailsView.movieScore.text = model.score?.description
        self.movieDetailsView.releaseDateData.text = model.release
        self.movieDetailsView.synopsisData.text = model.synopsis
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
