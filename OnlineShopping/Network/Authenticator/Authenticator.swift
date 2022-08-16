//
//  File.swift
//  Blu
//
//  Created by Mozhgan on 9/12/21.
//

import Foundation
import UIKit
import Combine

extension Notification.Name {
    public static var isAuthorized : Notification.Name {
        return .init(rawValue: "UserSession.isAuthorized")
    }
}

protocol ReloginView {
    func present()
}

struct AppReloginHandler: ReloginView {
    func present() {
        DispatchQueue.main.async {
            let vc = Login.Builder.build()
            UIViewController.window?.rootViewController = vc
            UIViewController.window?.makeKeyAndVisible()
        }
    }
}

protocol Authenticator {
    associatedtype S
    func sessionIsExpired(using subject: S)
    func tokenSubject() -> S
}

final class AppAuthenticator : Authenticator {
    private var tokenSubjects : [S] = []
    private var isAuthorizing = false
    private var loginView : ReloginView
    private var cancellable: AnyCancellable?
    typealias S = CurrentValueSubject<Bool, Never>

    init(loginView : ReloginView) {
        self.loginView = loginView
        cancellable = NotificationCenter.Publisher(center: .default, name: .isAuthorized, object: nil)
            .subscribe(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.isAuthorizing = false
                self?.tokenSubjects.forEach({$0.send(true)
            })
        }
    }

    func sessionIsExpired(using subject: S) {
        tokenSubjects.append(subject)
        guard !isAuthorizing else {
            return
        }
        isAuthorizing = true
        self.loginView.present()
    }

    func tokenSubject() -> CurrentValueSubject<Bool, Never> {
        return CurrentValueSubject(true)
    }
}
