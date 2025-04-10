//
//  AlertType.swift
//  KioskProject
//
//  Created by 백래훈 on 4/9/25.
//

import Foundation

enum AlertType {
    case emptyCart
    case confirmCancel
    case confirmOrder(Int)
    
    var title: String {
        switch self {
        case .emptyCart:
            return "주문 실패"
        case .confirmCancel:
            return "주문 취소"
        case .confirmOrder:
            return "주문 확인"
        }
    }
    
    var message: String {
        switch self {
        case .emptyCart:
            return "장바구니가 비어있습니다.\n먼저 상품을 장바구니에 담아주세요!"
        case .confirmCancel:
            return "장바구니 내역이 삭제됩니다.\n정말 취소하시겠습니까?"
        case .confirmOrder(let price):
            return "총 결제 금액은 \(price.wonFormatter())입니다. 결제하시겠습니까?"
        }
    }
}
