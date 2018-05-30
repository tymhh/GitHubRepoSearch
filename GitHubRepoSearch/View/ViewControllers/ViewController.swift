import UIKit
import PTPopupWebView

class ViewController: UIViewController {
    fileprivate var networkService: GraphQLService = GraphQLService()
    fileprivate var tableView: UITableView!
    fileprivate var notificationLabel: UILabel!
    fileprivate var searchController: UISearchController?
    fileprivate var repositories: [Repository] = []
    fileprivate var threadManager: ThreadManager?
    fileprivate var cntKeyboard: NSLayoutConstraint!
    fileprivate var cache: [String: [Repository]] = [:]
    fileprivate var currentQueryString: String = ""
    fileprivate lazy var popupWebView: PTPopupWebViewController = {
        return PTPopupWebViewController()
    }()
    
    fileprivate var results: [Repository] = [] {
        didSet {
            if results.isEmpty || oldValue.count >= results.count || oldValue.count == 0 {
                repositories = results
                tableView.reloadData()
            } else {
                insertRows(for: Array(results.dropFirst(oldValue.count)))
            }
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
        notificationLabel.text = "Start typing to search"
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
        threadManager?.cancel()
        threadManager = ThreadManager(resourse: repositories.last?.cursor, code: { cursor in
            self.networkService.searchRepositories(query: query, sort: sort, first: 15, after: (cursor as? String), success: {[weak self] response in
                if self?.searchController?.isActive == false && self?.currentQueryString != "" { return }
                let correctQueryString = response.0 == self?.currentQueryString
                if correctQueryString {
                    self?.currentQueryString = query
                    let fragments = response.1.search.edges?.map {$0?.node?.fragments}
                    let repositories = fragments as? [Repository] ?? []
                    self?.cache[query]?.append(contentsOf: repositories)
                    self?.results.append(contentsOf: repositories)
                }
                }, failure: { [weak self] error in
                    self?.notificationLabel.isHidden = false
                    self?.notificationLabel.text = error.localizedDescription
            })
        })
        threadManager?.execute()
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
            notificationLabel.isHidden = true
            tableView.isHidden = false
            results.removeAll()
            repositories.removeAll()
            currentQueryString = searchText
            if let cache = cache[searchText], !cache.isEmpty {
                threadManager?.cancel()
                results = cache
            } else {
                cache[searchText] = []
                searchRepositories(query: searchText)
            }
            tableView.reloadData()
        } else {
            tableView.isHidden = true
            notificationLabel.isHidden = false
            notificationLabel.text = "Start typing to search"
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
        if let cell_ = tableView.dequeueReusableCell(withIdentifier: "cell") {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = popupWebView.popupView.URL(string: repositories[indexPath.row].url)
        popupWebView.show()
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
        title = "GitHub Repository"
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
        view.addSubview(notificationLabel)
        
        view.backgroundColor = tableView.backgroundColor
        
        cntKeyboard = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        cnts += [tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)]
        cnts += [tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)]
        cnts += [tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)]
        cnts += [cntKeyboard]
        cnts += [notificationLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)]
        cnts += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: ["label": notificationLabel])
        
        NSLayoutConstraint.activate(cnts)
    }
}
