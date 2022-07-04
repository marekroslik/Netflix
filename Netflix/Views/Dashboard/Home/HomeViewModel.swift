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
        let movieCellTrigger: Observable<IndexPath>
    }
    struct Output {
        var showLatestMovie: Driver<LatestMovieResponseModel?>
        let showPopularMovies: Driver<[PopularMoviesResponseModel.Result]>
        let playLatestMovie: Driver<Void>
        let likeLatestMovie: Driver<Void>
        let showAccount: Driver<Void>
        let showMovieInfo: Driver<Void>
    }
    
    var didSendEventClosure: ((HomeViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func transform(input: Input) -> Output {
        
        let showLatestMovie = input.loadingLatestMovie
            .flatMapLatest({ [apiClient] _ -> Observable<LatestMovieResponseModel> in
                apiClient.getLatestMovie()
            })
            .map { $0 as LatestMovieResponseModel }
            .asDriver(onErrorJustReturn: nil)
        
        let showPopularMovies = input.loadingPopularMovies
            .flatMapLatest({ [apiClient] _ -> Observable<PopularMoviesResponseModel> in
                apiClient.getPopularMovies(atPage: 1)
            })
            .map { $0.results as [PopularMoviesResponseModel.Result] }
            .asDriver(onErrorJustReturn: [PopularMoviesResponseModel.Result]())
        
        let playLatestMovie = input.playLatestMovieTrigger
            .asDriver(onErrorJustReturn: ())
        
        let likeLatestMovie = input.likeLatestMovieTrigger
            .asDriver(onErrorJustReturn: ())
        
        let showAccount = input.showAccountTrigger
            .asDriver(onErrorJustReturn: ())
        
        let showMovieInfo = input.movieCellTrigger
            .map({ indexPath in
                print(indexPath)
                return ()
            })
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            showLatestMovie: showLatestMovie,
            showPopularMovies: showPopularMovies,
            playLatestMovie: playLatestMovie,
            likeLatestMovie: likeLatestMovie,
            showAccount: showAccount,
            showMovieInfo: showMovieInfo)
    }
}
