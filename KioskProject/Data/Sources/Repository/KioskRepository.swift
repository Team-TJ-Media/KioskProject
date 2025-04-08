//
//  KioskRepository.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

final class KioskRepository: KioskRepositoryInterface{
    
    private let serivce: KioskService = KioskService()
    
    func fetchProducts(type: ProductType) async throws -> [Product]{
        let response: ProductResponseDTO = try await serivce.request(.fetchProducts(type.rawValue))
        return response.products.map{$0.toEntity()}
    }
}
