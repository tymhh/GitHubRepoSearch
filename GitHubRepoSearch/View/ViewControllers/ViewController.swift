import UIKit

class ViewController: UIViewController {
    fileprivate var networkService: GraphQLService = GraphQLService()
    fileprivate var tableView: UITableView!
    fileprivate var searchController: UISearchController?
    fileprivate var isSearching: Bool = false
    fileprivate var repositories: [String] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        loadStaticViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        loadStaticNavigationBar()
        getRepositories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        definesPresentationContext = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        definesPresentationContext = false
    }
    
    fileprivate func getRepositories() {
        networkService.getRepos(offset: 10, success: { [weak self] repos in
            self?.repositories = repos.viewer.repositories.nodes?.map {$0?.name ?? ""} ?? []
            }, failure: { error in
                print(error)
        })
    }
    
    fileprivate func searchRepositories(query: String, sort: String? = "stars-desc") {
        networkService.searchRepositories(query: query, sort: sort ?? "stars-desc", success: {[weak self] repos in
            let fragments = repos.search.edges?.map {$0?.node?.fragments}
            let dets = fragments?.map {$0?.details}
            self?.repositories = dets?.map {$0?.nameWithOwner ?? ""} ?? []
        }, failure: { error in
            print(error)
        })
    }
}

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText != "" {
            isSearching = true
            filterItems(searchText: searchText)
            tableView.reloadData()
        } else {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
    }
    
    func filterItems(searchText: String) {
        searchRepositories(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let cell_ = tableView.dequeueReusableCell(withIdentifier: "cell") as? UITableViewCell {
            cell = cell_
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = repositories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
}

extension ViewController {
    func loadStaticNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func loadStaticViews() {
        var cnts: [NSLayoutConstraint] = []
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.sendSubview(toBack: tableView)
        
        cnts += [tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)]
        cnts += [tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        cnts += [tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)]
        cnts += [tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)]
        
        NSLayoutConstraint.activate(cnts)
    }
}
