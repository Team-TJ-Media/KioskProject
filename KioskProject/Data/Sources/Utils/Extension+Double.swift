//
//  Extension+Double.swift
//  KioskProject
//
//  Created by 유영웅 on 4/10/25.
//

import Foundation

//MARK: 달러 -> 원화
extension Double{
    func exchnageAmount() -> Int {
        return Int(self * 1457.05)
    }
}
