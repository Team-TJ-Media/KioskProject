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
        let increaseTapped: Observable<Int>
        let decreaseTapped: Observable<Int>
        let removeTapped: Observable<Product>
    }

    struct Output {
        let setInfo: BehaviorSubject<[Product]>
        let setCart: BehaviorRelay<[CartItem]>
    }

    var disposeBag = DisposeBag()

    private let products = BehaviorSubject<[Product]>(value: [])
    private let cartItems = BehaviorRelay<[CartItem]>(value: [])
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
            if !cartItems.value.contains(where: { $0.product.id == product.id }) {
                cartItems.accept(cartItems.value + [CartItem(product: product, count: 1)])
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func increaseCellNum(index:Int) {
        var items = self.cartItems.value
        guard items.indices.contains(index) else { return }
        items[index].count += 1
        self.cartItems.accept(items)
    }
    
    private func decreaseCellNum(index:Int) {
        var items = self.cartItems.value
        guard items.indices.contains(index) else { return }
        items[index].count -= 1
        if items[index].count <= 0 {
            items.remove(at: index)
        }
        self.cartItems.accept(items)
    }
    
    private func removeCell(product:Product) {
        var items = self.cartItems.value
        items.removeAll { $0.product.id == product.id }
        self.cartItems.accept(items)
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

        input.increaseTapped
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                increaseCellNum(index: index)
            })
            .disposed(by: disposeBag)

        input.decreaseTapped
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                decreaseCellNum(index: index)
            })
            .disposed(by: disposeBag)

        input.removeTapped
            .subscribe(onNext: { [weak self] product in
                guard let self else { return }
                removeCell(product: product)
            })
            .disposed(by: disposeBag)

        return Output(setInfo: products, setCart: cartItems)
    }
}
