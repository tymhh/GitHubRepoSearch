import Foundation

extension GraphQLService {
    func searchRepositories(query: String, sort: String?, first: Int?, after: String?, success: SuccessHandler<(String, SearchQuery.Data)>?, failure: FailureHandler?) {
        let str = "\(query) sort:\(sort ?? "stars-desc")"
        let request = SearchQuery(q: str, after: after, first: first)
        fetch(request: request, success: { data in
            if let data = data as? SearchQuery.Data {
                success?((query, data))
            } else {
                failure?(GraphQLErrors.decoding(message: ""))
            }
        }, failure: failure)
    }
}

extension SearchQuery.Data.Search.Edge.Node.Fragments: Repository {
    var name: String {
        return self.details?.nameWithOwner.trunc(length: 30) ?? ""
    }
    
    var url: String {
        return self.details?.url ?? ""
    }
    
    var cursor: String {
        return self.cursor
    }
}

private extension String {
    func trunc(length: Int, trailing: String = "…") -> String? {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
