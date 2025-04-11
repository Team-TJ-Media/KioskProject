//
//  CartTableViewCell 2.swift
//  KioskProject
//
//  Created by 권순욱 on 4/9/25.
//


import UIKit
import SnapKit
import Then

class TotalAmountCell: UITableViewCell {
    
    static let identifier = "TotalAmountCell"
    
    private let titleLabel = UILabel().then {
        $0.text = "주문금액"
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    private let orderamountsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(amount:Int){
        orderamountsLabel.text = amount.wonFormatter()
    }
    
    private func setupUI() {
        [titleLabel, orderamountsLabel]
            .forEach { addSubview($0) }
        
        setConstraints()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        orderamountsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-4)
        }
    }
}
