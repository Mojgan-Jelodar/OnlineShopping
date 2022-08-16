//
//  Keychain.swift
//  Choco
//
//  Created by Mozhgan on 10/11/21.
//

import Foundation

final class Keychain: NSObject,UserData {
    static func clearCache() {
    let secItemClasses =  [
      kSecClassGenericPassword,
      kSecClassInternetPassword,
      kSecClassCertificate,
      kSecClassKey,
      kSecClassIdentity
    ]
    for itemClass in secItemClasses {
      let spec: NSDictionary = [kSecClass: itemClass]
      SecItemDelete(spec)
    }
  }
}
