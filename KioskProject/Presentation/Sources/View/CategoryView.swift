//
//  CategoryView.swift
//  KioskProject
//
//  Created by 백래훈 on 4/7/25.
//

import UIKit

final class CategoryView: UISegmentedControl {
    
    private let categories = ["스마트폰", "노트북", "태블릿"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSegment()
        configureStyle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSegment() {
        // 세그먼트 초기화
        categories.enumerated().forEach { index, title in
            self.insertSegment(withTitle: title, at: index, animated: false)
        }
        self.selectedSegmentIndex = 0
    }
    
    private func configureStyle() {
        self.backgroundColor = .systemGray6
        self.selectedSegmentTintColor = .black
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        let normalAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        let selectedAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        self.setTitleTextAttributes(normalAttributes, for: .normal)
        self.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
