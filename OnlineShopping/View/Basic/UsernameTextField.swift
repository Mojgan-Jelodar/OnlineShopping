//
//  UsernameTextField.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import UIKit

class UsernameTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    private func setup() {
        self.placeholder = R.string.login.loginUsernameTitle()
        self.borderStyle = .roundedRect
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.keyboardType = .emailAddress
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.snp.makeConstraints { maker in
            maker.height.equalTo(LayoutContants.Shared.elementHeight)
        }
    }
}
