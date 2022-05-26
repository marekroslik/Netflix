import UIKit
import SnapKit

class HomeLatestMovieUIView: UIView {
    private let movieImage: UIImageView = {
        let image = UIImageView()
        image.image = Asset.latestMovieNetflix.image
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let filmName: UILabel = {
        let filmNameText = UILabel()
        filmNameText.text = "Never Have I Ever"
        filmNameText.numberOfLines = 2
        filmNameText.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        filmNameText.textAlignment = .center
        filmNameText.textColor = .white
        return filmNameText
    }()
    private let hashtags: UILabel = {
        let hashtagsText = UILabel()
        hashtagsText.text = "Quirky • Youth • Teen • Comedy • Drama • Gal Pals"
        hashtagsText.font = UIFont.systemFont(ofSize: 12)
        hashtagsText.textAlignment = .center
        hashtagsText.textColor = .white
        return hashtagsText
    }()
    private let playButton: UIButton = {
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
    private let likeButton: UIVerticalButton = {
        let button = UIVerticalButton()
        button.setTitle("Like", for: .normal)
        button.setImage(UIImage(systemName: "heart"),
                        for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return button
    }()
    private var gradientView: UIView = {
        let gradient = UIView()
        return gradient
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(movieImage)
        addSubview(gradientView)
        addSubview(likeButton)
        addSubview(playButton)
        addSubview(filmName)
        addSubview(hashtags)
        applyConstraints()
        addGradient()
    }
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
    private func applyConstraints() {
        movieImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        gradientView.snp.makeConstraints { make in
            make.edges.equalTo(movieImage)
        }
        playButton.snp.makeConstraints { make in
            make.bottom.equalTo(movieImage).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(movieImage).offset(25)
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        hashtags.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(playButton).offset(-60)
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
        }
        filmName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(hashtags)
            make.width.equalTo(movieImage).multipliedBy(0.8)
            make.height.equalTo(200)
        }
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
