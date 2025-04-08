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
    
    private let mainView = TestMainView()
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
            selectedIndex: mainView.segment.rx.selectedSegmentIndex.asObservable(),
            selectedCell: mainView.collectionView.rx.itemSelected.map{$0.row}.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.setInfo
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.collectionView.rx.items(
                    cellIdentifier: ProductCell.identifier,
                    cellType: ProductCell.self)
            ){ _, product, cell in
                cell.configure(with: product)
            }
            .disposed(by: disposeBag)
        
        output.setItem
            .observe(on: MainScheduler.instance)
            .bind { cell in
                print("데이터: \(cell)")
            }
            .disposed(by: disposeBag)
    }
}

class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        nameLabel.frame = contentView.bounds
        nameLabel.textAlignment = .center
    }

    func configure(with product: Product) {
        nameLabel.text = product.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TestMainView: UIView {
    let segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["SmartPhone","Laptops","tablets"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 60)
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        addSubview(segment)
        addSubview(collectionView)
        segment.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
