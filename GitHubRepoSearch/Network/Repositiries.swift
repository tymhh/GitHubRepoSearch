import Foundation

extension GraphQLService {
    func getRepos(offset: Int, success: SuccessHandler<NumberOfReposQuery.Data>?, failure: FailureHandler?) {
        let request = NumberOfReposQuery(number_of_repos: offset)
        fetch(request: request, success: { data in
            if let data = data as? NumberOfReposQuery.Data {
                success?(data)
            } else {
                failure?(GraphQLErrors.decoding(message: ""))
            }
        }, failure: failure)
    }
    
    func searchRepositories(query: String, sort: String, success: SuccessHandler<SearchQuery.Data>?, failure: FailureHandler?) {
        let str = "\(query) sort:\(sort)"
        let request = SearchQuery(q: str)
        fetch(request: request, success: { data in
            if let data = data as? SearchQuery.Data {
                success?(data)
            } else {
                failure?(GraphQLErrors.decoding(message: ""))
            }
        }, failure: failure)
    }
}
