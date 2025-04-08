//
//  MainView.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import UIKit

final class MainView: UIView {
    
    let categoryView = {
        let view = CategoryView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let productCollectionView = {
        let view = ProductCollectionView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        [categoryView, productCollectionView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setConstraints() {
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2
        // 여기서 item의 높이를 지정해주고 있는데 현재는 임의로 가로 + 60으로 지정해주는 중
        let height = width + 60
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 44),
            
            productCollectionView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 16),
            productCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productCollectionView.heightAnchor.constraint(equalToConstant: height * 2 + spacing * 3)
        ])
    }
    
}
