//
//  ViewController.swift
//  FriTest
//
//  Created by Leo on 12/2/24.
//

import UIKit
import Nuke
import Combine

class HomeVC: UIViewController {
    private var dataSource: UITableViewDiffableDataSource<Int, MealAPI>?
    private var snapshot: NSDiffableDataSourceSnapshot<Int, MealAPI>?
    private var tableView: UITableView = UITableView()
    private var viewModel: HomeViewModel?
    private var cancellabe: Set<AnyCancellable> = Set<AnyCancellable>()
    @IBOutlet weak var wrapperView: UIView!
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadAPIData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        wrapperView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: 0).isActive = true
        tableView.allowsSelection = false
        tableView.refreshControl = refresher
        
        tableView.register(UINib(nibName: "MealTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MealTableViewCell")
        configureDataSource()
        initViewModel()
    }
    
    func initViewModel() {
        viewModel = HomeViewModel()
        
        viewModel?.dataStatus
            .dropFirst()
            .sink { [weak self] data in
                switch data {
                case .intialize:
                    self?.tableView.refreshControl?.endRefreshing()
                case .loading:
                    self?.tableView.refreshControl?.beginRefreshing()
                case .error:
                    self?.tableView.refreshControl?.endRefreshing()
                    let alert = UIAlertController(title: "Error", message: "No se ha podido obtener la información", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    }))
                    self?.present(alert, animated: true, completion: nil)
                    self?.createSnapshot(Array(self?.viewModel?.mealsData ?? []))
                case .refresh:
                    self?.createSnapshot(Array(self?.viewModel?.mealsData ?? []))
                case .success:
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.tableView.refreshControl = nil
                    
                    self?.tableView.refreshControl?.endRefreshing()
                    let alert = UIAlertController(title: "FriTest App", message: "Se ha completado la carga de información", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    }))
                }
            }
            .store(in: &cancellabe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchData()
    }
    
    @objc func loadAPIData() {
    }
}

// MARK: - DataSource & Snapshot
extension HomeVC {
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, meal) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell
            cell?.setupView(meal: meal)
            return cell
        })
    }
    
    func createSnapshot(_ data: [MealAPI]) {
        snapshot = NSDiffableDataSourceSnapshot()
        snapshot?.appendSections([1])
        snapshot?.appendItems(data)
        
        if let snapshot = snapshot {
            dataSource?.apply(snapshot)
        }
    }
}
