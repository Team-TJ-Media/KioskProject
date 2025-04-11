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
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    let priceLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    lazy var hotLabel = PaddingLabel().then {
        $0.text = "Hot"
        $0.textColor = .white
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.isHidden = Bool.random()
        $0.font = .systemFont(ofSize: 13, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productNameLabel.text = nil
        priceLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray3.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    public func configure(product: Product) {
        productImageView.kf.setImage(with: URL(string: product.thumbnail))
        productNameLabel.text = product.title
        priceLabel.text = product.price.wonFormatter()
    }
    
    private func configureView() {
        contentView.addSubview(containerView)
        [productImageView, productNameLabel, priceLabel, hotLabel].forEach {
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
            $0.height.equalTo(productImageView.snp.width).multipliedBy(0.6)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
        }
        hotLabel.snp.makeConstraints {
            $0.leading.equalTo(priceLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(priceLabel)
        }
    }
    
}


