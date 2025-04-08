//
//  CartView.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit
import Then

class CartView: UIView {
    private let titleLabel = UILabel().then {
        $0.text = "장바구니"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    private let tableView = CartTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(tableView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
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
