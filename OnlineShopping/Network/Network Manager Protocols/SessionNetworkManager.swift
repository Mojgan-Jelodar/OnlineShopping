//
//  SessionNetworkManager.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Combine
protocol SessionNetworkManager {
    func login(param : LoginBussinessModel.Request) -> AnyPublisher<LoginNetworkModel.Response,Error>
}
