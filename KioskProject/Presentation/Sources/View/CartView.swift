//
//  CartView.swift
//  KioskProject
//
//  Created by 권순욱 on 4/8/25.
//

import UIKit
import SnapKit
import Then

class CartView: UIStackView {
    
    //장바구니 테이블 뷰
    let cartTableView = CartTableView()
    //동적 테이블 뷰 바인딩
    var tableViewHeightConstraint: Constraint?
    //장바구니 라벨
    private let titleLabel = UILabel().then {
        $0.text = " 장바구니"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    //총개수 라벨
    let orderCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    //장바구니 + 총 개수 스택뷰
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .bottom
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 4
        configureView()
        setConstraints()
        setupContentSizeObserver()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //서브뷰 추가
    private func configureView() {
        //장바구니 헤더에 SubView 추가
        [titleLabel, orderCountLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        //해당 스택뷰에 헤더 + 테이블 뷰 추가
        [titleStackView, cartTableView].forEach {
            addArrangedSubview($0)
        }
    }
    
    //레이아웃 설정
    private func setConstraints() {
        cartTableView.snp.makeConstraints {
            tableViewHeightConstraint = $0.height.equalTo(0).constraint
        }
    }
    
    // contentSize 변화를 감지하여 높이 업데이트
    private func setupContentSizeObserver() {
        cartTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    deinit {
        cartTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // contentSize 변경 감지 시, 높이 제약 업데이트
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            tableViewHeightConstraint?.update(offset: cartTableView.contentSize.height)
        }
    }
}

class CartTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .grouped)
        backgroundColor = .systemBackground
        layer.borderWidth = BorderStyle.width
        layer.borderColor = BorderStyle.color
        layer.cornerRadius = BorderStyle.cornerRadius
        separatorStyle = .none
        isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
