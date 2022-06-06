import UIKit

// Setup tab bar item
extension UITabBarItem {
    func setup(title: String, imageName: String, selectedImageName: String) {
        self.title = title
        self.image = UIImage(systemName: imageName)
        self.selectedImage = UIImage(systemName: selectedImageName)
    }
}
