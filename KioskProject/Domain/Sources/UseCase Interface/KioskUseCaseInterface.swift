//
//  KioskUseCaseProtocol.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

protocol KioskUseCaseInterface{
    func fetchProducts(type: ProductType) async throws -> [Product]
}
