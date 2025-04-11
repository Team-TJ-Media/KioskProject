//
//  PaddingLabel.swift
//  KioskProject
//
//  Created by 유영웅 on 4/11/25.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
    var contentInset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + contentInset.left + contentInset.right,
            height: size.height + contentInset.top + contentInset.bottom
        )
    }
}
