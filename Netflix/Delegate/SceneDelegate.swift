import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            // Set initial controller
            window.rootViewController = MainTabBarViewController()

            // Uncomment to view other views. And go to the "PreviewViewController" file
//            window.rootViewController = PreviewViewController()
            // Uncomment to view OnBoarding view
//            window.rootViewController = OnBoardingViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
