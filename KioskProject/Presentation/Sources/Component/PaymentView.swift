//
//  PaymentView.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit
import Then

class PaymentView: UIView {
    private let titleLabel = UILabel().then {
        $0.text = "최종금액"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    private let paymentStackView = PaymentStackView(totalAmounts: 0, deliveryFee: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(paymentStackView)
        
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
        
        paymentStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

class PaymentStackView: UIStackView {
    var totalAmounts: Int = 0
    var deliveryFee: Int = 0
    
    init(totalAmounts: Int, deliveryFee: Int) {
        self.totalAmounts = totalAmounts
        self.deliveryFee = deliveryFee
        
        super.init(frame: .zero)
        
        layer.borderWidth = BorderStyle.width
        layer.borderColor = BorderStyle.color
        layer.cornerRadius = BorderStyle.cornerRadius
        
        snp.makeConstraints {
            $0.height.equalTo(120)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
