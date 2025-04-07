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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.addSubview(categoryView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}
