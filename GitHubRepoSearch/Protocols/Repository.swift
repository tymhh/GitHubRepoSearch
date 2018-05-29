import Foundation

protocol Repository: Paginable {
    var name: String { get }
    var url: String { get }
    var cursor: String { get }
}

protocol Paginable {
    var cursor: String { get }
}
