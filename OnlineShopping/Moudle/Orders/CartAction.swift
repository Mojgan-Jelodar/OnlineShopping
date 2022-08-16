//
//  File.swift
//  Choco
//
//  Created by Mozhgan on 10/1/21.
//

import Foundation
enum CartAction {
    case insert(product: Product,quantity : Int = 1)
    case incrementProduct(withId: String)
    case decrementProduct(withId: String)
    case clear
}
