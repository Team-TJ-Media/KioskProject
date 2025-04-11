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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupSegment() {
        // 세그먼트 초기화
        categories.enumerated().forEach { index, title in
            self.insertSegment(withTitle: title, at: index, animated: true)
        }
        
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        self.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        self.selectedSegmentIndex = 0
    }
    
    private func configureStyle() {
        
        let normalAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        let selectedAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        self.setTitleTextAttributes(normalAttributes, for: .normal)
        self.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
