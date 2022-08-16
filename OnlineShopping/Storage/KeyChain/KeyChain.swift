//
//  Persist.swift
//  GitClient
//
//  Created by Mozhgan on 9/25/21.
//

import Foundation
import Security

public protocol Storage {
    var tag : String { get }
    var name : String { get }
    associatedtype T
    func save(data : T) throws
    func load() throws  -> T?
}

struct TokenMomento {
    var accessToken : String?
    init(accessToken : String?) {
        self.accessToken = accessToken
    }
}

final class KeyChainTokenCaretaker : Storage {
    typealias T = TokenMomento
    private lazy var secureStore : SecureStore = {
        return SecureStore(secureStoreQueryable: self)
    }()

    func save(data: TokenMomento) throws {
        try secureStore.setValue(data.accessToken!, for: name)
    }

    func load() throws -> TokenMomento? {
        do {
            guard let token = try secureStore.getValue(for: name) else {
                throw SecureStoreError.unhandledError(message: "It hasn't been found")
            }
           return TokenMomento(accessToken: token)
        } catch let error {
            throw error
        }
    }

    public func removeValue() throws {
        try secureStore.removeValue(for: name)
    }

}

extension KeyChainTokenCaretaker : SecureStoreQueryable {
    var tag: String {
        return (Bundle.main.bundleIdentifier ?? "") + ".keys"
    }

    var name: String {
        return "ChocoAccessToken"
    }

    var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = tag
        return query
    }
}
