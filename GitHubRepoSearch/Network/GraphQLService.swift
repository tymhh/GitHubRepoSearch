import Foundation
import Apollo

public enum GraphQLErrors: Error {
    case badRequest
    case decoding(message: String)
    case invalidRequest(message: String)
    case serverCode(code: Int)
    case missingClientIdOrRedirectURI
}

final class GraphQLService {
    public typealias SuccessHandler<T> = (_ data: T) -> Void
    public typealias FailureHandler = (_ error: Error) -> Void
    
    func fetch<T: GraphQLQuery>(request: T, success: ((_ data: GraphQLSelectionSet?) -> Void)?, failure: FailureHandler?) {
        apollo.fetch(query: request) { (result, error) in
            if let error = error {
                failure?(error)
            } else if let error = result?.errors?.first {
                failure?(error)
            } else {
                success?(result?.data)
            }
        }
    }
}
