//
//  CartItem.swift
//  KioskProject
//
//  Created by 유영웅 on 4/9/25.
//

import Foundation

struct CartItem: Identifiable, Equatable {
    let product: Product
    var count: Int
    var totalPrice:Double{
        return product.price * Double(count)
    }
    
    var id: String {
        return "\(product.id)"
    }

    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.product.id == rhs.product.id
    }
}
