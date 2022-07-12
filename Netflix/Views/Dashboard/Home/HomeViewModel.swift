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
    }
    
    struct Output {
        let showLatestMovie: Driver<LatestMovieResponseModel?>
        let showPopularMovies: Driver<[PopularMoviesResponseModel.Result]>
        let playLatestMovie: Driver<Void>
        let likeLatestMovie: Driver<Bool>
        let showAccount: Driver<Void>
        let showMovieInfo: Driver<Void>
    }
    
    var didSendEventClosure: ((HomeViewController.Event) -> Void)?
    private let apiClient: APIClient
    private let userDefaultsUseCase: UserDefaultsUseCase
    private var latestMovie: LatestMovieResponseModel?
    private var popularMovies: PopularMoviesResponseModel?
    
    init(apiClient: APIClient, userDefaultsUseCase: UserDefaultsUseCase) {
        self.apiClient = apiClient
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let showLatestMovie = input.loadingLatestMovie
            .flatMapLatest({ [apiClient] _ -> Observable<LatestMovieResponseModel> in
                apiClient.getLatestMovie()
            })
            .do(onNext: { [weak self] model in
                self?.latestMovie = model
            })
                .flatMapLatest({ [apiClient, userDefaultsUseCase] _ -> Observable<FavoritesMoviesResponseModel> in
                    apiClient.getFavoritesMovies(atPage: 1, withSessionId: userDefaultsUseCase.sessionId!)
                })
                .do(onNext: { [weak self] model in
                    guard let array = model.results else { return }
                    if array.firstIndex(where: { $0.id == self?.latestMovie?.id}) != nil {
                        self?.latestMovie?.favorites = true
                    }
                })
                    .map({ [weak self] _ -> LatestMovieResponseModel in
                        return (self?.latestMovie)! as LatestMovieResponseModel
                    })
                    .asDriver(onErrorJustReturn: nil)
                    
                    let showPopularMovies = input.loadingPopularMovies
                    .flatMapLatest({ [apiClient] _ -> Observable<PopularMoviesResponseModel> in
                        apiClient.getPopularMovies(atPage: 1)
                    })
                    .do(onNext: { [weak self] model in
                        self?.popularMovies = model
                    })
                        .flatMapLatest({ [apiClient] _ -> Observable<FavoritesMoviesResponseModel> in
                            apiClient.getFavoritesMovies(atPage: 1, withSessionId: UserDefaultsUseCase().sessionId!)
                        })
                        .do(onNext: { [weak self] model in
                            guard let array1 = self?.popularMovies?.results else { return }
                            guard let array2 = model.results else { return }
                            for element in array2 {
                                if let index = array1.firstIndex(where: { $0.id == element.id}) {
                                    self?.popularMovies?.results[index].favorites = true
                                }
                            }
                        })
                        .map({ [weak self] _ in
                            return self?.popularMovies?.results as [PopularMoviesResponseModel.Result]
                        })
                            .asDriver(onErrorJustReturn: [PopularMoviesResponseModel.Result]())
                            
                            let playLatestMovie = input.playLatestMovieTrigger
                            .map({ [weak self] _ in
                                if let id = self?.latestMovie?.id {
                                    self?.didSendEventClosure?(.showVideo(id: id))
                                } else {
                                    return ()
                                }
                            })
                            .asDriver(onErrorJustReturn: ())
                            
                            let likeLatestMovie = input.likeLatestMovieTrigger
                            .flatMapLatest({ [self] _ -> Observable<MarkAsFavoriteResponseModel> in
                                return apiClient.markAsFavorite(model: MarkAsFavoritePostResponseModel(
                                    mediaType: "movie",
                                    mediaID: latestMovie!.id,
                                    favorite: !latestMovie!.favorites
                                ), withSessionId: UserDefaultsUseCase().sessionId!)
                            })
                            .map { [self] _ in
                                self.latestMovie!.favorites.toggle()
                                return self.latestMovie!.favorites
                            }
                            .asDriver(onErrorJustReturn: false)
        
        let showAccount = input.showAccountTrigger
            .do(onNext: { [weak self] _ in
                self?.didSendEventClosure?(.profile)
            })
                .asDriver(onErrorJustReturn: ())
                
                let showMovieInfo = input.popularMovieCellTrigger
                .map({ [weak self] indexPath in
                    if let film = self?.popularMovies?.results[indexPath.row] {
                        self?.didSendEventClosure?(.movieDetails(model: MovieDetailsModel(
                            id: film.id,
                            favorite: film.favorites,
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
                    showLatestMovie: showLatestMovie,
                    showPopularMovies: showPopularMovies,
                    playLatestMovie: playLatestMovie,
                    likeLatestMovie: likeLatestMovie,
                    showAccount: showAccount,
                    showMovieInfo: showMovieInfo
                )
                }
}
