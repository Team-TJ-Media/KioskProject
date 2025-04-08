//
//  TitleStackView.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit

class TitleStackView: UIStackView {
    let titleLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.text = "TJ미디어"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        imageView.image = UIImage(systemName: "laptopcomputer.and.iphone")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        
        let spacer = UIView()
        
        [imageView, titleLabel, spacer].forEach {
            addArrangedSubview($0)
        }
        axis = .horizontal
        spacing = 8
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
