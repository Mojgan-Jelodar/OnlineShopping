//
//  API+Moya.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Moya
extension SessionApi : TargetType {
    var baseURL: URL {
        return Server.BaseUrl
    }
    var path: String {
        switch self {
        case .login:
        return "login"
        }
    }
    var method: Moya.Method {
        switch self {
        case .login:
        return .post
        }
    }
    var task: Task {
        switch self {
        case .login(let params):
            return .requestData((try? params.jsonData()) ?? Data())
        }
    }
    var headers: [String : String]? {
        nil
    }
    var sampleData: Data {
        switch self {
        case .login:
            return (try? LoginNetworkModel.Response(fromURL: R.file.loginJson()!).jsonData()) ?? Data()
        }
    }
}
