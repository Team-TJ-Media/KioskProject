//
//  OrderButtonView.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit

class OrderButtonView: UIStackView {
    
    private let confirmButton = OrderButton(orderStatus: .confirm)
    private let cancelButton = OrderButton(orderStatus: .cancel)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [confirmButton, cancelButton].forEach {
            self.addArrangedSubview($0)
        }
        
        self.axis = .vertical
        self.spacing = 8
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
