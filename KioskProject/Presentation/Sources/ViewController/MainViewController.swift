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


final class MainViewController: UIViewController,CartCellDelegate {
  
    private let mainView = MainView()
    
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        view.backgroundColor = .systemBackground
    }
    
    init(DIContainer: KioskDIContainerInterface) {
        self.viewModel = DIContainer.makeMainViewModel()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel(){
        
        let input = MainViewModel.Input(
            selectedIndex: mainView.categoryView.rx.selectedSegmentIndex.asObservable(),
            selectedCell: mainView.productCollectionView.rx.itemSelected.map{$0.row}.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.setInfo
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.productCollectionView.rx.items(
                    cellIdentifier: ProductCollectionViewCell.identifier,
                    cellType: ProductCollectionViewCell.self)
            ){ _, product, cell in
                cell.configure(product: product)
            }
            .disposed(by: disposeBag)
        
        output.setCart
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: CartItemCell.identifier,
                cellType: CartItemCell.self)
            ){ _, cartItem, cell in
                let vm = CartItemCellViewModel(cartItem: cartItem)
                cell.binding(viewModel: vm)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
    }
    
    func removeFormCart(product: Product) {
        self.viewModel.removeFromCart(product: product)
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
    private let countLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    private let minusButton = UIButton(type: .system)
    
    // MARK: - Rx
    private var disposeBag = DisposeBag()
    private var viewModel: CartItemCellViewModel?
    
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
        disposeBag = DisposeBag()
    }
    
    func binding(viewModel: CartItemCellViewModel) {
        self.viewModel = viewModel
        
        let input = CartItemCellViewModel.Input(
            increaseTapped: plusButton.rx.tap.asObservable(),
            decreaseTapped: minusButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.addFromCart
            .bind(onNext: { [weak self] item in
                guard let self else {return}
                self.titleLabel.text = item.title
                self.priceLabel.text = "\(item.price)"
            })
            .disposed(by: disposeBag)
        
        output.countText
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.removeFromCart
            .subscribe(onNext: { [weak self] cartItem in
                self?.delegate?.removeFormCart(product: cartItem)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        plusButton.setTitle("+", for: .normal)
        minusButton.setTitle("-", for: .normal)
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

protocol CartCellDelegate:AnyObject{
    func removeFormCart(product:Product)
}
