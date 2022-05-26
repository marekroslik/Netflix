import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private let latestMovieView = HomeLatestMovieUIView()
    private let popularMovies = HomePopularMoviesUIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(latestMovieView)
        view.addSubview(popularMovies)
        configNavBar()
        applyConstraints()
    }
    private func applyConstraints() {
        latestMovieView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(popularMovies.snp.top)
        }
        popularMovies.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    private func configNavBar() {
        var imageLeft = Asset.smallLogoNetflix.image
        var imageRight = Asset.accountLogoNetflix.image
        imageLeft = imageLeft.withRenderingMode(.alwaysOriginal)
        imageRight = imageRight.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imageLeft, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageRight, style: .done, target: self, action: nil)
    }
}
