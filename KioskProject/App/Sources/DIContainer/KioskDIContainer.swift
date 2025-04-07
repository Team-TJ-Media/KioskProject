//
//  KioskDIContainer.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation

final class KioskDIContainer: KioskDIContainerInterface{
    func makeMainViewModel() -> MainViewModel {
        let repository = KioskRepository()
        let useCase = KioskUseCase(repository: repository)
        let viewModel = MainViewModel(useCase: useCase)
        return viewModel
    }
}
