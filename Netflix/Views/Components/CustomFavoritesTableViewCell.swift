import UIKit

class CustomFavoritesTableViewCell: UITableViewCell {
    
    static let identifier = "CustomFavoritesTableViewCell"
    
    // Add image
    private let image: UIImageView = {
        let image = UIImageView()
        image.image = Asset.latestMovieNetflix.image
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image)
        self.backgroundColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.frame = CGRect(x: 5, y: 5, width: 380, height: contentView.frame.size.height - 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
