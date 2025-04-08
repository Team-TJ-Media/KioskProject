//
//  Laptop.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

struct Product {
    let id: Int
    let title, description, category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let tags: [String]
    let brand, sku: String
    let weight: Int
    let dimensions: Dimensions
    let warrantyInformation, shippingInformation, availabilityStatus: String
    let reviews: [Review]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: Meta
    let images: [String]
    let thumbnail: String
}

struct Dimensions {
    let width, height, depth: Double
}

struct Review {
    let rating: Int
    let comment, date, reviewerName, reviewerEmail: String
}

struct Meta {
    let createdAt, updatedAt, barcode: String
    let qrCode: String
}
