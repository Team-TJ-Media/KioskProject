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
    private let titleLabel = UILabel().then {
        $0.text = " 장바구니"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .bottom
    }
    
    var orderCount: Int
    
    private lazy var orderCountLabel = UILabel().then {
        $0.text = "총 \(orderCount)개"
        $0.font = .systemFont(ofSize: 16)
    }
    
    let cartTableView = CartTableView()
    
    var tableViewHeightConstraint: Constraint?
    
    init(orderCount: Int = 3) {
        self.orderCount = orderCount
        super.init(frame: .zero)
        
        self.axis = .vertical
        self.spacing = 4
        
        configureView()
        setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        [titleStackView, cartTableView].forEach {
            self.addArrangedSubview($0)
        }
        
        [titleLabel, orderCountLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        cartTableView.snp.makeConstraints {
            tableViewHeightConstraint = $0.height.equalTo(0).constraint
        }
    }
    
    func updateTableViewHeight() {
        cartTableView.layoutIfNeeded()
        
        let contentHeight = cartTableView.contentSize.height
        
        tableViewHeightConstraint?.update(offset: contentHeight)
    }
}

class CartTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .grouped)
        
        backgroundColor = .white
        
        layer.borderWidth = BorderStyle.width
        layer.borderColor = BorderStyle.color
        layer.cornerRadius = BorderStyle.cornerRadius
        
        self.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
