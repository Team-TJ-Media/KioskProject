//
//  MainView.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import UIKit

import SnapKit

import Then

final class MainView: UIView {
    
    let titleView = TitleView()
    let orderButtonView = OrderButtonView()
    
    let categoryView = CategoryView(frame: .zero)
    let tableView = UITableView()                                                                           //삭제할 것
    let totalLabel = UILabel()
    let productCollectionView = ProductCollectionView()
    
    let pageControl = UIPageControl().then {
        $0.numberOfPages = 3 // 페이지 수 동적 바인딩 필요
        $0.currentPage = 0
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .systemGray3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setConstraints()
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)              //삭제할 것
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        [titleView, orderButtonView, categoryView, productCollectionView, tableView, totalLabel, pageControl].forEach { //삭제할 것
            self.addSubview($0)
        }
    }
    
    private func setConstraints() {
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2
        // 여기서 item의 높이를 지정해주고 있는데 현재는 임의로 가로 + 60으로 지정해주는 중
        let height = width + 70
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        productCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)//.offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
//            $0.height.equalTo(height * 2 + spacing * 3)
            $0.height.equalToSuperview().dividedBy(2)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(productCollectionView.snp.bottom)//.offset(8)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {                                                     //삭제할 것
            $0.top.equalTo(pageControl.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        totalLabel.snp.makeConstraints { 
            $0.top.equalTo(tableView.snp.bottom)
        }
        orderButtonView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
    }
}
