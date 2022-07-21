import RxDataSources

struct SearchMoviesCellModel {
    let title: String
    var data: [SearchMoviesResponseModel.Result]
}

extension SearchMoviesCellModel: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = SearchMoviesResponseModel.Result
    
    var identity: Identity { return title }
    var items: [Item] {return data }
    
    init(
        original: SearchMoviesCellModel,
        items: [SearchMoviesResponseModel.Result]
    ) {
        self = original
        data = items
    }
}
