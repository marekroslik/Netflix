import Foundation
import RxSwift
import RxCocoa

class FavoritesViewModel: ViewModelType {
    
    struct Input {
        let loadingFavoritesMovies: Observable<Void>
        let favoritesMovieCellTrigger: Observable<IndexPath>
        let favoritesMoviesDeleteTrigger: Observable<IndexPath>
    }
    
    struct Output {
        let showFavoritesMovies: Driver<[FavoritesMoviesResponseModel.Result]>
        let deleteFavoritesMovie: Driver<Void>
        let showMovieInfo: Driver<Void>
    }
    
    var didSendEventClosure: ((FavoritesViewController.Event) -> Void)?
    private var apiClient: APIClient
    private let userDefaultsUseCase: UserDefaultsUseCase
    
    private var favoritesMovies: [FavoritesMoviesResponseModel.Result]?
    
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
                self?.favoritesMovies = model.results
            })
            .map { $0.results as [FavoritesMoviesResponseModel.Result] }
            .asDriver(onErrorJustReturn: [FavoritesMoviesResponseModel.Result]())
        
        let deleteFavoritesMovie = input.favoritesMoviesDeleteTrigger
            .map({ indexPath in
                print(indexPath)
                return ()
            })
            .asDriver(onErrorJustReturn: ())
        
        let showMovieInfo = input.favoritesMovieCellTrigger
            .map({ [weak self] indexPath in
                if let film = self?.favoritesMovies?[indexPath.row] {
                    self?.didSendEventClosure?(.movieDetails(model: MovieDetailsModel(
                        posterPath: film.posterPath,
                        title: film.title,
                        duration: "0",
                        score: film.voteAverage,
                        release: film.releaseDate,
                        synopsis: film.overview)))
                }
            })
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            showFavoritesMovies: showFavoritesMovies,
            deleteFavoritesMovie: deleteFavoritesMovie,
            showMovieInfo: showMovieInfo)
    }
}
