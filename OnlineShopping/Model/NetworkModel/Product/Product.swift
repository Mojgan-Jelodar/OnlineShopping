// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let productElement = try ProductElement(json)

import Foundation
import RealmSwift

enum ProductNetworkModel {
}

// MARK: - Product
final public class Product: Object,Codable {
    @objc dynamic private(set) var id, name, text: String?
    @objc dynamic private(set) var price: Double = 0.0
    @objc dynamic private(set) var photo: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name
        case text = "Description"
        case price, photo
    }

    convenience init(id: String?, name: String?, text: String?, price: Double = 0, photo: String? = nil) {
        self.init()
        self.id = id
        self.name = name
        self.text = text
        self.price = price
        self.photo = photo
    }

    public override class func primaryKey() -> String? {
        return "id"
    }
}
extension Product {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Product.self, from: data)
        self.init(id: me.id, name: me.name, text: me.text, price: me.price, photo: me.photo)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String?? = nil,
        name: String?? = nil,
        text: String?? = nil,
        price: Double?? = nil,
        photo: String?? = nil
    ) -> Product {
        return Product(
            id: id ?? self.id,
            name: name ?? self.name,
            text: text ?? self.text,
            price: (price ?? self.price) ?? 0.0,
            photo: photo ?? self.photo
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Double {
    func formmatedPrice() -> String {
        let currencyFormatter : NumberFormatter = {
            let tmp = NumberFormatter()
            tmp.numberStyle = .currency
            tmp.currencyCode = "EUR"
            tmp.usesGroupingSeparator = true
            tmp.locale = Locale(identifier: "de")
            return tmp
        }()
        return currencyFormatter.string(from: NSNumber(value: self )) ?? "-"
    }
}
