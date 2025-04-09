//
//  Extension+UICollectionViewCell.swift
//  KioskProject
//
//  Created by 백래훈 on 4/8/25.
//

import UIKit

extension UICollectionViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
