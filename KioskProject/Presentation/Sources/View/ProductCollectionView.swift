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
        layout.scrollDirection = .horizontal
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.isPagingEnabled = false
        self.decelerationRate = .fast
        self.showsHorizontalScrollIndicator = false
        self.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing: CGFloat = 8
            let totalSpacing = spacing * 3
            let width = (bounds.width - totalSpacing) / 2
            // 여기서 item의 높이를 지정해주고 있는데 현재는 임의로 가로 + 60으로 지정해주는 중
            let height = width + 70
            
            layout.itemSize = CGSize(width: width, height: height)
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
