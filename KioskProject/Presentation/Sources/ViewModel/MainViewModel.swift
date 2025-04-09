//
//  MainViewModel.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

final class MainViewModel: ViewModel {

    struct Input {
        let selectedIndex: Observable<Int>
        let selectedCell: Observable<Int>
    }

    struct Output {
        let setInfo: BehaviorSubject<[Product]>
        let setCart: BehaviorRelay<[Product]>
    }

    var disposeBag = DisposeBag()

    private let products = BehaviorSubject<[Product]>(value: [])
    private let cartItems = BehaviorRelay<[Product]>(value: [])

    private let useCase: KioskUseCaseInterface


    init(useCase: KioskUseCaseInterface) {
        self.useCase = useCase
    }

    private func fetchProducts(type: ProductType) {
        Task {
            do {
                let products = try await useCase.fetchProducts(type: type)
                self.products.onNext(products)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func addToCart(index: Int) {
        do {
            let products = try products.value()
            let product = products[index]
            if !cartItems.value.contains(product){
                cartItems.accept(cartItems.value + [product])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeFromCart(product: Product) {
        var items = cartItems.value
        items.removeAll { $0.id == product.id }
        cartItems.accept(items)
    }
    
    func transform(input: Input) -> Output {
        input.selectedIndex
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                switch index {
                case 0: self.fetchProducts(type: .smartphones)
                case 1: self.fetchProducts(type: .laptops)
                case 2: self.fetchProducts(type: .tablets)
                default: break
                }
            })
            .disposed(by: disposeBag)

        input.selectedCell
            .subscribe(onNext: { [weak self] index in
                self?.addToCart(index: index)
            })
            .disposed(by: disposeBag)

        return Output(setInfo: products, setCart: cartItems)
    }
}
