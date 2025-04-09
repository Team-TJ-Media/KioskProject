//
//  PaymentView.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit
import SnapKit
import Then

class PaymentView: UIView {
    private let titleLabel = UILabel().then {
        $0.text = "최종금액"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    private let paymentStackView = PaymentStackView()
    
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
    private let totalAmountTitle = UILabel().then {
        $0.text = "상품 금액"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .gray
    }
    
    private let deliveryFeeTitle = UILabel().then {
        $0.text = "배송비"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .gray
    }
    
    private lazy var totalAmountLabel = UILabel().then {
        $0.text = "\(wonFormatter(totalAmounts))"
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .darkGray
    }
    
    private lazy var deliveryFeeLabel = UILabel().then {
        $0.text = "\(wonFormatter(deliveryFee))"
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .darkGray
    }
    
    private lazy var finalPriceLabel = UILabel().then {
        $0.text = "\(wonFormatter(totalAmounts + deliveryFee))"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
    }
    
    private let totalAmountView = UIStackView()
    private let deliveryFeeView = UIStackView()
    
    var totalAmounts: Int
    var deliveryFee: Int
    
    init(totalAmounts: Int = 600000, deliveryFee: Int = 2500) {
        self.totalAmounts = totalAmounts
        self.deliveryFee = deliveryFee
        
        super.init(frame: .zero)
        
        layer.borderWidth = BorderStyle.width
        layer.borderColor = BorderStyle.color
        layer.cornerRadius = BorderStyle.cornerRadius
        
        [totalAmountTitle, totalAmountLabel].forEach {
            totalAmountView.addArrangedSubview($0)
        }
        totalAmountView.axis = .horizontal
        totalAmountView.distribution = .equalSpacing
        
        [deliveryFeeTitle, deliveryFeeLabel].forEach {
            deliveryFeeView.addArrangedSubview($0)
        }
        deliveryFeeView.axis = .horizontal
        deliveryFeeView.distribution = .equalSpacing
        
        [totalAmountView, deliveryFeeView, finalPriceLabel].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(120)
        }
        
        totalAmountView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        deliveryFeeView.snp.makeConstraints {
            $0.top.equalTo(totalAmountView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        finalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(deliveryFeeView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func wonFormatter(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}
