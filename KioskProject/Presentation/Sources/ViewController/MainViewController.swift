//
//  MainViewController.swift
//  TeamProject
//
//  Created by 백래훈 on 4/3/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    
    let mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    init(DIContainer: KioskDIContainerInterface) {
        self.viewModel = DIContainer.makeMainViewModel()
        super.init(nibName: nil, bundle: nil)
        
        mainView.cartView.tableView.dataSource = self
        mainView.cartView.tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as! CartTableViewCell
        cell.setupUI(productName: "iPhone 15", orderCount: 1, orderAmounts: 300000)
        return cell
    }
}
