//
//  ProductApi+Moya.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Moya

extension ProductApi : TargetType,AccessTokenAuthorizable {
    var baseURL: URL {
        return Server.BaseUrl
    }
    var path: String {
        switch self {
        case .getProducts:
            return "products"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getProducts:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getProducts:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        return nil
    }
    var authorizationType: AuthorizationType? {
        return .custom("token")
    }
    var sampleData: Data {
        switch self {
        case .getProducts:
            return (try? ProductNetworkModel.ProductsResponse(fromURL: R.file.productsJson()!).jsonData()) ?? Data()
        }
    }
}
