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
    
    let categoryView = CategoryView(frame: .zero)
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        [categoryView, productCollectionView, pageControl].forEach {
            self.addSubview($0)
        }
    }
    
    private func setConstraints() {
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2
        // 여기서 item의 높이를 지정해주고 있는데 현재는 임의로 가로 + 60으로 지정해주는 중
        let height = width + 70
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        productCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(height * 2 + spacing * 3)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(productCollectionView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
}
