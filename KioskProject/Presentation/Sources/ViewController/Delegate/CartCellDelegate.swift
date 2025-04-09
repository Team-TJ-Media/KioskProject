//
//  CartCellDelegate.swift
//  KioskProject
//
//  Created by 유영웅 on 4/9/25.
//

import Foundation

protocol CartCellDelegate:AnyObject{
    func removeFormCart(product:Product)
    func didTapIncrease(cell: CartItemCell)
    func didTapDecrease(cell: CartItemCell)
}
