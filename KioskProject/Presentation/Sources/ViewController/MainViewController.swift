//
//  MainViewController.swift
//  TeamProject
//
//  Created by 백래훈 on 4/3/25.
//

import UIKit

import SnapKit

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    private let viewModel: MainViewModel
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.productCollectionView.delegate = self
        mainView.productCollectionView.dataSource = self
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    // 페이징(스크롤)을 위한 메서드, 2행의 상품이 지나가면 멈춤
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.mainView.productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = (layout.itemSize.width * 2) + (layout.minimumLineSpacing * 2)
        
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
    
    // 페이징(스크롤) 시 호출되는 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = self.mainView.productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = (layout.itemSize.width * 2) + (layout.minimumLineSpacing * 2)

        // 반 페이지 이상 넘어가면 현재 페이지를 업데이트
        let currentPage = Int((scrollView.contentOffset.x + (0.5 * cellWidthIncludingSpacing)) / cellWidthIncludingSpacing)
        mainView.pageControl.currentPage = currentPage
    }
    
}
