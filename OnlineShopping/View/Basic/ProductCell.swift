//
//  ProductCell.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//
import UIKit
import SnapKit
import Kingfisher
import Combine

protocol ProductCellDelegate : AnyObject {
    func update(cell: ProductCell?,value : Int)
}

final class ProductCell: UITableViewCell {
    weak var delegate : ProductCellDelegate?
    private let cardView : UIView = {
        let vw = UIView()
        vw.backgroundColor = .systemBackground.withAlphaComponent(0.6)
        return vw
    }()
    private(set) lazy var avatarImgView : UIImageView = {
        let tmp = UIImageView()
        tmp.contentMode = .scaleAspectFill
        tmp.clipsToBounds = true
        tmp.layer.masksToBounds = true
        return tmp
    }()
    private(set) lazy var nameLbl : UILabel = {
        let tmp = UILabel()
        tmp.numberOfLines = 0
        tmp.font = UIFont.systemFont(ofSize: LayoutContants.Shared.fontSize, weight: UIFont.Weight.regular)
        tmp.lineBreakMode = .byTruncatingTail
        return tmp
    }()
    private(set) lazy var priceLbl : UILabel = {
        let tmp = UILabel()
        tmp.font = UIFont.systemFont(ofSize: LayoutContants.Shared.fontSize, weight: UIFont.Weight.regular)
        tmp.numberOfLines = 0
        tmp.lineBreakMode = .byTruncatingTail
        return tmp
    }()

    private(set) lazy var orderStepper : OrderStepper = {
        let tmp = OrderStepper { [weak self] (value) in
            self?.delegate?.update(cell: self, value: value)
        }
        return tmp
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }

    func setupView() {
        self.selectionStyle = .none
        func setCardViewConstraint() {
            cardView.snp.makeConstraints { maker in
                maker.leading.trailing.top.bottom.equalToSuperview()
                maker.height.greaterThanOrEqualTo(self.avatarImgView).offset(LayoutContants.Shared.margin).priority(.required)
            }
        }
        func setAvatarConstraint() {
            avatarImgView.snp.makeConstraints { maker in
                maker.leading.equalTo(LayoutContants.Shared.margin)
                maker.centerY.equalToSuperview()
                maker.size.equalTo(Style.imageSize)
            }
        }
        func setNameConstraint() {
            nameLbl.snp.makeConstraints { maker in
                maker.leading.equalTo(avatarImgView.snp.trailing).offset(LayoutContants.Shared.margin)
                maker.centerY.equalToSuperview()
                maker.trailing.equalTo(orderStepper.snp_leadingMargin)
            }
        }
        func setPriceConstraint() {
            priceLbl.snp.makeConstraints { maker in
                maker.leading.equalTo(nameLbl.snp.leading)
                maker.trailing.equalTo(nameLbl.snp_trailingMargin)
                maker.top.equalTo(nameLbl.snp.bottom)
            }
        }
        func setOrderStepperConstraint() {
            orderStepper.snp.makeConstraints { maker in
                maker.centerY.equalToSuperview()
                maker.size.equalTo(Style.stepperSize)
                maker.trailing.equalToSuperview()
            }
        }
        self.contentView.addSubview(cardView)
        self.cardView.addSubview(avatarImgView)
        self.cardView.addSubview(nameLbl)
        self.cardView.addSubview(priceLbl)
        self.cardView.addSubview(orderStepper)

        setCardViewConstraint()
        setAvatarConstraint()
        setNameConstraint()
        setPriceConstraint()
        setOrderStepperConstraint()
    }

}

extension ProductCell {
    func configCell(viewModel : OrderList.ProductOrderViewModel,delegate : ProductCellDelegate) {
        self.delegate = delegate
        self.nameLbl.text = viewModel.product.name
        self.priceLbl.text = viewModel.product.price
        self.orderStepper.quntityValue = viewModel.quantity
        guard let urlPath = viewModel.product.photo,
              let url = URL(string: urlPath) else {
            return
        }
        avatarImgView.kf.indicatorType = .activity
        avatarImgView.kf.setImage(with: Source.network(ImageResource(downloadURL: url)),
                                  placeholder: R.image.foodIcon(),
                                  options: [.scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage]) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                self?.avatarImgView.image = R.image.foodIcon()
            }
        }
    }
}

extension ProductCell {
    struct Style {
        static let imageSize : CGSize = CGSize(width: 60, height: 70)
        static let stepperSize = CGSize(width: 100.0, height: 60.0)
    }
}
