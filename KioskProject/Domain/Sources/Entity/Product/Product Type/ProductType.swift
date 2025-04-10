//
//  ProductType.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

enum ProductType: String{
    case laptops
    case tablets
    case smartphones
    
    var index:Int {
        switch self {
        case .smartphones: 0
        case .laptops: 1
        case .tablets: 2
        }
    }
}
