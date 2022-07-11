import Foundation
import RxSwift
import RxCocoa

class FavoritesViewModel: ViewModelType {
    
    struct Input {
        let loadingFavoritesMovies: Observable<Void>
        let favoritesMovieCellTrigger: Observable<IndexPath>
        let favoritesMoviesDeleteTrigger: Observable<IndexPath>
        let switchToComingSoon: Observable<Void>
    }
    
    struct Output {
        let showFavoritesMovies: Driver<[FavoritesMoviesResponseModel.Result]>
        let deleteFavoritesMovie: Driver<Void>
        let showMovieInfo: Driver<Void>
        let switchToComingSoon: Driver<Void>
    }
    
    var didSendEventClosure: ((FavoritesViewController.Event) -> Void)?
    private let apiClient: APIClient
    private let userDefaultsUseCase: UserDefaultsUseCase
    private var favoritesMovies: FavoritesMoviesResponseModel?
    
    init(apiClient: APIClient, userDefaultsUseCase: UserDefaultsUseCase) {
        self.apiClient = apiClient
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let showFavoritesMovies = input.loadingFavoritesMovies
            .flatMapLatest({ [apiClient, userDefaultsUseCase] _ -> Observable<FavoritesMoviesResponseModel> in
                return apiClient.getFavoritesMovies(atPage: 1, withSessionId: userDefaultsUseCase.sessionId!)
            })
            .do(onNext: { [weak self] model in
                guard let self = self else { return () }
                self.favoritesMovies = model
            })
            .map { $0.results as [FavoritesMoviesResponseModel.Result] }
            .asDriver(onErrorJustReturn: [FavoritesMoviesResponseModel.Result]())
        
        let deleteFavoritesMovie = input.favoritesMoviesDeleteTrigger
            .flatMapLatest({ [weak self] indexPath -> Observable<MarkAsFavoriteResponseModel> in
                guard let self = self else { return Observable.never() }
                return (self.apiClient.markAsFavorite(model: MarkAsFavoritePostResponseModel(
                        mediaType: "movie",
                        mediaID: (self.favoritesMovies?.results?[indexPath.row].id)!,
                        favorite: false
                    ), withSessionId: (self.userDefaultsUseCase.sessionId!)))
            })
            .map({ _ in () })
            .asDriver(onErrorJustReturn: ())
        
        let showMovieInfo = input.favoritesMovieCellTrigger
            .map({ [weak self] indexPath in
                guard let self = self else { return () }
                if let film = self.favoritesMovies?.results?[indexPath.row] {
                    self.didSendEventClosure?(.movieDetails(model: MovieDetailsModel(
                        id: film.id,
                        favorite: true,
                        posterPath: film.posterPath,
                        title: film.title,
                        duration: "0",
                        score: film.voteAverage,
                        release: film.releaseDate,
                        synopsis: film.overview)))
                }
            })
            .asDriver(onErrorJustReturn: ())
        
        let switchToComingSoon = input.switchToComingSoon
            .do(onNext: { [didSendEventClosure] _ in
                guard let didSendEventClosure = didSendEventClosure else { return () }
                didSendEventClosure(.comingSoon)
        }).asDriver(onErrorJustReturn: ())
        
        return Output(
            showFavoritesMovies: showFavoritesMovies,
            deleteFavoritesMovie: deleteFavoritesMovie,
            showMovieInfo: showMovieInfo,
            switchToComingSoon: switchToComingSoon)
    }
}
