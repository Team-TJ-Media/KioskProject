//
//  MainView.swift
//  KioskProject
//
//  Created by 유현진 on 4/7/25.
//

import UIKit
import SnapKit

final class MainView: UIView {
    let titleView = TitleView()
    let orderButtonView = OrderButtonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        [titleView, orderButtonView].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        titleView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        orderButtonView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
    }
}
