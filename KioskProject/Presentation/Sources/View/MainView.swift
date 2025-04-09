//
//  MainView.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import UIKit
import SnapKit

final class MainView: UIView {
    let titleView = TitleView()
    let orderButtonView = OrderButtonView()
    let cartView = CartView()
    let paymentView = PaymentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        [titleView, orderButtonView].forEach {
            addSubview($0)
        }
        
        addSubview(cartView)
        addSubview(paymentView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        titleView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        cartView.snp.makeConstraints {
            // $0.top.equalTo(titleView.snp.bottom).offset(8)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(180)
        }
        
        paymentView.snp.makeConstraints {
            $0.top.equalTo(cartView.snp.bottom).offset(8)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.bottom.equalTo(orderButtonView.snp.top).offset(-14)
        }
        
        orderButtonView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
    }
}
