//
//  CartTableViewCell.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit
import SnapKit
import Then

class CartTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CartTableViewCell"
    
    var productName: String = ""
    var orderCount: Int = 0
    var orderAmounts: Int = 0
    
    private lazy var productNameLabel = UILabel().then {
        $0.text = productName
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var orderCountLabel = UILabel().then {
        $0.text = "\(orderCount)"
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var orderamountsLabel = UILabel().then {
        $0.text = "\(wonFormatter(orderAmounts))"
        $0.font = .systemFont(ofSize: 14)
    }
    
    let incrementButton = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    let decrementButton = UIButton().then {
        $0.setTitle("-", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(productName: String, orderCount: Int, orderAmounts: Int) {
        self.productName = productName
        self.orderCount = orderCount
        self.orderAmounts = orderAmounts
        
        [productNameLabel, orderCountLabel, orderamountsLabel, incrementButton, decrementButton]
            .forEach { addSubview($0) }
        
        setConstraints()
    }
    
    private func setConstraints() {
        productNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        orderCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        orderamountsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        decrementButton.snp.makeConstraints {
            $0.trailing.equalTo(orderCountLabel.snp.leading).offset(-8)
            $0.centerY.equalTo(orderCountLabel.snp.centerY)
        }
        
        incrementButton.snp.makeConstraints {
            $0.leading.equalTo(orderCountLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(orderCountLabel.snp.centerY)
        }
    }

    private func wonFormatter(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}
