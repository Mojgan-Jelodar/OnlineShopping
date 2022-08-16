//
//  ProductDetailVC.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import UIKit
import SnapKit
import Kingfisher

class OrderDetailVC: UIViewController {
    var interactor : (OrderDetailBusinessLogic & OrderDetailDataStore)?
    private(set) lazy var avatarImgView : UIImageView = {
        let tmp = UIImageView()
        tmp.contentMode = .scaleAspectFit
        tmp.image = R.image.foodIcon()
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
    private(set) lazy var totalPriceLbl : UILabel = {
        let tmp = UILabel()
        tmp.font = UIFont.systemFont(ofSize: LayoutContants.Shared.fontSize, weight: UIFont.Weight.regular)
        tmp.numberOfLines = 0
        tmp.lineBreakMode = .byTruncatingTail
        return tmp
    }()
    private(set) lazy var descriptionLbl : UILabel = {
        let tmp = UILabel()
        tmp.font = UIFont.systemFont(ofSize: LayoutContants.Shared.fontSize, weight: UIFont.Weight.regular)
        tmp.numberOfLines = 0
        tmp.lineBreakMode = .byTruncatingTail
        return tmp
    }()
    private(set) lazy var verticalHolderView : UIStackView = {
        let tmp = UIStackView()
        tmp.axis = .vertical
        tmp.distribution = .fill
        tmp.spacing = LayoutContants.Shared.spacing
        return tmp
    }()
    private(set) lazy var shoppingHolderView : UIStackView = {
        let tmp = UIStackView()
        tmp.axis = .horizontal
        tmp.distribution = .equalCentering
        tmp.spacing = LayoutContants.Shared.spacing
        return tmp
    }()

    private(set) lazy var shoppingFirstColumnView : UIStackView = {
        let tmp = UIStackView()
        tmp.axis = .vertical
        tmp.distribution = .equalCentering
        tmp.spacing = LayoutContants.Shared.spacing
        return tmp
    }()
    private(set) lazy var shoppingSecondColumnView : UIStackView = {
        let tmp = UIStackView()
        tmp.axis = .vertical
        tmp.distribution = .fill
        tmp.spacing = LayoutContants.Shared.spacing
        return tmp
    }()
    private(set) lazy var orderStepper : OrderStepper = {
        let tmp = OrderStepper { [weak self] (value) in
            self?.interactor?.updateOrder(value: value)
        }
        return tmp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.interactor?.fecthOrder()

    }
    override func loadView() {
        let contentView = UIView()
        view = contentView
        contentView.addSubview(verticalHolderView)
        verticalHolderView.addArrangedSubview(avatarImgView)
        verticalHolderView.addArrangedSubview(shoppingHolderView)
        shoppingHolderView.addArrangedSubview(shoppingFirstColumnView)
        shoppingHolderView.addArrangedSubview(shoppingSecondColumnView)
        shoppingFirstColumnView.addArrangedSubview(nameLbl)
        shoppingFirstColumnView.addArrangedSubview(priceLbl)
        shoppingSecondColumnView.addArrangedSubview(orderStepper)
        shoppingSecondColumnView.addArrangedSubview(totalPriceLbl)
        verticalHolderView.addArrangedSubview(descriptionLbl)
        verticalHolderView.addArrangedSubview(UIView())
        verticalHolderView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(LayoutContants.Shared.margin)
        }
        avatarImgView.snp.makeConstraints { maker in
            maker.height.equalToSuperview().multipliedBy(0.3)
        }
        orderStepper.snp.makeConstraints { maker in
            maker.size.equalTo(OrderDetail.Style.stepperSize)
        }
    }
}
extension OrderDetailVC : OrderDetailDisplayLogic {
    func show(viewModel: OrderDetail.ViewModel) {
        defer {
            if  let url = try? viewModel.photo.asURL() {
            avatarImgView.kf.indicatorType = .activity
            avatarImgView.kf.setImage(with: Source.network(ImageResource(downloadURL:url )),
                                      placeholder: R.image.foodIcon(),
                                      options: nil)
            }
        }
        self.nameLbl.text = viewModel.name
        self.descriptionLbl.text = viewModel.description
        self.priceLbl.text = viewModel.price
        self.orderStepper.quntityValue = viewModel.quantity
        self.totalPriceLbl.text = viewModel.totalPrice
    }
}
