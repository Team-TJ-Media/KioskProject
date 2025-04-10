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
    
    let paymentStackView = PaymentStackView()
    
    private let titleLabel = UILabel().then {
        $0.text = "최종금액"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureSubView(){
        addSubview(titleLabel)
        addSubview(paymentStackView)
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
    
    private let totalAmountView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private let deliveryFeeView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    private let totalAmountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .darkGray
        
    }
    
    private let deliveryFeeLabel = UILabel().then {
        $0.text = 2500.wonFormatter()
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .darkGray
    }
    
    private let finalPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 27, weight: .semibold)
        $0.textColor = .black
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = BorderStyle.width
        layer.borderColor = BorderStyle.color
        layer.cornerRadius = BorderStyle.cornerRadius
        configureSubView()
        setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(totalAmount:Int){
        totalAmountLabel.text = totalAmount.wonFormatter()
        finalPriceLabel.text = (totalAmount + 2500).wonFormatter()
    }
    private func configureSubView(){
        [totalAmountTitle, totalAmountLabel].forEach {
            totalAmountView.addArrangedSubview($0)
        }
        
        [deliveryFeeTitle, deliveryFeeLabel].forEach {
            deliveryFeeView.addArrangedSubview($0)
        }
        
        [totalAmountView, deliveryFeeView, finalPriceLabel].forEach {
            addSubview($0)
        }
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
}
