import UIKit
import SnapKit

final class HomeLatestMovieUIView: UIView {
    
    // Create latest movie IMAGE UI
    let movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let loading = LoadingUIView()
    
    // Create latest film GRADIENT UI
    private var gradientView = UIView()
    
    // Create latest film LIKE BUTTON UI (custom vertical button)
    let likeButton: UIVerticalButton = {
        let button = UIVerticalButton()
        button.setTitle("Like", for: .normal)
        button.setImage(UIImage(systemName: "heart"),
                        for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return button
    }()
    
    // Create latest film PLAY BUTTON UI
    let playButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Play", for: .normal)
        button.setImage(UIImage(systemName: "play.fill"),
                        for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return button
    }()
    
    // Create latest film NAME UI
    let filmName: UILabel = {
        let filmNameText = UILabel()
        filmNameText.numberOfLines = 0
        filmNameText.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        filmNameText.textAlignment = .center
        filmNameText.textColor = .white
        filmNameText.adjustsFontSizeToFitWidth = true
        return filmNameText
    }()
    
    // Create latest film HASHTAGS UI
    let hashtags: UILabel = {
        let hashtagsText = UILabel()
        hashtagsText.text = "Youth • Teen • Comedy • Drama • Gal Pals"
        hashtagsText.font = UIFont.systemFont(ofSize: 12)
        hashtagsText.textAlignment = .center
        hashtagsText.textColor = .white
        return hashtagsText
    }()
    
    let logoButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.smallLogoNetflix.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let accountButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.accountLogoNetflix.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
        addGradient()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(movieImage)
        addSubview(gradientView)
        addSubview(loading)
        addSubview(likeButton)
        addSubview(playButton)
        addSubview(hashtags)
        addSubview(filmName)
        addSubview(logoButton)
        addSubview(accountButton)
    }
    // Set constraints function
    private func applyConstraints() {
        
        // Latest movie image constraints
        movieImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        loading.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // Latest movie gradient constraints
        gradientView.snp.makeConstraints { make in
            make.edges.equalTo(movieImage)
        }
        
        // Latest movie like button constraints
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(movieImage).offset(25)
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        // Latest movie play button constraints
        playButton.snp.makeConstraints { make in
            make.bottom.equalTo(movieImage).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        // Latest movie name constraints
        filmName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(hashtags)
            make.width.equalTo(movieImage).multipliedBy(0.8)
            make.height.equalTo(200)
        }
        
        // Latest movie hashtags constraints
        hashtags.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(playButton).offset(-60)
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
        }
        
        logoButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        accountButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
    }
    
    // Add gradient to gradient view function
    private func addGradient() {
        let startColor = UIColor.clear.cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let gradientTop = CAGradientLayer()
        gradientTop.frame = CGRect(x: 0, y: 0,
                                   width: UIScreen.main.bounds.width,
                                   height: UIScreen.main.bounds.height * 0.6)
        let gradientBottom = CAGradientLayer()
        gradientBottom.frame = CGRect(x: 0, y: 0,
                                      width: UIScreen.main.bounds.width,
                                      height: UIScreen.main.bounds.height * 0.6)
        gradientTop.colors = [endColor, startColor, startColor]
        gradientBottom.colors = [startColor, startColor, endColor]
        gradientView.layer.addSublayer(gradientTop)
        gradientView.layer.addSublayer(gradientBottom)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
