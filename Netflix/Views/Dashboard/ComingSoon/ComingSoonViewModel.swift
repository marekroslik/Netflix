import Foundation

class ComingSoonViewModel {
    var didSendEventClosure: ((ComingSoonViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}
