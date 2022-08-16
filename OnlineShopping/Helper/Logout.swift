//
//  Logout.swift
//  Choco
//
//  Created by Mozhgan on 10/11/21.
//
import Foundation
import Security

protocol UserData {
    static func clearCache()
}

struct UserLocalStorage {
    static let shared : UserLocalStorage = UserLocalStorage()
    private init() {
    }
    func reset() {
        ShoppingCart.shared.clear()
        Keychain.clearCache()
        OrmDatabase.clearCache()
    }

}
