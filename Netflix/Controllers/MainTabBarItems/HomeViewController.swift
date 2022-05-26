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
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 35)
        menuBtn.setImage(Asset.smallLogoNetflix.image, for: .normal)
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 35)
        currHeight?.isActive = true
        navigationItem.leftBarButtonItem = menuBarItem
        let menuBtn2 = UIButton(type: .custom)
        menuBtn2.frame = CGRect(x: 0.0, y: 0.0, width: 35, height: 35)
        menuBtn2.setImage(Asset.accountLogoNetflix.image, for: .normal)
        let menuBarItem2 = UIBarButtonItem(customView: menuBtn2)
        let currWidth2 = menuBarItem2.customView?.widthAnchor.constraint(equalToConstant: 35)
        currWidth2?.isActive = true
        let currHeight2 = menuBarItem2.customView?.heightAnchor.constraint(equalToConstant: 35)
        currHeight2?.isActive = true
        navigationItem.rightBarButtonItem = menuBarItem2
    }
}
