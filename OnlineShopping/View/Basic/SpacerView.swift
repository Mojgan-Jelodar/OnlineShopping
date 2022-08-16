//
//  SpacerView.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import UIKit
import SnapKit

final class SpacerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    private func setup() {

    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.snp.makeConstraints { maker in
            maker.height.equalTo(LayoutContants.Shared.spacerHeight)
        }
    }

}
