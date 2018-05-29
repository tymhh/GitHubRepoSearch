import UIKit

class ViewController: UIViewController {
    fileprivate var networkService: GraphQLService = GraphQLService()
    fileprivate var tableView: UITableView!
    fileprivate var notificationLabel: UILabel!
    fileprivate var searchController: UISearchController?
    fileprivate var repositories: [Repository] = []
    fileprivate var treadManager: ThreadManager?
    fileprivate var cntKeyboard: NSLayoutConstraint!
    
    fileprivate var results: [Repository] = [] {
        didSet {
            insertRows(for: Array(results.dropFirst(oldValue.count)))
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
        notificationLabel.text = "Start enter text for search"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserversTemporary()
        definesPresentationContext = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserversTemporary()
        definesPresentationContext = false
    }
    
    fileprivate func searchRepositories(query: String, sort: String? = "stars-desc") {
        notificationLabel.isHidden = true
        treadManager?.cancel()
        results.removeAll()
        repositories.removeAll()
        treadManager = ThreadManager(resourse: repositories.last?.cursor, code: { cursor in
            self.networkService.searchRepositories(query: query, sort: sort ?? "stars-desc", first: 15, after: (cursor as? String), success: {[weak self] repos in
                let fragments = repos.search.edges?.map {$0?.node?.fragments}
                self?.results.append(contentsOf: (fragments as? [Repository]) ?? [])
                }, failure: { [weak self] error in
                    self?.notificationLabel.isHidden = false
                    self?.notificationLabel.text = error.localizedDescription
            })
        })
        treadManager?.execute()
    }
    
    fileprivate func insertRows(for repos: [Repository]) {
        let old = repositories.count
        repositories.append(contentsOf: repos)
        let new = repositories.count
        
        let rows_: [IndexPath] = IndexSet(integersIn: old..<new).map { return IndexPath(row: $0, section: 0) }
        tableView.insertRows(at: rows_, with: .fade)
    }
}

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText != "" {
            searchRepositories(query: searchText)
            tableView.reloadData()
        } else {
            notificationLabel.isHidden = false
            notificationLabel.text = "Start enter text for search"
            view.endEditing(true)
            tableView.reloadData()
        }
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
        cell.textLabel?.text = repositories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
}

extension ViewController {
    func addObserversTemporary() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeObserversTemporary() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject?)?.cgRectValue else { return }
        cntKeyboard?.constant = -keyboardSize.height
        UIView.animate(withDuration: 0.33) { [weak self] in self?.view.layoutIfNeeded() }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: NSNotification) {
        cntKeyboard?.constant = 0
        UIView.animate(withDuration: 0.33) { [weak self] in self?.view.layoutIfNeeded() }
    }
}

extension ViewController {
    func loadStaticNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.yellow.withAlphaComponent(0.7)
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
        
        notificationLabel = UILabel()
        notificationLabel.numberOfLines = 0
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.textAlignment = .center
        tableView.addSubview(notificationLabel)
        
        cntKeyboard = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        cnts += [tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)]
        cnts += [tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)]
        cnts += [tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)]
        cnts += [cntKeyboard]
        cnts += [notificationLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)]
        cnts += NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-|", options: [], metrics: nil, views: ["label": notificationLabel])
        
        NSLayoutConstraint.activate(cnts)
    }
}
