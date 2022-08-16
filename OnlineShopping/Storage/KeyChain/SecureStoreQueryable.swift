//
//  SecureStoreQueryable.swift
//  GitClient
//
//  Created by Mozhgan on 9/25/21.
//

import Foundation
public protocol SecureStoreQueryable {
  var query: [String: Any] { get }
}
