//
//  OrderButtonView.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit

class OrderButtonView: UIStackView {
    
    let confirmButton = OrderButton(orderStatus: .confirm)
    let cancelButton = OrderButton(orderStatus: .cancel)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [cancelButton, confirmButton].forEach {
            self.addArrangedSubview($0)
        }
        
        self.axis = .horizontal
        self.spacing = 16
        self.distribution = .fillEqually
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
