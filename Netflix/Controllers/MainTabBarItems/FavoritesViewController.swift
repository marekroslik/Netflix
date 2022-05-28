import UIKit

class FavoritesViewController: UIViewController {
    
    let onBoarding = OnBoardingUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(onBoarding)
        applyConstraints()
    }
    private func applyConstraints() {
        onBoarding.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
