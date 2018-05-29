import UIKit

class ViewController: UIViewController {
    fileprivate var networkService: GraphQLService = GraphQLService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getRepos(offset: 10, success: { [weak self] repos in
            print(repos)
        }, failure: {[weak self] error in
            print(error)
        })
    }
}

