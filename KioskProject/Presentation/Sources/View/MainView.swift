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
    
    let mainScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    // 스크롤뷰 안에 잡혀질 컨텐트 뷰
    let mainContentView = UIView()
    
    let titleView = TitleView()
    let categoryView = CategoryView(frame: .zero)
    let tableView = UITableView()                                                                           //삭제할 것
    let totalLabel = UILabel()
    let numLabel = UILabel()
    let productCollectionView = ProductCollectionView()
    let pageControl = UIPageControl().then {
        $0.numberOfPages = 3 // 페이지 수 동적 바인딩 필요
        $0.currentPage = 0
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .systemGray3
    }
    
    let cartView = CartView()
    let paymentView = PaymentView()
    
    let orderButtonView = OrderButtonView()

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
        self.backgroundColor = .systemBackground
        
        [mainScrollView, orderButtonView].forEach {
            self.addSubview($0)
        }
        
        mainScrollView.addSubview(mainContentView)
        
        [titleView, categoryView, productCollectionView, pageControl, cartView, paymentView].forEach {
            mainContentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        let spacing: CGFloat = 16
        let totalSpacing = spacing * 3
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2
        let height = width * 2 + totalSpacing
        // productNameLabel height: 25
        // priceLabel hegith: 22
        // label spacing: 8
//        let height = (width * 2) + totalSpacing + (47 * 2) + (8 * 3 * 2)
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(orderButtonView.snp.top)
        }
        
        mainContentView.snp.makeConstraints {
            $0.edges.equalTo(mainScrollView.contentLayoutGuide)
            $0.width.equalTo(mainScrollView.frameLayoutGuide)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        productCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(productCollectionView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        cartView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        paymentView.snp.makeConstraints {
            $0.top.equalTo(cartView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        orderButtonView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-8)
            $0.leading.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
}
