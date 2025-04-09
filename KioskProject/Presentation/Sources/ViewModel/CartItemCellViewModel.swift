//
//  CartItemCellViewModel.swift
//  KioskProject
//
//  Created by 유영웅 on 4/8/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CartItemCellViewModel: ViewModel {

    struct Input {
        let increaseTapped: Observable<Void>
        let decreaseTapped: Observable<Void>
    }

    struct Output {
        let addFromCart: Observable<Product>
        let countText: Observable<String>
        let removeFromCart: Observable<Product>
    }

    var disposeBag = DisposeBag()

    private let count = BehaviorRelay<Int>(value: 1)
    private let removeRelay = PublishRelay<Product>()
    
    let cartItem: Product

    init(cartItem: Product) {
        self.cartItem = cartItem
    }

    
    func transform(input: Input) -> Output {
        input.increaseTapped
            .withLatestFrom(count)
            .map { $0 + 1 }
            .bind(to: count)
            .disposed(by: disposeBag)

        input.decreaseTapped
            .withLatestFrom(count)
            .map { $0 > 0 ? $0 - 1 : 0 }
            .do(onNext: { [weak self] newCount in
                guard let self = self else { return }
                if newCount == 0 {
                    self.removeRelay.accept(cartItem)
                }
            })
            .bind(to: count)
            .disposed(by: disposeBag)

        return Output(
            addFromCart: .just(cartItem),
            countText: count
                .map { "\($0)" }
                .asObservable(),
            removeFromCart: removeRelay.asObservable()
        )
    }
}
