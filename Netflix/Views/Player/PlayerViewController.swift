import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PlayerViewController: UIViewController {
    
    // Create view
    private let playerView = PlayerUIView()
    
    var viewModel: PlayerViewModel!
    
    private let bag = DisposeBag()
    let viewDidLoadRelay = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        bindViewModel()
        addAnimation()
        viewDidLoadRelay.accept(())
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    private func bindViewModel() {
        let inputs = PlayerViewModel.Input(
            closeViewTrigger: playerView.closeButton.rx.tap.asObservable(),
            showVideoTrigger: viewDidLoadRelay.asObservable())
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.closeView.drive().disposed(by: bag)
        
        outputs.showVideo.drive(onNext: { [playerView] youTubeKey in
            if youTubeKey.isEmpty {
                playerView.player.isHidden = true
                playerView.loading.isHidden = true
            } else {
                playerView.player.load(videoId: youTubeKey)
                playerView.loading.isHidden = true
            }
        }).disposed(by: bag)
    }
    
    private func addAnimation() {
        addButtonsAnimation(
            playerView.closeButton,
            disposeBag: bag
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(playerView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        playerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension PlayerViewController {
    enum Event {
        case close
    }
}
