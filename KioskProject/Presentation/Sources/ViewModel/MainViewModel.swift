//
//  MainViewModel.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

final class MainViewModel{
    
    private let useCase: KioskUseCaseInterface
    
    init(useCase: KioskUseCaseInterface) {
        self.useCase = useCase
        
        fetchProducts(type: .tablets)
    }
    
    func fetchProducts(type: ProductType) {
        Task{
            do{
                let result = try await useCase.fetchProducts(type: type)
                print(result)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
