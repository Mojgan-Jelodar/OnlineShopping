//
//  HeaderPlugin.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Moya

struct  HeaderPlugin : PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var currentRequest = request
        currentRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        currentRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return currentRequest
    }
}
