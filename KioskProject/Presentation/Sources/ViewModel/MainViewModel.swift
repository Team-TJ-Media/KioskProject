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
    }
}
