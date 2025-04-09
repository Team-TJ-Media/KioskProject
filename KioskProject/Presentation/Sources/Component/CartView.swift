//
//  CartView.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit
import SnapKit
import Then

class CartView: UIStackView {
    var orderCount: Int
    
    let tableView = CartTableView()
    
    private let titleLabel = UILabel().then {
        $0.text = " 장바구니"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let titleStackView = UIStackView()
    
    private lazy var orderCountLabel = UILabel().then {
        $0.text = "총 \(orderCount)개 "
        $0.font = .systemFont(ofSize: 16)
    }
    
    init(orderCount: Int = 3) {
        self.orderCount = orderCount
        super.init(frame: .zero)
        
        [titleLabel, orderCountLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        titleStackView.axis = .horizontal
        titleStackView.distribution = .equalSpacing
        titleStackView.alignment = .bottom
        
        [titleStackView, tableView].forEach {
            addArrangedSubview($0)
        }
        axis = .vertical
        spacing = 4
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CartTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .grouped)
        
        backgroundColor = .white
        
        layer.borderWidth = BorderStyle.width
        layer.borderColor = BorderStyle.color
        layer.cornerRadius = BorderStyle.cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
