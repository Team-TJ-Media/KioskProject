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
    static let reuseIdentifier = "TotalAmountCell"
    
    var orderAmounts: Int = 0
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "주문금액"
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    private lazy var orderamountsLabel = UILabel().then {
        $0.text = "\(wonFormatter(orderAmounts))"
        $0.font = .systemFont(ofSize: 14, weight: .bold)
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
    
    func setupUI(orderAmounts: Int) {
    
        self.orderAmounts = orderAmounts
        
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

    private func wonFormatter(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}
