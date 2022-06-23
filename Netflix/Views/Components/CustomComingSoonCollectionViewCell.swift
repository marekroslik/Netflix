import UIKit

// Custom collection cell for collection view
final class CustomComingSoonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomComingSoonCollectionViewCell"
    
    // Add image
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let loading = LoadingUIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.addSubview(imageView)
        contentView.addSubview(loading)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        loading.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
    }
}
