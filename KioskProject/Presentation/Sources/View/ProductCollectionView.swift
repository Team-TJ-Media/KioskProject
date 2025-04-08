//
//  ProductCollectionView.swift
//  KioskProject
//
//  Created by 백래훈 on 4/8/25.
//

import UIKit

final class ProductCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2
        // 여기서 item의 높이를 지정해주고 있는데 현재는 임의로 가로 + 60으로 지정해주는 중
        let height = width + 60
        
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        return layout
        
    }
    
}
