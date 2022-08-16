//
//  OrderStepper.swift
//  Choco
//
//  Created by Mozhgan on 10/1/21.
//

import UIKit
import SnapKit
import Combine

class OrderStepper : UIView {
    typealias ChangedVlaueCallback = (Int) -> Void
    private var changedVlaueCallback : ChangedVlaueCallback?
    var quntityValue : Int = 0 {
        didSet {
            quntityLbl.text = "\(quntityValue)"
            stepper.value = Double(quntityValue)
        }
    }
    var count : Int = Int.max
    private(set) lazy var stepper : UIStepper = {
       let tmp = UIStepper()
       tmp.minimumValue = 0
       tmp.maximumValue = Double(count)
       tmp.stepValue = 1
       tmp.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .touchUpInside)
       return tmp
    }()
    private(set) lazy var quntityLbl : UILabel = {
        let tmp = UILabel()
        tmp.numberOfLines = 1
        tmp.font = UIFont.systemFont(ofSize: LayoutContants.Shared.fontSize, weight: UIFont.Weight.bold)
        tmp.lineBreakMode = .byTruncatingTail
        return tmp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    required init(valueChanged : @escaping ChangedVlaueCallback) {
        super.init(frame: .zero)
        self.changedVlaueCallback = valueChanged
        setup()

    }
    private func setup() {
        self.addSubview(stepper)
        self.addSubview(quntityLbl)
        quntityLbl.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.topMargin.equalToSuperview()
            maker.bottom.equalTo(stepper.snp.top)
        }
        stepper.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottomMargin.equalToSuperview()
        }
    }

}

extension OrderStepper {
    @objc func stepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        if quntityValue != value {
            quntityValue = value
            self.changedVlaueCallback?(value)
        }
    }
}
