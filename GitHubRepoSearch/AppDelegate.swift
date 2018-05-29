import UIKit
import Apollo

let apollo: ApolloClient = {
    let token = "5f56acf75dfe4368ff2cf4633ddd924a90cdb632"
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    let url = URL(string: "https://api.github.com/graphql")!
    return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
}

