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
        
        [confirmButton, cancelButton].forEach { addArrangedSubview($0) }
        axis = .vertical
        spacing = 8
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
