import UIKit

// Custom collection cell for collection view
final class CustomPopularMoviesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomPopularMoviesCollectionViewCell"
    
    // Add image
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let shadowView: UIView = {
        let shadow = UIView()
        shadow.backgroundColor = .white
        shadow.layer.cornerRadius = 5
        return shadow
    }()
    
    let loading = LoadingUIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.addSubview(shadowView)
        contentView.addSubview(imageView)
        contentView.addSubview(loading)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.frame = CGRect(
            x: 5, y: 5,
            width: contentView.frame.size.width-10,
            height: contentView.frame.size.height-10
        )
        imageView.frame = CGRect(
            x: 5, y: 5,
            width: contentView.frame.size.width-10,
            height: contentView.frame.size.height-10
        )
        loading.frame = CGRect(
            x: 5, y: 5,
            width: contentView.frame.size.width-10,
            height: contentView.frame.size.height-10
        )
        
    }
}
