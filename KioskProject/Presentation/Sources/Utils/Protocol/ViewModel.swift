//
//  ViewModel.swift
//  KioskProject
//
//  Created by 유영웅 on 4/10/25.
//

import Foundation
import RxSwift

//MARK: ViewModel에서 필수적으로 채택해야하는 프로토콜 (Input-Ouput 패턴)
protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
