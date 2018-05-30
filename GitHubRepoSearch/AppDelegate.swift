import UIKit
import Apollo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        loadWindow()
        let naVc = UINavigationController(rootViewController: ViewController())
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = naVc
        return true
    }
    
    private func loadWindow() {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        window.rootViewController = storyboard.instantiateViewController(withIdentifier: "LaunchScreenController")
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        window.makeKeyAndVisible()
        
    }
}

let apollo: ApolloClient = {
    let token = <# token #>
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    let url = URL(string: "https://api.github.com/graphql")!
    return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
}()
