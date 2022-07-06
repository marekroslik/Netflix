import Foundation
import RxSwift
import RxCocoa

class MovieDetailsViewModel: ViewModelType {
    struct Input {
        let closeViewTrigger: Observable<Void>
        let getMovieInfo: Observable<Void>
    }
    
    struct Output {
        let closeView: Driver<Void>
        let showMovieInfo: Driver<MovieDetailsModel?>
    }
    
    var didSendEventClosure: ((MovieDetailsViewController.Event) -> Void)?
    
    private let model: MovieDetailsModel
    
    init(model: MovieDetailsModel) {
        self.model = model
    }
    
    func transform(input: Input) -> Output {
        
        let closeView = input.closeViewTrigger
            .map({ [didSendEventClosure] _ in
                didSendEventClosure?(.close)
                return ()
            })
            .asDriver(onErrorJustReturn: ())
        
        let showMovieInfo = input.getMovieInfo
            .flatMapLatest({ [model] _ -> Observable<MovieDetailsModel> in
                return Observable.just(model)
            })
            .map { $0 as MovieDetailsModel }
            .asDriver(onErrorJustReturn: nil)
        
        return Output(
            closeView: closeView,
            showMovieInfo: showMovieInfo
        )
    }
}
