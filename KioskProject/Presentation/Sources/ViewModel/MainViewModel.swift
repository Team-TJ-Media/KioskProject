//
//  MainViewModel.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: MainViewModel
final class MainViewModel: ViewModel {
    
    struct Input {
        let selectedSegment: Observable<Int>                    //세그먼트 input
        let selectedCell: Observable<Int>                       //셀 input
        let increaseTapped: Observable<Int>                     //장바구니에서 매뉴 수량 증가 input
        let decreaseTapped: Observable<Int>                     //장바구니에서 매뉴 수량 감소 input
        let removeTapped: Observable<Product>                   //장바구니에서 매뉴 수량 0시 삭제 input
        let orderCancelTapped: ControlEvent<Void>               //주문취소 input
        let orderTapped: ControlEvent<Void>                     //주문확인 input
    }
    
    struct Output {
        let setInfo: BehaviorSubject<[Product]>                 //메뉴 리스트(컬렉션뷰) ouput
        let setCart: BehaviorRelay<[CartItem]>                  //장바구니 리스트(테이블뷰) ouput
        let setTotalAmount:BehaviorRelay<Int>                   //총 금액 output
        let setTotalNum:BehaviorRelay<Int>                      //총 개수 output
        let showAlert: Observable<AlertType>                    //Alert
    }
    
    // Cell 이벤트 Relay로 ViewModel에 명령 전달 - (수량 증가/감소, 삭제 이벤트)
    struct CellInput {
        let increaseRelay = PublishRelay<Int>()
        let decreaseRelay = PublishRelay<Int>()
        let removeRelay = PublishRelay<Product>()
    }
    
    var disposeBag = DisposeBag()
    
    private let products = BehaviorSubject<[Product]>(value: [])
    private let cartItems = BehaviorRelay<[CartItem]>(value: [])
    private let totalAmount = BehaviorRelay<Int>(value: 0)
    private let totalNum = BehaviorRelay<Int>(value: 0)
    private let showAlert = PublishRelay<AlertType>()
    
    public let cellIutput = CellInput()
    
    private let useCase: KioskUseCaseInterface
    
    init(useCase: KioskUseCaseInterface) {
        self.useCase = useCase
    }
    
    //메뉴 리스트 호출
    private func fetchProducts(input: Input) {
        input.selectedSegment
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                Task {
                    do {
                        let type: ProductType
                        switch index {
                        case 0: type = .smartphones
                        case 1: type = .laptops
                        case 2: type = .tablets
                        default: return
                        }
                        let products = try await self.useCase.fetchProducts(type: type)
                        self.products.onNext(products)
                    } catch {
                        print("상품 불러오기 실패: \(error.localizedDescription)")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    //장바구니 추가
    private func addToCart(input:Input) {
        input.selectedCell
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                do {
                    let products = try products.value()
                    let product = products[index]
                    if !cartItems.value.contains(where: { $0.product.id == product.id }) {
                        let newCartItems = cartItems.value + [CartItem(product: product, count: 1)]
                        self.cartItems.accept(newCartItems)
                        self.calculateTotalCount(items: newCartItems)
                        self.calculateTotalAmount(items: newCartItems)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    //상품 수량 증가
    private func increaseCellNum(input:Input) {
        input.increaseTapped
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                
                var items = self.cartItems.value
                guard items.indices.contains(index) else { return }
                items[index].count += 1
                self.calculateTotalCount(items: items)
                self.calculateTotalAmount(items: items)
                self.cartItems.accept(items)
            })
            .disposed(by: disposeBag)
    }
    
    //상품 수량 감소
    private func decreaseCellNum(input:Input) {
        input.decreaseTapped
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                
                var items = self.cartItems.value
                guard items.indices.contains(index) else { return }
                items[index].count -= 1
                if items[index].count <= 0 {
                    items.remove(at: index)
                }
                self.calculateTotalCount(items: items)
                self.calculateTotalAmount(items: items)
                self.cartItems.accept(items)
            })
            .disposed(by: disposeBag)
    }
    
    //상품 삭제
    private func removeCell(input:Input) {
        input.removeTapped
            .subscribe(onNext: { [weak self] product in
                guard let self else { return }
                
                var items = self.cartItems.value
                items.removeAll { $0.product.id == product.id }
                self.cartItems.accept(items)
            })
            .disposed(by: disposeBag)
    }
    
    //alert 이벤트 호출
    private func alertEvent(input:Input){
        let orderCancel = input.orderCancelTapped.map { AlertType.confirmCancel }
        let orderResult = input.orderTapped
            .withLatestFrom(totalAmount)
            .map { $0 == 0 ? AlertType.emptyCart : AlertType.confirmOrder($0) }
        
        Observable.merge(orderCancel, orderResult)
            .bind(to: showAlert)
            .disposed(by: disposeBag)
    }
    func removeAllCart(){
        totalNum.accept(0)
        totalAmount.accept(0)
        cartItems.accept([])
    }
    
    //총 개수 계산
    private func calculateTotalCount(items:[CartItem]) {
        let total = items.reduce(0) { $0 + $1.count }
        self.totalNum.accept(total)
    }
    
    //총 금액 계산
    private func calculateTotalAmount(items:[CartItem]){
        let total = items.reduce(0) { $0 + $1.totalPrice }
        self.totalAmount.accept(total)
    }
    
    //Intput -> Output 스트림
    func transform(input: Input) -> Output {
        
        fetchProducts(input: input)
        addToCart(input: input)
        increaseCellNum(input: input)
        decreaseCellNum(input: input)
        removeCell(input: input)
        alertEvent(input: input)
        
        return Output(setInfo: products,
                      setCart: cartItems,
                      setTotalAmount: totalAmount,
                      setTotalNum: totalNum,
                      showAlert: showAlert.asObservable())
    }
    
}
