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
        
        setTableViewData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableViewData() {
        mainView.cartView.tableView.dataSource = self
        mainView.cartView.tableView.delegate = self
        
        mainView.cartView.tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        mainView.cartView.tableView.register(TotalAmountCell.self, forCellReuseIdentifier: TotalAmountCell.reuseIdentifier)
        
        mainView.cartView.tableView.separatorStyle = .none
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 각 상품별 구매수량 및 금액, 총 금액
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { // 각 상품별 구매수량 및 금액
            return 4
        } else { // 총 금액
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as! CartTableViewCell
            cell.setupUI(productName: "iPhone 15", orderCount: 1, orderAmounts: 300000)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountCell.reuseIdentifier, for: indexPath) as! TotalAmountCell
            cell.setupUI(orderAmounts: 600000)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 8
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 8
        }
    }
}
