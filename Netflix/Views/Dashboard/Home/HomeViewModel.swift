import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
    struct Input {
        let loadingLatestMovie: Observable<Void>
        let loadingPopularMovies: Observable<Void>
        let playLatestMovieTrigger: Observable<Void>
        let likeLatestMovieTrigger: Observable<Void>
        let showAccountTrigger: Observable<Void>
        let popularMovieCellTrigger: Observable<IndexPath>
        let popularMovieScrollTrigger: Observable<(cell: UICollectionViewCell, at: IndexPath)>
    }
    
    struct Output {
        let showLatestMovie: Driver<LatestMovieResponseModel?>
        let showPopularMovies: Driver<[PopularMoviesResponseModel.Result]>
        let playLatestMovie: Driver<Void>
        let likeLatestMovie: Driver<Bool>
        let showAccount: Driver<Void>
        let showPopularMovieInfo: Driver<Void>
        let showPopularCollectionLoading: Driver<Bool>
    }
    
    var didSendEventClosure: ((HomeViewController.Event) -> Void)?
    private let apiClient: APIClient
    private let userDefaultsUseCase: UserDefaultsUseCase
    private var latestMovie: LatestMovieResponseModel?
    private var popularMovies: PopularMoviesResponseModel?
    private var favoritesMovies: FavoritesMoviesResponseModel?
    private let showPopularCollectionLoadingTrigger = PublishRelay<Bool>()
    
    init(apiClient: APIClient, userDefaultsUseCase: UserDefaultsUseCase) {
        self.apiClient = apiClient
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let showLatestMovie = input.loadingLatestMovie
            .flatMapLatest { [apiClient] _ -> Observable<LatestMovieResponseModel> in
                apiClient.getLatestMovie()
            }
            .do { [weak self] model in
                self?.latestMovie = model
            }
            .flatMapLatest { [apiClient, userDefaultsUseCase] _ -> Observable<FavoritesMoviesResponseModel> in
                guard let sessionId = userDefaultsUseCase.sessionId else { return Observable.never() }
                return apiClient.getFavoritesMovies(atPage: 1, withSessionId: sessionId)
            }
            .do { [weak self] model in
                if  model.results.firstIndex(where: { $0.id == self?.latestMovie?.id}) != nil {
                    self?.latestMovie?.favorites = true
                }
            }
            .map { [weak self] _ -> LatestMovieResponseModel in
                return (self?.latestMovie)! as LatestMovieResponseModel
            }
            .asDriver(onErrorJustReturn: nil)
        
        let showPopularMoviesDefault = input.loadingPopularMovies
            .flatMapLatest { [apiClient] _ -> Observable<PopularMoviesResponseModel> in
                apiClient.getPopularMovies(atPage: 1)
            }
            .do { [weak self] model in
                self?.popularMovies = model
                if model.page < model.totalPages {
                    self?.showPopularCollectionLoadingTrigger.accept(true)
                } else {
                    self?.showPopularCollectionLoadingTrigger.accept(false)
                }
            }
            .flatMapLatest { [apiClient, userDefaultsUseCase] _ -> Observable<FavoritesMoviesResponseModel> in
                guard let sessionId = userDefaultsUseCase.sessionId else { return Observable.never() }
                
                func loadFavorites(at page: Int = 1 ) -> Observable<FavoritesMoviesResponseModel> {
                    return apiClient.getFavoritesMovies(atPage: page, withSessionId: sessionId)
                        .flatMap { result -> Observable<FavoritesMoviesResponseModel> in
                            if result.page == result.totalPages {
                                return Observable.just(result)
                            } else {
                                return loadFavorites(at: page + 1).map { nextPageMovies in
                                    var combined = result
                                    combined.results += nextPageMovies.results
                                    return combined
                                }
                            }
                        }
                }
                return loadFavorites()
            }
            .do { [weak self] model in
                self?.favoritesMovies = model
                print(model.results.count)
                for (index, movie) in model.results.enumerated() {
                    print("\(index) \(movie.title!)")
                }
                
                return
            }
            .do { [weak self] _ in
                guard let popularMovies = self?.popularMovies?.results else { return }
                guard let favoritesMovies = self?.favoritesMovies?.results else { return }
                for element in favoritesMovies {
                    if let index = popularMovies.firstIndex(where: { $0.identity == element.id}) {
                        self?.popularMovies?.results[index].favorites = true
                    }
                }
            }
            .map { [weak self] _ in
                guard let model = self?.popularMovies?.results else {
                    return [PopularMoviesResponseModel.Result]()
                }
                return model
            }
            .asDriver(onErrorJustReturn: [PopularMoviesResponseModel.Result]())
        
        let playLatestMovie = input.playLatestMovieTrigger
            .map { [weak self] _ in
                if let id = self?.latestMovie?.id {
                    self?.didSendEventClosure?(.showVideo(id: id))
                } else {
                    return ()
                }
            }
            .asDriver(onErrorJustReturn: ())
        
        let likeLatestMovie = input.likeLatestMovieTrigger
            .flatMapLatest { [weak self] _ -> Observable<MarkAsFavoriteResponseModel> in
                guard
                    let self = self,
                    let id = self.latestMovie?.id,
                    let favorites = self.latestMovie?.favorites,
                    let sessionId = self.userDefaultsUseCase.sessionId
                else { return Observable.never() }
                return self.apiClient.markAsFavorite(model: MarkAsFavoritePostResponseModel(
                    mediaType: "movie",
                    mediaID: id,
                    favorite: !favorites
                ), withSessionId: sessionId
                )
            }
            .map { [weak self] _ -> Bool in
                self?.latestMovie?.favorites.toggle()
                return self?.latestMovie?.favorites ?? false
            }
            .asDriver(onErrorJustReturn: false)
        
        let showAccount = input.showAccountTrigger
            .do { [weak self] _ in
                self?.didSendEventClosure?(.profile)
            }
            .asDriver(onErrorJustReturn: ())
        
        let showPopularMovieInfo = input.popularMovieCellTrigger
            .map { [weak self] indexPath in
                if let film = self?.popularMovies?.results[indexPath.row] {
                    self?.didSendEventClosure?(.movieDetails(model: MovieDetailsModel(
                        id: film.identity,
                        favorite: film.favorites,
                        posterPath: film.posterPath,
                        title: film.title,
                        duration: "0",
                        score: film.voteAverage,
                        release: film.releaseDate,
                        synopsis: film.overview)))
                }
            }
            .asDriver(onErrorJustReturn: ())
        
        let showScrollPopularMovies = input.popularMovieScrollTrigger
            .filter { [weak self] (_, index: IndexPath) in
                guard
                    let self = self,
                    let page = self.popularMovies?.page,
                    let totalPages = self.popularMovies?.totalPages
                else { return false }
                return index.row == 19 * page && page < totalPages
            }
            .flatMapLatest { [weak self] _ -> Observable<PopularMoviesResponseModel> in
                guard
                    let self = self,
                    let page = self.popularMovies?.page
                else { return Observable.never() }
                return self.apiClient.getPopularMovies(atPage: page + 1)
            }
            .do { [weak self] model in
                self?.popularMovies?.page += 1
                self?.popularMovies?.results += model.results
                if model.page < model.totalPages {
                    self?.showPopularCollectionLoadingTrigger.accept(true)
                } else {
                    self?.showPopularCollectionLoadingTrigger.accept(false)
                }
            }
            .do { [weak self] _ in
                guard let array1 = self?.popularMovies?.results else { return }
                guard let favoritesMovies = self?.favoritesMovies?.results else { return }

                for element in favoritesMovies {
                    if let index = array1.firstIndex(where: { $0.identity == element.id}) {
                        self?.popularMovies?.results[index].favorites = true
                    }
                }
            }
            .map { [weak self] _ in
                guard let model = self?.popularMovies?.results else { return [PopularMoviesResponseModel.Result]() }
                return model
            }
            .asDriver(onErrorJustReturn: [PopularMoviesResponseModel.Result]())
        
        let showPopularMovies = Driver
            .merge(showPopularMoviesDefault, showScrollPopularMovies)
            .flatMapLatest { driver in
                return Driver.just(driver)
            }
        
        let showPopularCollectionLoading = showPopularCollectionLoadingTrigger
            .map { bool in
                return bool
            }
            .startWith(true).asDriver(onErrorJustReturn: (true))
        
        return Output(
            showLatestMovie: showLatestMovie,
            showPopularMovies: showPopularMovies,
            playLatestMovie: playLatestMovie,
            likeLatestMovie: likeLatestMovie,
            showAccount: showAccount,
            showPopularMovieInfo: showPopularMovieInfo,
            showPopularCollectionLoading: showPopularCollectionLoading
        )
    }
}
