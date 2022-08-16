//
//  LoginBussinessModel.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
enum LoginBussinessModel {
    struct Request : Decodable {
        let email : String
        let password : String
    }
    struct Response {
        let token : String
    }
}

extension LoginBussinessModel.Request : ModelMappable {
    func wsModel() -> LoginNetworkModel.Request {
        return LoginNetworkModel.Request(email: self.email,
                                         password: self.password)
    }
}

extension LoginBussinessModel.Response : ModelMapping {
    init(object: LoginNetworkModel.Response) {
        self.init(token: object.token)
    }
}
