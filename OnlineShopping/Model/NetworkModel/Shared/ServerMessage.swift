//
//  ChocoErrorError.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation

// MARK: - ServerMessage
struct ServerMessage: Codable {
    let message: String?
}

// MARK: ServerMessage convenience initializers and mutators

extension ServerMessage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ServerMessage.self, from: data)
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

    func with(
        message: String?? = nil
    ) -> ServerMessage {
        return ServerMessage(
            message: message ?? self.message
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
