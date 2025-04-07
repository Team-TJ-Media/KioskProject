//
//  KioskError.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

enum KioskServiceError: Error{
    case networkError
    case invaildURL
    case decodingError
}
