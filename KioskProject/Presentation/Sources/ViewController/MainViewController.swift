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
    
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    
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
        let segment = UISegmentedControl(items: ["SmartPhone","Laptops","tablets"])
        segment.selectedSegmentIndex = 0
        view.addSubview(segment)
        
        segment.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let input = MainViewModel.Input(selectedIndex: segment.rx.selectedSegmentIndex.asObservable())
        let output = viewModel.transform(input: input)
        
        output.setInfo
            .observe(on: MainScheduler.instance)
            .bind { products in
                print("데이터 업데이트: \(products)")
            }
            .disposed(by: disposeBag)
    }
}
