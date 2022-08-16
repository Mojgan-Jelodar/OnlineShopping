//
//  Sc.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation
protocol SceneBuilder {
    associatedtype Output
    associatedtype Input
    static func build(with : Input) -> Output
}
extension SceneBuilder where Input == Void {

    static func build() -> Output {
        return Self.build(with: ())
    }

}
