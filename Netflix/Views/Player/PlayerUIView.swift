import UIKit
import SnapKit
import youtube_ios_player_helper_swift

final class PlayerUIView: UIView {
    
    let player = YTPlayerView()
    
    let loading = LoadingUIView()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let errorText: UILabel = {
        let label = UILabel()
        label.text = "Ooops, video not found"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label

    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(errorText)
        addSubview(player)
        addSubview(closeButton)
        addSubview(loading)
    }
    
    // Set constraints
    private func applyConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }
        
        player.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom)
        }
        
        errorText.snp.makeConstraints { make in
            make.edges.equalTo(player)
        }
        
        loading.snp.makeConstraints { make in
            make.edges.equalTo(player)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
