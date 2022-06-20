import Foundation

class MovieDetailsViewModel {
    func closeView(didSendEventClosure: ((MovieDetailsViewController.Event) -> Void)?) {
        didSendEventClosure?(.close)
    }
}
