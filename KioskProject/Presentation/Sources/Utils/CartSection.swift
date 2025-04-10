//
//  CartSection.swift
//  KioskProject
//
//  Created by 유영웅 on 4/10/25.
//

import Foundation
import RxDataSources

//섹션 별 타입 설정 - 각 케이스가 하나의 셀이 됨(팩토리 패턴과 유사)
enum CartSectionItem {
    case cart(item: CartItem)
    case amount(amount: Int)
}
//해당 셀들을 하나의 리스트로 병합(model: 셀 id, items: 아이템 목록)
typealias CartSection = SectionModel<String,CartSectionItem>
