import Foundation
import RxSwift
import RxCocoa

class PlayerViewModel: ViewModelType {
    
    struct Input {
        let closeViewTrigger: Observable<Void>
        let showVideoTrigger: Observable<Void>
    }
    
    struct Output {
        let closeView: Driver<Void>
        let showVideo: Driver<String>
    }
    
    var didSendEventClosure: ((PlayerViewController.Event) -> Void)?
    
    private let apiClient: APIClient
    private let movieId: Int
    
    init(apiClient: APIClient, movieId: Int) {
        self.apiClient = apiClient
        self.movieId = movieId
    }
    
    func transform(input: Input) -> Output {
        
        let closeView = input.closeViewTrigger
            .do(onNext: { [didSendEventClosure] _ in
                didSendEventClosure?(.close)
            }).asDriver(onErrorJustReturn: ())
        
        let showVideo = input.showVideoTrigger
                .flatMapFirst({ [apiClient, movieId] _ in
                    return apiClient.getVideo(id: movieId)
                })
                .map({ model in
                    guard let model = model.results else { return "" }
                    if model.isEmpty {
                        return ""
                    } else {
                        guard let key = model[0].key else { return "" }
                        return key
                    }
                }).asDriver(onErrorJustReturn: "")
                
                return Output(
                    closeView: closeView,
                    showVideo: showVideo
                )}
}
