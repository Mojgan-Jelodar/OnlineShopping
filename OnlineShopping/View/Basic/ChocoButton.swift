//
//  ChocoButton.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation
import UIKit
import SnapKit
class ChocoButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    private func setup() {
        self.backgroundColor = R.color.buttonBackgroundColor()
        self.layer.borderWidth = LayoutContants.Shared.borderWidth

    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.snp.makeConstraints { maker in
            maker.height.equalTo(LayoutContants.Shared.elementHeight)
        }
    }
}
