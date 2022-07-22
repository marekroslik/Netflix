import RxDataSources

struct ComingSoonCellModel {
    let title: String
    var data: [UpcomingMoviesResponseModel.Result]
}

extension ComingSoonCellModel: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = UpcomingMoviesResponseModel.Result
    
    var identity: Identity { return title }
    var items: [Item] {return data }
    
    init(
        original: ComingSoonCellModel,
        items: [UpcomingMoviesResponseModel.Result]
    ) {
        self = original
        data = items
    }
}
