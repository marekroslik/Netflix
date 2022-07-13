import Foundation
import RxSwift
import RxCocoa

class ComingSoonViewModel: ViewModelType {
    
    struct Input {
        let loadingComingSoonMovies: Observable<Void>
        let searchText: Observable<String>
        let comingSoonMovieCellTrigger: Observable<IndexPath>
        let searchMovieCellTrigger: Observable<IndexPath>
    }
    
    struct Output {
        let showComingSoonMovies: Driver<[UpcomingMoviesResponseModel.Result]>
        let showSearchMovies: Driver<[SearchMoviesResponseModel.Result]>
        let showComingSoonMovieInfo: Driver<Void>
        let showSearchMovieInfo: Driver<Void>
        let showHideComingSoon: Driver<Bool>
    }
    
    var didSendEventClosure: ((ComingSoonViewController.Event) -> Void)?
    private let apiClient: APIClient
    private let userDefaultsUseCase: UserDefaultsUseCase
    private var comingSoonMovies: UpcomingMoviesResponseModel?
    private var searchMovies: SearchMoviesResponseModel?
    private var favoritesMovies: FavoritesMoviesResponseModel?
    
    init(apiClient: APIClient, userDefaultsUseCase: UserDefaultsUseCase) {
        self.apiClient = apiClient
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let showComingSoonMovies = input.loadingComingSoonMovies
            .flatMapLatest({ [apiClient] _ -> Observable<UpcomingMoviesResponseModel> in
                apiClient.getUpcomingMovies(atPage: 1)
            })
            .do(onNext: { [weak self] model in
                self?.comingSoonMovies = model
            })
            .flatMapLatest({ [apiClient, userDefaultsUseCase] _ in
                apiClient.getFavoritesMovies(atPage: 1, withSessionId: userDefaultsUseCase.sessionId!)
            })
            .do(onNext: { [weak self] model in
                self?.favoritesMovies = model
                guard let array1 = self?.comingSoonMovies?.results else { return }
                guard let array2 = model.results else { return }
                for element in array2 {
                    if let index = array1.firstIndex(where: { $0.id == element.id}) {
                        self?.comingSoonMovies?.results?[index].favorites = true
                    }
                }
            })
            .map({ [weak self] _ in
                return self?.comingSoonMovies?.results as [UpcomingMoviesResponseModel.Result]
            })
                .asDriver(onErrorJustReturn: [UpcomingMoviesResponseModel.Result]())
                
                let showSearchMovies = input.searchText
                .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                .flatMapLatest({ [apiClient] searchText -> Observable<SearchMoviesResponseModel> in
                    let textWithoutSpaces = searchText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
                    return apiClient.searchMovies(atPage: 1, withTitle: textWithoutSpaces)
                })
                .do(onNext: { [weak self] model in
                    self?.searchMovies = model
                    guard let array1 = model.results else { return }
                    guard let array2 = self?.favoritesMovies?.results else { return }
                    for element in array2 {
                        if let index = array1.firstIndex(where: { $0.id == element.id}) {
                            self?.searchMovies?.results?[index].favorites = true
                        }
                    }
                })
                    .map { [weak self] _ in
                        return self?.searchMovies?.results as [SearchMoviesResponseModel.Result] }
                    .asDriver(onErrorJustReturn: [SearchMoviesResponseModel.Result]())
        
        let showComingSoonMovieInfo = input.comingSoonMovieCellTrigger
            .map({ [weak self] indexPath in
                if let film = self?.comingSoonMovies?.results?[indexPath.row] {
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
        
        let showSearchMovieInfo = input.searchMovieCellTrigger
            .map({ [weak self] indexPath in
                if let film = self?.searchMovies?.results?[indexPath.row] {
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
        
        let showHideComingSoon = input.searchText
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { !$0.isEmpty }
            .do(onNext: { [weak self] _ in
                self?.searchMovies?.results?.removeAll()
            })
                .startWith(false)
                .asDriver(onErrorJustReturn: false)
                
                return Output(
                    showComingSoonMovies: showComingSoonMovies,
                    showSearchMovies: showSearchMovies,
                    showComingSoonMovieInfo: showComingSoonMovieInfo,
                    showSearchMovieInfo: showSearchMovieInfo,
                    showHideComingSoon: showHideComingSoon)
                }
}
