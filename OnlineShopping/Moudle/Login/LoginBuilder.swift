//
//  LoginBuilder.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation
extension Login {
    struct Builder : SceneBuilder {
        typealias Input = Void
        typealias Output = LoginVC
        static func build(with: Input) -> Output {
            let vc = LoginVC()
            let router = Login.Router(viewcontroller: vc)
            let presenter = Login.Presenter(viewcontroller: vc)
            let interactor = Login.Interactor(worker: MoyaSessionManager(), presenter: presenter)
            vc.router = router
            vc.interactor = interactor
            return vc
        }
    }
}
