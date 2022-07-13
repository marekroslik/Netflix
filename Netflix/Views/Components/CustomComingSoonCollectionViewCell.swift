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
    
    let shadowView: UIView = {
        let shadow = UIView()
        shadow.backgroundColor = .white
        shadow.clipsToBounds = false
        shadow.layer.shadowColor = UIColor.red.cgColor
        shadow.layer.shadowOffset = .zero
        shadow.layer.shadowRadius = 5.0
        shadow.layer.shadowOpacity = 1
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
        shadowView.frame = CGRect(
            x: 5, y: 5,
            width: contentView.frame.size.width-10,
            height: contentView.frame.size.height-10)
    }
}
