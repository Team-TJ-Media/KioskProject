//
//  TitleView.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit
import Then

class TitleView: UIStackView {
    private let titleLabel = UILabel().then {
        $0.text = "TJ미디어"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(systemName: "laptopcomputer.and.iphone")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
