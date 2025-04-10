//
//  Empty.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation


struct ProductResponseDTO: Codable {
    let products: [ProductResponse]
}

struct ProductResponse: Codable {
    let id: Int
    let title, description, category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let tags: [String]
    let brand, sku: String
    let weight: Int
    let dimensions: DimensionsResponse
    let warrantyInformation, shippingInformation, availabilityStatus: String
    let reviews: [ReviewResponse]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: MetaResponse
    let images: [String]
    let thumbnail: String
    
    func toEntity() -> Product{
        return Product(id: id, title: title, price: price.exchnageAmount(), thumbnail: thumbnail)
    }
}

struct DimensionsResponse: Codable {
    let width, height, depth: Double
}

struct ReviewResponse: Codable {
    let rating: Int
    let comment, date, reviewerName, reviewerEmail: String
}

struct MetaResponse: Codable {
    let createdAt, updatedAt, barcode: String
    let qrCode: String
}
