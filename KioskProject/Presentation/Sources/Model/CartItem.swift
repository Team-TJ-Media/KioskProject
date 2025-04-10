//
//  CartItem.swift
//  KioskProject
//
//  Created by 유영웅 on 4/9/25.
//

import Foundation

//MARK: 장바구니 아이템
struct CartItem: Identifiable, Equatable {
    let product: Product
    var count: Int
    var totalPrice:Int{
        return product.price * count
    }
    
    var id: String {
        return "\(product.id)"
    }

    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.product.id == rhs.product.id
    }
}
