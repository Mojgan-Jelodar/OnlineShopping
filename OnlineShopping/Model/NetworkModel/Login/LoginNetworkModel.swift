//
//  LoginNetworkModel.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import UIKit

enum LoginNetworkModel {
}

extension LoginNetworkModel {
    struct Request : Codable {
        let email : String
        let password : String
    }
    struct Response : Codable {
        let token : String
    }
}

extension LoginNetworkModel.Request {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LoginNetworkModel.Request.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
extension LoginNetworkModel.Response {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LoginNetworkModel.Response.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
