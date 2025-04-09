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

import SnapKit

final class MainViewController: UIViewController {
    
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
        
        output.setItem
            .observe(on: MainScheduler.instance)
            .bind { cell in
                print("데이터: \(cell)")
            }
            .disposed(by: disposeBag)
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
