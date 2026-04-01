//
//  ViewController.swift
//  MVVM Demo
//
//  Created by Johnson on 30/03/26.
//

import UIKit

final class UserViewController: UIViewController {
    
    private let tableView = UITableView()
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
        bindViewModel()
        
        viewModel.fetchUsers()
    }
    
    private func setupTableView() {
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    private func bindViewModel() {
        
        viewModel.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
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
