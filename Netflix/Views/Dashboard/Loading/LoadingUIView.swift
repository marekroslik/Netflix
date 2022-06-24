import UIKit
import SnapKit
import Lottie

final class LoadingUIView: UIView {
    
    // Cteate big logo
    private let lottieLoading: AnimationView = {
        let lottie = AnimationView(name: "LottieSpinner")
        lottie.loopMode = .loop
        lottie.backgroundBehavior = .pauseAndRestore
        lottie.play()
        return lottie
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(lottieLoading)
    }
    
    // Set constraints
    private func applyConstraints() {
        lottieLoading.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
