//
//  MoyaProvider.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Moya

final class UserCredintial {
    static let shared = UserCredintial()

    private let keyChainTokenManager = KeyChainTokenCaretaker()
    var accessToken : String? {
        didSet {
            guard let value = accessToken else {
                return
            }
            try? keyChainTokenManager.save(data: TokenMomento(accessToken: value))
        }
    }
    private init() {
      self.accessToken = try? keyChainTokenManager.load()?.accessToken ?? nil
    }
}

let sharedMockNetworkProvider = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.immediatelyStub,
                                                          plugins: [
                                                            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)),
                                                            QueryStringAccessToken {_ in
                                                                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVC"
                                                            },
                                                            HeaderPlugin()])

let sharedNetworkProvider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(configuration:
                                                                                        .init(logOptions:.verbose)),
                                                                QueryStringAccessToken {_ in
                                                                    UserCredintial.shared.accessToken ?? ""
                                                                },
                                                                HeaderPlugin()])
