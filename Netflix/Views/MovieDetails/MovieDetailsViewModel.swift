import Foundation
import RxSwift
import RxCocoa

class MovieDetailsViewModel: ViewModelType {
    struct Input {
        let closeViewTrigger: Observable<Void>
        let getMovieInfo: Observable<Void>
        let setAsFavoriteTrigger: Observable<Void>
    }
    
    struct Output {
        let closeView: Driver<Void>
        let showMovieInfo: Driver<MovieDetailsModel?>
        let setAsFavorite: Driver<Void>
    }
    
    var didSendEventClosure: ((MovieDetailsViewController.Event) -> Void)?
    private let model: MovieDetailsModel
    private let apiClient: APIClient
    private let userDefaultsUseCase: UserDefaultsUseCase
    
    init(model: MovieDetailsModel, apiClient: APIClient, userDefaultsUseCase: UserDefaultsUseCase) {
        self.model = model
        self.apiClient = apiClient
        self.userDefaultsUseCase = userDefaultsUseCase
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
        
        let setAsFavorite = input.setAsFavoriteTrigger
            .flatMapLatest({ [apiClient, model, userDefaultsUseCase] _ -> Observable<MarkAsFavoriteResponseModel> in
                return apiClient.markAsFavorite(model: MarkAsFavoritePostResponseModel(
                    mediaType: "movie",
                    mediaID: model.id,
                    favorite: true
                ), withSessionId: userDefaultsUseCase.sessionId!)
            })
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            closeView: closeView,
            showMovieInfo: showMovieInfo,
            setAsFavorite: setAsFavorite
        )
    }
}
