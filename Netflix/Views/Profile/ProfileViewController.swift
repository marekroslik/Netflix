import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    
    // Create view
    private let profileView = ProfileUIView()
    
    var viewModel: ProfileViewModel!
    
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
        let inputs = ProfileViewModel.Input(
            closeViewTrigger: profileView.exitButton.rx.tap.asObservable(),
            logoutTrigger: profileView.logoutButton.rx.tap.asObservable(),
            getInfo: viewDidLoadRelay.asObservable().do(onNext: { [self] _ in
                self.profileView.loadingView.isHidden = false
            }))
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.showInfo
            .drive(onNext: { [profileView] model in
                profileView.loadingView.isHidden = true
                if let name = model?.name {
                    profileView.nameLabel.text = name
                }
                if let username = model?.username {
                    profileView.mailLabel.text = username
                }
                profileView.loading.isHidden = false
                if let avatar = model?.avatar?.gravatar?.hash {
                    profileView.profileImage.sd_setImage(
                        with: URL(string: "\(APIConstants.Api.gravatarImage)\(avatar)\(APIConstants.ParamKeys.gravataRetro)"),
                        completed: { [profileView] _, _, _, _ in
                        profileView.loading.isHidden = true
                    })
                }
                
            })
            .disposed(by: bag)
        
        outputs.logout.drive().disposed(by: bag)
        
        outputs.closeView.drive().disposed(by: bag)
    }
    
    private func addAnimation() {
        addButtonsAnimation(
            profileView.exitButton,
            profileView.logoutButton,
            disposeBag: bag
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(profileView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ProfileViewController {
    enum Event {
        case close
        case logout
    }
}
