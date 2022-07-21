import RxDataSources

struct PopularMoviesCellModel {
    let title: String
    var data: [PopularMoviesResponseModel.Result]
}

extension PopularMoviesCellModel: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = PopularMoviesResponseModel.Result
    
    var identity: Identity { return title }
    var items: [Item] {return data }
    
    init(
        original: PopularMoviesCellModel,
        items: [PopularMoviesResponseModel.Result]
    ) {
        self = original
        data = items
    }
}
