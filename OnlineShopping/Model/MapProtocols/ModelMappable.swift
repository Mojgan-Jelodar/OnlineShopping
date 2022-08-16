//
//  ModelMappable.swift
//  GitClient
//
//  Created by Mozhgan on 9/23/21.
//

import Foundation

protocol ModelMappable {
    associatedtype Output: Encodable
    func wsModel() -> Output
}
