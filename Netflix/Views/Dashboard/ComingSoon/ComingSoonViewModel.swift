import Foundation
import RxSwift
import RxCocoa

class ComingSoonViewModel: ViewModelType {
    
    struct Input {
        let loadingComingSoonMovies: Observable<Void>
        let searchText: Observable<String>
        let comingSoonMovieCellTrigger: Observable<IndexPath>
        let searchMovieCellTrigger: Observable<IndexPath>
        let comingSoonMovieScrollTrigger: Observable<(cell: UICollectionViewCell, at: IndexPath)>
        let searchMovieScrollTrigger: Observable<(cell: UICollectionViewCell, at: IndexPath)>
    }
    
    struct Output {
        let showComingSoonMovies: Driver<[UpcomingMoviesResponseModel.Result]>
        let showSearchMovies: Driver<[SearchMoviesResponseModel.Result]>
        let showComingSoonMovieInfo: Driver<Void>
        let showSearchMovieInfo: Driver<Void>
        let showHideComingSoon: Driver<Bool>
        let showComingSoonCollectionLoading: Driver<Bool>
        let showSearchCollectionLoading: Driver<Bool>
    }
    
    var didSendEventClosure: ((ComingSoonViewController.Event) -> Void)?
    private let apiClient: APIClient
    private let userDefaultsUseCase: UserDefaultsUseCase
    private var comingSoonMovies: UpcomingMoviesResponseModel?
    private var searchMovies: SearchMoviesResponseModel?
    private var favoritesMovies: FavoritesMoviesResponseModel?
    private let showComingSoonCollectionLoadingTrigger = PublishRelay<Bool>()
    private let showSearchCollectionLoadingTrigger = PublishRelay<Bool>()
    
    init(apiClient: APIClient, userDefaultsUseCase: UserDefaultsUseCase) {
        self.apiClient = apiClient
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let showComingSoonMoviesDefault = input.loadingComingSoonMovies
            .flatMapLatest { [apiClient] _ -> Observable<UpcomingMoviesResponseModel> in
                apiClient.getUpcomingMovies(atPage: 1)
            }
            .do { [weak self] model in
                self?.comingSoonMovies = model
                if model.page < model.totalPages {
                    self?.showComingSoonCollectionLoadingTrigger.accept(true)
                } else {
                    self?.showComingSoonCollectionLoadingTrigger.accept(false)
                }
            }
            .flatMapLatest { [apiClient, userDefaultsUseCase] _ in
                apiClient.getFavoritesMovies(atPage: 1, withSessionId: userDefaultsUseCase.sessionId!)
            }
            .do { [weak self] model in
                self?.favoritesMovies = model
                guard let comingSoonMovies = self?.comingSoonMovies?.results else { return }
                for element in model.results {
                    if let index = comingSoonMovies.firstIndex(where: { $0.identity == element.id}) {
                        self?.comingSoonMovies?.results[index].favorites = true
                    }
                }
            }
            .map { [weak self] _ in
                guard let results = self?.comingSoonMovies?.results
                else { return [UpcomingMoviesResponseModel.Result]() }
                return results
            }
            .asDriver(onErrorJustReturn: [UpcomingMoviesResponseModel.Result]())
        
        let showSearchMoviesDefault = input.searchText
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { [apiClient] searchText -> Observable<SearchMoviesResponseModel> in
                let textWithoutSpaces = searchText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
                return apiClient.searchMovies(atPage: 1, withTitle: textWithoutSpaces)
            }
            .do { [weak self] model in
                self?.searchMovies = model
                guard let array2 = self?.favoritesMovies?.results else { return }
                for element in array2 {
                    if let index = model.results.firstIndex(where: { $0.identity == element.id}) {
                        self?.searchMovies?.results[index].favorites = true
                    }
                }
                if model.page < model.totalPages {
                    self?.showComingSoonCollectionLoadingTrigger.accept(true)
                } else {
                    self?.showComingSoonCollectionLoadingTrigger.accept(false)
                }
            }
            .map { [weak self] _ in
                guard let results = self?.searchMovies?.results
                else { return [SearchMoviesResponseModel.Result]() }
                return results
            }
            .asDriver(onErrorJustReturn: [SearchMoviesResponseModel.Result]())
        
        let showComingSoonMovieInfo = input.comingSoonMovieCellTrigger
            .map { [weak self] indexPath in
                if let film = self?.comingSoonMovies?.results[indexPath.row] {
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
        
        let showSearchMovieInfo = input.searchMovieCellTrigger
            .map { [weak self] indexPath in
                if let film = self?.searchMovies?.results[indexPath.row] {
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
        
        let showHideComingSoon = input.searchText
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { !$0.isEmpty }
            .do { [weak self] _ in
                self?.searchMovies?.results.removeAll()
            }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        let showScrollComingSoonMovies = input.comingSoonMovieScrollTrigger
            .filter { [weak self] (_, index: IndexPath) in
                guard
                    let self = self,
                    let page = self.comingSoonMovies?.page,
                    let totalPages = self.comingSoonMovies?.totalPages
                else { return false }
                return index.row == 19 * page && page < totalPages
            }
            .flatMapLatest { [weak self] _ -> Observable<UpcomingMoviesResponseModel> in
                guard
                    let self = self,
                    let page = self.comingSoonMovies?.page
                else { return Observable.never() }
                return self.apiClient.getUpcomingMovies(atPage: page + 1)
            }
            .do { [weak self] model in
                self?.comingSoonMovies?.results += model.results
                self?.comingSoonMovies?.page = model.page
                if model.page < model.totalPages {
                    self?.showComingSoonCollectionLoadingTrigger.accept(true)
                } else {
                    self?.showComingSoonCollectionLoadingTrigger.accept(false)
                }
            }
            .flatMapLatest { [apiClient, userDefaultsUseCase] _ -> Observable<FavoritesMoviesResponseModel> in
                guard let sessionId = userDefaultsUseCase.sessionId else { return Observable.never() }
                return apiClient.getFavoritesMovies(atPage: 1, withSessionId: sessionId)
            }
            .do { [weak self] model in
                self?.favoritesMovies = model
                guard let array1 = self?.comingSoonMovies?.results else { return }
                for element in model.results {
                    if let index = array1.firstIndex(where: { $0.identity == element.id}) {
                        self?.comingSoonMovies?.results[index].favorites = true
                    }
                }
            }
            .map { [weak self] _ in
                guard let results = self?.comingSoonMovies?.results
                else { return [UpcomingMoviesResponseModel.Result]() }
                return results
            }
            .asDriver(onErrorJustReturn: [UpcomingMoviesResponseModel.Result]())
        
        let showScrollSearchMovies = input.searchMovieScrollTrigger
            .filter { [weak self] (_, index: IndexPath) in
                guard
                    let self = self,
                    let page = self.searchMovies?.page,
                    let totalPages = self.searchMovies?.totalPages
                else { return false }
                return index.row == 19 * page && page < totalPages
            }
            .withLatestFrom(input.searchText)
            .flatMapLatest { [weak self] searchText -> Observable<SearchMoviesResponseModel> in
                let textWithoutSpaces = searchText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
                guard
                    let self = self,
                    let page = self.searchMovies?.page
                else { return Observable.never() }
                return self.apiClient.searchMovies(atPage: page + 1, withTitle: textWithoutSpaces)
            }
            .do { [weak self] model in
                self?.searchMovies?.results += model.results
                self?.searchMovies?.page = model.page
                guard let favoritesMovies = self?.favoritesMovies?.results else { return }
                for element in favoritesMovies {
                    if let index = model.results.firstIndex(where: { $0.identity == element.id}) {
                        self?.searchMovies?.results[index].favorites = true
                    }
                }
                if model.page < model.totalPages {
                    self?.showComingSoonCollectionLoadingTrigger.accept(true)
                } else {
                    self?.showComingSoonCollectionLoadingTrigger.accept(false)
                }
            }
            .map { [weak self] _ in
                guard let results = self?.searchMovies?.results
                else { return [SearchMoviesResponseModel.Result]() }
                return results
            }
            .asDriver(onErrorJustReturn: [SearchMoviesResponseModel.Result]())
        
        let showComingSoonMovies = Driver
            .merge(showComingSoonMoviesDefault, showScrollComingSoonMovies)
            .flatMapLatest { driver in
                return Driver.just(driver)
            }
        
        let showSearchMovies = Driver
            .merge(showSearchMoviesDefault, showScrollSearchMovies)
            .flatMapLatest { driver in
                return Driver.just(driver)
            }
        
        let showComingSoonCollectionLoading = showComingSoonCollectionLoadingTrigger
            .map { bool in
                return bool
            }
            .startWith(true).asDriver(onErrorJustReturn: (true))
        
        let showSearchCollectionLoading = showSearchCollectionLoadingTrigger
            .map { bool in
                return bool
            }
            .startWith(true).asDriver(onErrorJustReturn: (true))
        
        return Output(
            showComingSoonMovies: showComingSoonMovies,
            showSearchMovies: showSearchMovies,
            showComingSoonMovieInfo: showComingSoonMovieInfo,
            showSearchMovieInfo: showSearchMovieInfo,
            showHideComingSoon: showHideComingSoon,
            showComingSoonCollectionLoading: showComingSoonCollectionLoading,
            showSearchCollectionLoading: showSearchCollectionLoading
        )
    }
}
