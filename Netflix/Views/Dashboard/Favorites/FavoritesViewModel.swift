import Foundation

class FavoritesViewModel {
    var didSendEventClosure: ((FavoritesViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}
