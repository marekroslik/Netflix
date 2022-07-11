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
        let likeLatestMovie: Driver<Void>
        let showAccount: Driver<Void>
        let showMovieInfo: Driver<Void>
    }
    
    var didSendEventClosure: ((HomeViewController.Event) -> Void)?
    private let apiClient: APIClient
    private var latestMovie: LatestMovieResponseModel?
    private var popularMovies: PopularMoviesResponseModel?
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func transform(input: Input) -> Output {
        
        let showLatestMovie = input.loadingLatestMovie
            .flatMapLatest({ [apiClient] _ -> Observable<LatestMovieResponseModel> in
                apiClient.getLatestMovie()
            })
            .do(onNext: { [weak self] model in
                self?.latestMovie = model
            })
            .map { $0 as LatestMovieResponseModel }
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
                .asDriver(onErrorJustReturn: ())
                
                let likeLatestMovie = input.likeLatestMovieTrigger
                .asDriver(onErrorJustReturn: ())
                
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
