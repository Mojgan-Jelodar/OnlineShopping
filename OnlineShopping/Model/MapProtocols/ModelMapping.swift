//
//  ModelMapping.swift
//  GitClient
//
//  Created by Mozhgan on 9/23/21.
//

import Foundation
protocol ModelMapping {
    associatedtype S : Decodable
    init(object: S)
}
