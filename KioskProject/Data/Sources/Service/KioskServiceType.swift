//
//  KioskServiceType.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

enum KioskServiceType{
    case fetchProducts(String)
}

extension KioskServiceType{
    var baseURL: String{
        switch self{
        case .fetchProducts: "https://dummyjson.com/"
        }
    }
    
    var path: String{
        switch self{
        case .fetchProducts(let category): "products/category/\(category)"
        }
    }
}
