//
//  QueryStringAccessToken.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Moya
 struct QueryStringAccessToken: PluginType {

    typealias TokenClosure = (TargetType) -> String
    let tokenClosure: TokenClosure

    init(tokenClosure: @escaping TokenClosure) {
       self.tokenClosure = tokenClosure
   }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

       guard let authorizable = target as? AccessTokenAuthorizable,
           let authorizationType = authorizable.authorizationType
           else { return request }

       var request = request
       let realTarget = (target as? MultiTarget)?.target ?? target
       let path = request.url!.absoluteString.appending("?\(authorizationType.value)=\(tokenClosure(realTarget))")
       request.url = URL(string: path)!
       return request
   }
}
