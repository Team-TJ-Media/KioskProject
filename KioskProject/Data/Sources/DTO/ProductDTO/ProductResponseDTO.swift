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
        return Product(id: id,
                      title: title,
                      description: description,
                      category: category,
                      price: price,
                      discountPercentage: discountPercentage,
                      rating: rating,
                      stock: stock,
                      tags: tags,
                      brand: brand,
                      sku: sku,
                      weight: weight,
                      dimensions: dimensions.toEntity(),
                      warrantyInformation: warrantyInformation,
                      shippingInformation: shippingInformation,
                      availabilityStatus: availabilityStatus,
                      reviews: reviews.map{$0.toEntity()},
                      returnPolicy: returnPolicy,
                      minimumOrderQuantity: minimumOrderQuantity,
                      meta: meta.toEntity(),
                      images: images,
                      thumbnail: thumbnail)
    }
}

struct DimensionsResponse: Codable {
    let width, height, depth: Double
    
    func toEntity() -> Dimensions{
        return Dimensions(width: width,
                          height: height,
                          depth: depth)
    }
}

struct ReviewResponse: Codable {
    let rating: Int
    let comment, date, reviewerName, reviewerEmail: String
    
    func toEntity() -> Review{
        return Review(rating: rating,
                      comment: comment,
                      date: date,
                      reviewerName: reviewerName,
                      reviewerEmail: reviewerEmail)
    }
}

struct MetaResponse: Codable {
    let createdAt, updatedAt, barcode: String
    let qrCode: String
    
    func toEntity() -> Meta{
        return Meta(createdAt: createdAt,
                    updatedAt: updatedAt,
                    barcode: barcode,
                    qrCode: qrCode)
    }
}
