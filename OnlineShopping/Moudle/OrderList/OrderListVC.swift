//
//  ProductTableViewController.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import UIKit
import Combine

class OrderListVC: UITableViewController {
    var interactor : (OrderListBusinessLogic & OrderListDataSource)?
    var router : (OrderListRouterLogic & OrderListRouterDataPassing)?
    var viewModel : OrderList.OrdersViewModel?
    private let productReuseIdentifier = "\(ProductCell.self)"
    private let shimmerReuseIdentifier = "\(ShimmerTableViewCell.self)"
    private(set) lazy var refreshCtrl : UIRefreshControl = {
        let tmp = UIRefreshControl()
        tmp.attributedTitle = NSAttributedString(string: R.string.shared.refreshTableviewTitle())
        tmp.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControl.Event.valueChanged)
        return tmp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = R.string.product.titlePage()
        self.navigationItem.leftBarButtonItem = self.barButton(type: .logout, action: #selector(self.logout))
        self.refreshCtrl.beginRefreshing()
        self.interactor?.fetchProducts()
    }
    override func loadView() {
        super.loadView()
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = true
        self.tableView.register(ProductCell.self, forCellReuseIdentifier: productReuseIdentifier)
        self.tableView.register(UINib(resource: R.nib.shimmerTableViewCell), forCellReuseIdentifier: shimmerReuseIdentifier)
        self.tableView.refreshControl = refreshCtrl
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel?.orders.count ?? 10
    }
    // swiftlint:disable force_cast
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let orders = viewModel?.orders else {
            let cell = tableView.dequeueReusableCell(withIdentifier: shimmerReuseIdentifier, for: indexPath) as! ShimmerTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: productReuseIdentifier, for: indexPath) as! ProductCell
        cell.configCell(viewModel: orders[indexPath.row],delegate: self)
        return cell
    }
    // swiftlint:enable force_cast

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router?.naviagteToDetail(index: indexPath.row)
    }

}
extension OrderListVC : OrdersDisplayLogic {
    func show(viewModel: OrderList.OrdersViewModel) {
        self.viewModel = viewModel
        self.tableView.allowsSelection = true
        self.refreshCtrl.endRefreshing()
        self.tableView.reloadData()
    }

    func show(viewModel: OrderList.ErrorViewModel) {
        self.refreshCtrl.endRefreshing()
        self.showAlert(withTitle: R.string.shared.errorTitle(),
                       withMessage: viewModel.message ?? R.string.shared.unknownServerError(),
                       buttonTitle: R.string.shared.ok())
    }
}
extension OrderListVC {
    @objc func refresh(sender : Any) {
        self.interactor?.fetchProducts()
    }
    @objc func logout(sender : Any) {
        self.router?.logout()
    }
}

extension OrderListVC : ProductCellDelegate {
    func update(cell: ProductCell?, value: Int) {
        guard let productCell = cell ,
              let indexPath = tableView.indexPath(for: productCell) else {
            return
        }
        self.interactor?.updateOrder(index: indexPath.row, value: value)
    }

}
