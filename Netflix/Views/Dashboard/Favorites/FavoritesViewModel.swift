import Foundation
import RxSwift
import RxCocoa

class FavoritesViewModel: ViewModelType {
    
    struct Input {
        let loadingFavoritesMovies: Observable<Void>
        let favoritesMovieCellTrigger: Observable<IndexPath>
        let favoritesMoviesDeleteTrigger: Observable<IndexPath>
        let switchToComingSoon: Observable<Void>
        let trackFavoritesTableScrollTrigger: Observable<WillDisplayCellEvent>
    }
    
    struct Output {
        let showFavoritesMovies: Driver<[FavoritesMoviesResponseModel.Result]>
        let deleteFavoritesMovie: Driver<Void>
        let showMovieInfo: Driver<Void>
        let switchToComingSoon: Driver<Void>
        let showTableLoading: Driver<Bool>
    }
    
    var didSendEventClosure: ((FavoritesViewController.Event) -> Void)?
    private let apiClient: APIClient
    private let userDefaultsUseCase: UserDefaultsUseCase
    private var favoritesMovies: FavoritesMoviesResponseModel?
    private var favoritesPage: Int = 1
    private let showTableLoadingTrigger = PublishRelay<Bool>()
    
    init(apiClient: APIClient, userDefaultsUseCase: UserDefaultsUseCase) {
        self.apiClient = apiClient
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let showFavoritesMoviesDefault = input.loadingFavoritesMovies
            .flatMapLatest({ [weak self] _ -> Observable<FavoritesMoviesResponseModel> in
                return self!.apiClient.getFavoritesMovies(atPage: 1, withSessionId: self!.userDefaultsUseCase.sessionId!)
            })
            .do(onNext: { [weak self] model in
                guard let self = self else { return () }
                self.favoritesMovies = model
                self.favoritesPage = 1
                if model.page < model.totalPages {
                    self.showTableLoadingTrigger.accept(true)
                } else {
                    self.showTableLoadingTrigger.accept(false)
                }
            })
            .map { [weak self] _ in
                guard
                    let self = self,
                    let result = self.favoritesMovies?.results
                else { return [FavoritesMoviesResponseModel.Result]() }
                return result
            }
            .asDriver(onErrorJustReturn: [FavoritesMoviesResponseModel.Result]())
        
        let deleteFavoritesMovie = input.favoritesMoviesDeleteTrigger
            .flatMapLatest({ [weak self] indexPath -> Observable<MarkAsFavoriteResponseModel> in
                guard
                    let self = self,
                    let movieId = self.favoritesMovies?.results[indexPath.row].id,
                    let sessionId = self.userDefaultsUseCase.sessionId
                else { return Observable.never() }
                return (self.apiClient.markAsFavorite(model: MarkAsFavoritePostResponseModel(
                    mediaType: "movie",
                    mediaID: movieId,
                    favorite: false
                ), withSessionId: sessionId))
            })
            .map({ _ in () })
            .asDriver(onErrorJustReturn: ())
        
        let showMovieInfo = input.favoritesMovieCellTrigger
            .map({ [weak self] indexPath in
                guard let self = self else { return () }
                if let film = self.favoritesMovies?.results[indexPath.row] {
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
        
                let showTableLoading = showTableLoadingTrigger.map({ bool in
                    return bool
                }).startWith(true).asDriver(onErrorJustReturn: (true))
                
                let showScrollFavoritesMovies = input.trackFavoritesTableScrollTrigger
                .filter({ [weak self] (_, indexPath: IndexPath) in
                    guard
                        let self = self,
                        let page = self.favoritesMovies?.page,
                        let totalPages = self.favoritesMovies?.totalPages
                    else { return false }
                    return indexPath.row == 19 * self.favoritesPage && page < totalPages
                })
                .flatMapLatest({ [weak self] _ -> Observable<FavoritesMoviesResponseModel> in
                    guard
                        let self = self,
                        let sessionId = self.userDefaultsUseCase.sessionId
                    else { return Observable.never() }
                    return self.apiClient.getFavoritesMovies(
                        atPage: self.favoritesPage + 1,
                        withSessionId: sessionId
                    )
                })
                .do(onNext: { [weak self] model in
                    guard let self = self else { return () }
                    self.favoritesMovies?.results += model.results
                    self.favoritesPage += 1
                    if model.page < model.totalPages {
                        self.showTableLoadingTrigger.accept(true)
                    } else {
                        self.showTableLoadingTrigger.accept(false)
                    }
                })
                    .map { [weak self] _ in
                        guard let result = self?.favoritesMovies?.results else { return [FavoritesMoviesResponseModel.Result]() }
                        return result
                    }
                    .asDriver(onErrorJustReturn: [FavoritesMoviesResponseModel.Result]())
        
        let showFavoritesMovies = Driver.merge(showFavoritesMoviesDefault, showScrollFavoritesMovies)
            .flatMapLatest { driver in
                return Driver.just(driver)
            }
        
        return Output(
            showFavoritesMovies: showFavoritesMovies,
            deleteFavoritesMovie: deleteFavoritesMovie,
            showMovieInfo: showMovieInfo,
            switchToComingSoon: switchToComingSoon,
            showTableLoading: showTableLoading
        )
    }
}
