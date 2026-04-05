//
//  ViewController.swift
//  MVVM Demo
//
//  Created by Johnson on 30/03/26.
//

import UIKit

final class UserViewController: UIViewController {
    
    private let tableView = UITableView()
    private let loadingLabel = UILabel()
    private let viewModel : UserViewModel
    
    //Inject ViewModel
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Users"
        view.backgroundColor = .white
        
        setupTableView()
        setupLoadingUI()
        bindViewModel()
        
        viewModel.fetchUsers()
    }
    
    private func setupTableView() {
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    private func setupLoadingUI() {
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = .systemBlue
        loadingLabel.textAlignment = .center
        loadingLabel.font = .boldSystemFont(ofSize: 18)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loadingLabel.isHidden = true
    }
    
    private func bindViewModel() {
        
        viewModel.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onStateChange = { [weak self] state in
            switch state {
            case .idle:
                self?.loadingLabel.isHidden = true
                self?.tableView.alpha = 1.0
            case .loading:
                self?.loadingLabel.text = "Loading..."
                self?.loadingLabel.isHidden = false
                self?.tableView.alpha = 0.3
            case .refreshing:
                self?.loadingLabel.text = "Refreshing..."
                self?.loadingLabel.isHidden = false
                self?.tableView.alpha = 0.5
            }
        }
    }
}

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = viewModel.userName(at: indexPath.row)
        
        return cell
    }
}
