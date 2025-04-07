//
//  KioskUseCase.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

final class KioskUseCase: KioskUseCaseInterface{
    private let repository: KioskRepositoryInterface
    
    init(repository: KioskRepositoryInterface) {
        self.repository = repository
    }
}
