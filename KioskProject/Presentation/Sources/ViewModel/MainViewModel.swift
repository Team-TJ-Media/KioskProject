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

final class MainViewModel: ViewModel{
    
    
    struct Input {
        let selectedIndex: Observable<Int>
        let selectedCell: Observable<Int>
    }
    
    struct Output {
        let setInfo: BehaviorSubject<[Product]>
        let setItem: PublishSubject<Product>
    }
    
    var disposeBag = DisposeBag()
    
    
    private let products = BehaviorSubject<[Product]>(value:[])
    private let product = PublishSubject<Product>()
    
    private let useCase: KioskUseCaseInterface
    
    init(useCase: KioskUseCaseInterface) {
        self.useCase = useCase
    }
    
    private func fetchProducts(type: ProductType) {
        Task{
            do{
                let products = try await useCase.fetchProducts(type: type)
                self.products.onNext(products)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func addToCart(index:Int){
        do{
            let products = try products.value()
            let product = products[index]
            self.product.onNext(product)
        }catch{
            print(error.localizedDescription)
        }
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
            .withLatestFrom(products) { index, products in
                products[index]
            }
            .bind(to: product)
            .disposed(by: disposeBag)
        return Output(setInfo: products, setItem: product)
    }
}

