//
//  Empty.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

final class KioskService{
    
    func request<T: Decodable>(_ type: KioskServiceType) async throws -> T{
        guard let url = URL(string: type.baseURL + type.path) else {
            throw KioskServiceError.invaildURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw KioskServiceError.networkError
        }
        
        do{
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw KioskServiceError.decodingError
        }
    }
}
