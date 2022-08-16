//
//  Realm.swift
//  Choco
//
//  Created by Mozhgan on 10/11/21.
//

import Foundation
import RealmSwift
final class OrmDatabase: UserData {
    static func clearCache() {
        let realm = defaultRealmStorage
        do {
            try realm?.deleteAll(ProductOrder.self)
        } catch let error {
            print("Logout failed by ::\(error.localizedDescription)")
        }
    }
}
