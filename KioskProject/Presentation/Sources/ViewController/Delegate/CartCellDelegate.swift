//
//  CartCellDelegate.swift
//  KioskProject
//
//  Created by 유영웅 on 4/9/25.
//

import Foundation

//MARK: 장바구니 관련 이벤트 VC로 넘겨주기 위한 Delegate
protocol CartCellDelegate:AnyObject{
    func removeFormCart(product:Product)
    func didTapIncrease(cell: CartTableViewCell)
    func didTapDecrease(cell: CartTableViewCell)
    func addedCart()
}
