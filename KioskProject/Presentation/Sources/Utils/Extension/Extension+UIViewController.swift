//
//  Extension+UIViewController.swift
//  KioskProject
//
//  Created by 백래훈 on 4/9/25.
//

import UIKit

extension UIViewController {
    func showAlert(type: AlertType, confirmHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .default)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}
