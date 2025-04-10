//
//  Extension+Int.swift
//  KioskProject
//
//  Created by 유영웅 on 4/10/25.
//

import Foundation

//MARK: 숫자 -> 원화 표가범 (ex: 10000 -> ₩10,000)
extension Int{
    func wonFormatter() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
