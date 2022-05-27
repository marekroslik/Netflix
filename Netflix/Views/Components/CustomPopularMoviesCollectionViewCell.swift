import UIKit

// Custom collection cell for collection view
class CustomPopularMoviesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomPopularMoviesCollectionViewCell"
    
    // Add image
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.latestMovieNetflix.image
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
    }
}
