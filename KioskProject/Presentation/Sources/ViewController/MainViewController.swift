//
//  MainViewController.swift
//  TeamProject
//
//  Created by 백래훈 on 4/3/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

//MARK: MainViewController
final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let viewModel: MainViewModel
    
    private let disposeBag = DisposeBag()
    
    //장바구니 Cell + 주문금액 Cell 데이터 소스
    private var dataSources:RxTableViewSectionedReloadDataSource<CartSection>{
        RxTableViewSectionedReloadDataSource<CartSection>(
            configureCell: { _, tableView, indexPath, item in
                switch item {
                case .cart(let cartItem):
                    let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
                    cell.configure(item: cartItem)
                    cell.delegate = self
                    return cell
                case .amount(let amount):
                    let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountCell.identifier, for: indexPath) as! TotalAmountCell
                    cell.configure(amount: amount)
                    return cell
                }
            }
        )
    }
    init(DIContainer: KioskDIContainerInterface) {
        self.viewModel = DIContainer.makeMainViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //뷰 초기화
    override func loadView() {
        view = mainView
    }
    //뷰 로드 후
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewData()
        serCollectionViewData()
        bindViewModel()
    }
    //뷰 레이아웃 설정 후
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .systemBackground
        mainView.cartView.updateTableViewHeight()
    }
    //컬렉션 뷰 세팅
    private func serCollectionViewData(){
        mainView.productCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    //테이블 뷰 세팅
    private func setTableViewData() {
        mainView.cartView.cartTableView.rx.setDelegate(self).disposed(by: disposeBag)
        mainView.cartView.cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        mainView.cartView.cartTableView.register(TotalAmountCell.self, forCellReuseIdentifier: TotalAmountCell.identifier)
    }
    //타입에 따른 alert 표시
    private func showAlert(_ type:AlertType){
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    //뷰 바인딩
    private func bindViewModel() {
        let input = MainViewModel.Input(
            selectedSegment: mainView.categoryView.rx.selectedSegmentIndex.asObservable(),
            selectedCell: mainView.productCollectionView.rx.itemSelected.map { $0.row }.asObservable(),
            increaseTapped: viewModel.cellIutput.increaseRelay.asObservable(),
            decreaseTapped: viewModel.cellIutput.decreaseRelay.asObservable(),
            removeTapped: viewModel.cellIutput.removeRelay.asObservable(),
            orderCancelTapped: mainView.orderButtonView.cancelButton.rx.tap,
            orderTapped: mainView.orderButtonView.confirmButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        //메뉴 - 리스트 불러오기 바인딩
        output.setInfo
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.productCollectionView.rx.items(
                cellIdentifier: ProductCollectionViewCell.identifier,
                cellType: ProductCollectionViewCell.self)
            ) { _, product, cell in
                cell.configure(product: product)
            }
            .disposed(by: disposeBag)
        
        //장바구니 - 총 개수 바인딩
        output.setTotalNum
            .observe(on: MainScheduler.instance)
            .map { "총 \($0)개" }
            .bind(to: mainView.cartView.orderCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        //Alert - 주문 종료에 따라 alert 실행
        output.showAlert
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] type in
                self?.showAlert(type)
            })
            .disposed(by: disposeBag)
        
        //장바구니 - 추가 바인딩
        //장바구니 추가 시 총 금액도 함깨 바인딩하기 위함
        Observable.combineLatest(output.setCart, output.setTotalAmount)
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _, total in
                self?.mainView.paymentView.paymentStackView.configure(totalAmount: total)
            })
            .map { items, total in
                let cartItems = items.map { CartSectionItem.cart(item: $0) }
                let amountItem = CartSectionItem.amount(amount: total)
                return [
                    CartSection(model: "cart", items: cartItems),
                    CartSection(model: "amount", items: [amountItem])
                ]
            }
            .bind(to: mainView.cartView.cartTableView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
    }
}

//extension MainViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2 // 각 상품별 구매수량 및 금액, 총 금액
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 { // 각 상품별 구매수량 및 금액
//            return items.count
//        } else { // 총 금액
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
////            cell.setupUI(productName: "iPhone 15", orderCount: 1, orderAmounts: 300000)
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountCell.reuseIdentifier, for: indexPath) as! TotalAmountCell
//            cell.setupUI(orderAmounts: 600000)
//            return cell
//        }
//    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
//}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 8 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
// MARK: - CartCellDelegate
extension MainViewController: CartCellDelegate{
    //수량 + 버튼 이벤트
    func didTapIncrease(cell: CartTableViewCell) {
        guard let indexPath = mainView.cartView.cartTableView.indexPath(for: cell) else { return }
        viewModel.cellIutput.increaseRelay.accept(indexPath.row)
    }
    //수량 - 버튼 이벤트
    func didTapDecrease(cell: CartTableViewCell) {
        guard let indexPath = mainView.cartView.cartTableView.indexPath(for: cell) else { return }
        viewModel.cellIutput.decreaseRelay.accept(indexPath.row)
    }
    //수량이 0이 되면 삭제하는 이벤트
    func removeFormCart(product: Product) {
        viewModel.cellIutput.removeRelay.accept(product)
    }
    //추가할 때마다 장바구니 크기를 동적으로 변환하기 위한 이벤트
    func addedCart() {
        self.mainView.cartView.updateTableViewHeight()
        self.mainView.layoutIfNeeded()
    }
}
// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    // 페이징(스크롤)을 위한 메서드, 2행의 상품이 지나가면 멈춤
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.mainView.productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = (layout.itemSize.width * 2) + (layout.minimumLineSpacing * 2)
        
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
    
    // 페이징(스크롤) 시 호출되는 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = self.mainView.productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = (layout.itemSize.width * 2) + (layout.minimumLineSpacing * 2)
        
        // 반 페이지 이상 넘어가면 현재 페이지를 업데이트
        let currentPage = Int((scrollView.contentOffset.x + (0.5 * cellWidthIncludingSpacing)) / cellWidthIncludingSpacing)
        mainView.pageControl.currentPage = currentPage
    }
    
}



