//
//  ProductCollectionViewCell.swift
//  KioskProject
//
//  Created by 백래훈 on 4/8/25.
//

import UIKit

import SnapKit

import Then

import Kingfisher

final class ProductCollectionViewCell: UICollectionViewCell {
    
    let containerView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let productImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let productNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    let priceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray3.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    public func configure(product:Product){
        productImageView.kf.setImage(with: URL(string: product.thumbnail))
        productNameLabel.text = product.title
        priceLabel.text = "\(product.price)"
    }
    private func configureView() {
        contentView.addSubview(containerView)
        [productImageView, productNameLabel, priceLabel].forEach {
            containerView.addSubview($0)
        }
    }

    private func setupConstraints() {
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
//            $0.height.equalTo(productImageView.snp.width)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(productNameLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
}
