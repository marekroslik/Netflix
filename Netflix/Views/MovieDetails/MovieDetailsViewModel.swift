import Foundation

class MovieDetailsViewModel {
    
    var didSendEventClosure: ((MovieDetailsViewController.Event) -> Void)?
    
    func closeView() {
        self.didSendEventClosure?(.close)
    }
}
