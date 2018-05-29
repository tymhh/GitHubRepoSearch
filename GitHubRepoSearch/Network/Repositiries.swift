import Foundation

extension GraphQLService {
    func searchRepositories(query: String, sort: String, first: Int?, after: String?, success: SuccessHandler<SearchQuery.Data>?, failure: FailureHandler?) {
        let str = "\(query) sort:\(sort)"
        let request = SearchQuery(q: str, after: after, first: first)
        fetch(request: request, success: { data in
            if let data = data as? SearchQuery.Data {
                success?(data)
            } else {
                failure?(GraphQLErrors.decoding(message: ""))
            }
        }, failure: failure)
    }
}

extension SearchQuery.Data.Search.Edge.Node.Fragments: Repository {
    var name: String {
        return self.details?.nameWithOwner ?? ""
    }
    
    var url: String {
        return self.details?.url ?? ""
    }
    
    var cursor: String {
        return self.cursor
    }
}
