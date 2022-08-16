//
//  File.swift
//  Choco
//
//  Created by Mozhgan on 10/1/21.
//

import Foundation
import RealmSwift
public final class ProductOrder : Object {
    @objc dynamic private(set) var product: Product!
    @objc dynamic private(set) var id : String!
    @objc dynamic private(set) var quantity : Int = 0
    public override static func primaryKey() -> String? {
        return "id"
    }

    var incremented: ProductOrder {
        return ProductOrder(product: product, quantity: quantity + 1)
    }
    var decremented: ProductOrder {
        return ProductOrder(product: product, quantity: quantity - 1)
    }

    convenience init(product: Product, quantity: Int = 1) {
        self.init()
        self.product = product
        self.quantity = quantity
        self.id = product.id
    }
}

extension ProductOrder {
    var price: Double {
        return product.price * Double(quantity)
    }
}

extension ProductOrder {
    static func == (lhs: ProductOrder, rhs: ProductOrder) -> Bool {
        return lhs.id == rhs.id && lhs.quantity == rhs.quantity
    }
}
