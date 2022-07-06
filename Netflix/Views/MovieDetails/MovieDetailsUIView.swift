import UIKit
import SnapKit

final class MovieDetailsUIView: UIView {
    
    // Create big image
    let imageMovieDetails: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let loading = LoadingUIView()
    
    // Create back button
    let topBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .red
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50), forImageIn: .normal)
        return button
    }()
    
    // Create like button
    let topLikeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .red
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
        return button
    }()
    
    // Create play button
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
    
    // Create movie title
    let movieTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    // Create duration image
    private let movieDurationImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "clock")
        image.tintColor = .lightGray
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // Create duration data
    let movieDuration: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    // Create score image
    private let movieScoreImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star.fill")
        image.tintColor = .lightGray
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // Create score data
    let movieScore: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    // Create release date label
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Release date"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    // Create release date data
    let releaseDateData: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    // Create synopsis label
    private let synopsisLabel: UILabel = {
        let label = UILabel()
        label.text = "Synopsis"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    // Create synopsis data
    let synopsisData: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    // Create first line
    private let firstline: UIView = {
        let line = UIView()
        line.backgroundColor = .darkGray.withAlphaComponent(0.5)
        return line
    }()
    
    // Create second line
    private let secondline: UIView = {
        let line = UIView()
        line.backgroundColor = .darkGray.withAlphaComponent(0.5)
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(imageMovieDetails)
        addSubview(loading)
        addSubview(topBackButton)
        addSubview(topLikeButton)
        addSubview(playButton)
        addSubview(movieTitle)
        addSubview(movieDurationImage)
        addSubview(movieDuration)
        addSubview(movieScoreImage)
        addSubview(movieScore)
        addSubview(releaseDateLabel)
        addSubview(releaseDateData)
        addSubview(synopsisLabel)
        addSubview(synopsisData)
        addSubview(firstline)
        addSubview(secondline)
    }
    
    // Set constatints
    private func applyConstraints() {
        
        imageMovieDetails.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview()
        }
        loading.snp.makeConstraints { make in
            make.edges.equalTo(imageMovieDetails)
        }
        
        topBackButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        topLikeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(30)
            make.height.width.equalTo(50)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageMovieDetails.snp.bottom).offset(-60)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        movieTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(10)
            make.top.equalTo(imageMovieDetails.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        movieDurationImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(movieTitle.snp.bottom)
            make.height.equalTo(20)
        }
        
        movieDuration.snp.makeConstraints { make in
            make.left.equalTo(movieDurationImage.snp.right).offset(5)
            make.centerY.equalTo(movieDurationImage)
            make.height.equalTo(20)
        }
        
        movieScoreImage.snp.makeConstraints { make in
            make.left.equalTo(movieDuration.snp.right).offset(20)
            make.centerY.equalTo(movieDuration)
            make.height.equalTo(20)
        }
        
        movieScore.snp.makeConstraints { make in
            make.left.equalTo(movieScoreImage.snp.right).offset(5)
            make.centerY.equalTo(movieScoreImage)
            make.height.equalTo(20)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(movieDurationImage.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        releaseDateData.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(releaseDateLabel.snp.bottom)
            make.height.equalTo(20)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(releaseDateData.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        synopsisData.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(synopsisLabel.snp.bottom)
            
        }
        
        firstline.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(releaseDateLabel.snp.top)
            make.height.equalTo(1)
        }
        
        secondline.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(synopsisLabel.snp.top)
            make.height.equalTo(1)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
