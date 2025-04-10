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


final class MainViewController: UIViewController {

    private let mainView = MainView()
    private let viewModel: MainViewModel
    
    private var items = [1, 2, 3, 4, 5, 6, 7, 8]
    
    private let disposeBag = DisposeBag()

    // Relay로 ViewModel에 명령 전달
    private let increaseRelay = PublishRelay<Int>()
    private let decreaseRelay = PublishRelay<Int>()
    private let removeRelay = PublishRelay<Product>()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.productCollectionView.delegate = self
        mainView.productCollectionView.dataSource = self
        
        setTableViewData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainView.cartView.updateTableViewHeight()
        
//        mainView.layoutIfNeeded()
        
        view.backgroundColor = .systemBackground
        bindViewModel()
    }

    init(DIContainer: KioskDIContainerInterface) {
        self.viewModel = DIContainer.makeMainViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableViewData() {
        mainView.cartView.cartTableView.dataSource = self
        mainView.cartView.cartTableView.delegate = self
        
        mainView.cartView.cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        mainView.cartView.cartTableView.register(TotalAmountCell.self, forCellReuseIdentifier: TotalAmountCell.reuseIdentifier)
        
        mainView.cartView.cartTableView.separatorStyle = .none
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 각 상품별 구매수량 및 금액, 총 금액
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { // 각 상품별 구매수량 및 금액
            return items.count
        } else { // 총 금액
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as! CartTableViewCell
            cell.setupUI(productName: "iPhone 15", orderCount: 1, orderAmounts: 300000)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountCell.reuseIdentifier, for: indexPath) as! TotalAmountCell
            cell.setupUI(orderAmounts: 600000)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 8
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 0
        }

    private func bindViewModel() {
        let input = MainViewModel.Input(
            selectedIndex: mainView.categoryView.rx.selectedSegmentIndex.asObservable(),
            selectedCell: mainView.productCollectionView.rx.itemSelected.map { $0.row }.asObservable(),
            increaseTapped: increaseRelay.asObservable(),
            decreaseTapped: decreaseRelay.asObservable(),
            removeTapped: removeRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.setInfo
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.productCollectionView.rx.items(
                cellIdentifier: ProductCollectionViewCell.identifier,
                cellType: ProductCollectionViewCell.self)
            ) { _, product, cell in
                cell.configure(product: product)
            }
            .disposed(by: disposeBag)

        output.setCart
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: CartItemCell.identifier,
                cellType: CartItemCell.self)
            ) { [weak self] _, cartItem, cell in
                guard let self else { return }
                cell.configure(item: cartItem)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        output.setTotalAmount
            .observe(on: MainScheduler.instance)
            .map { String(format: "%.2f", $0) }
            .bind(to: mainView.totalLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.setTotalNum
            .observe(on: MainScheduler.instance)
            .map { "\($0)" }
            .bind(to: mainView.numLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
// MARK: - CartCellDelegate
extension MainViewController: CartCellDelegate{
    
    func didTapIncrease(cell: CartItemCell) {
        guard let indexPath = mainView.tableView.indexPath(for: cell) else { return }
        increaseRelay.accept(indexPath.row)
    }

    func didTapDecrease(cell: CartItemCell) {
        guard let indexPath = mainView.tableView.indexPath(for: cell) else { return }
        decreaseRelay.accept(indexPath.row)
    }

    func removeFormCart(product: Product) {
        removeRelay.accept(product)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
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

final class CartItemCell: UITableViewCell {
    
    static let identifier = "CartItemCell"
        
    // MARK: - UI
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    let countLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    private let minusButton = UIButton(type: .system)
    
    // MARK: - Rx
    var disposeBag = DisposeBag()
    
    weak var delegate: CartCellDelegate?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // 셀 재사용 시 Rx 초기화
    }

    // MARK: - Configuration
    func configure(item: CartItem) {
        titleLabel.text = item.product.title
        priceLabel.text = String(format: "%.2f", item.totalPrice)
        countLabel.text = "\(item.count)"
        bindActions()
    }

    private func bindActions() {
        plusButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.delegate?.didTapIncrease(cell: self)
            }
            .disposed(by: disposeBag)

        minusButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.delegate?.didTapDecrease(cell: self)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        plusButton.setTitle("+", for: .normal)
        minusButton.setTitle("-", for: .normal)
        countLabel.text = "1"
        
        countLabel.textAlignment = .center
        countLabel.font = UIFont.boldSystemFont(ofSize: 16)

        let buttonStack = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.alignment = .center
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, buttonStack, priceLabel])
        
        mainStack.axis = .horizontal
        mainStack.spacing = 20
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        
        contentView.addSubview(mainStack)
        mainStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(10)
        }
    }
}



