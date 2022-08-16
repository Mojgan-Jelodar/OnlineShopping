//
//  LoginViewController.swift
//  choco-hiring
//
//  Created by Mozhgan on 9/27/21.
//

import UIKit
import SnapKit

class LoginVC: UIViewController {
    var interactor : LoginBusinessLogic?
    var router : LoginRouterLogic?
    private(set) lazy var emailTextFiled : UsernameTextField = {
        let tmp = UsernameTextField(frame: CGRect.zero)
        tmp.text = "user@choco.com"
        return tmp
    }()
    private(set) lazy var passwordTextField : PasswordTextField = {
        let tmp = PasswordTextField(frame: CGRect.zero)
        tmp.text = "chocorian"
        return tmp
    }()

    private(set) lazy var loginButton : ChocoButton = {
        let tmp = ChocoButton(frame: CGRect.zero)
        tmp.setTitle(R.string.login.loginButtonTitle(), for: UIControl.State.normal)
        tmp.addTarget(self, action: #selector(loginPressed(sender:)), for: .touchUpInside)
        return tmp
    }()
    private(set) lazy var holderView : UIStackView = {
        let tmp = UIStackView()
        tmp.axis = .vertical
        tmp.distribution = .fill
        tmp.spacing = LayoutContants.Shared.spacing
        return tmp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = R.string.login.titlePage()

    }
    override func loadView() {
        // super.loadView()
        let contentView = UIView()
        view = contentView
        view.addSubview(holderView)
        holderView.addArrangedSubview(emailTextFiled)
        holderView.addArrangedSubview(passwordTextField)
        holderView.addArrangedSubview(SpacerView())
        holderView.addArrangedSubview(loginButton)
        holderView.addArrangedSubview(SpacerView())

        self.holderView.snp.makeConstraints { maker in
            maker.leadingMargin.trailingMargin.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }

    @objc func loginPressed(sender : Any) {
        loginButton.lock()
        self.interactor?.loginPressed(username: emailTextFiled.text ?? "",
                                      password: passwordTextField.text ?? "")
    }

}
extension LoginVC : LoginDisplayLogic {
    func show(viewModel: Login.ViewModel) {
        loginButton.unlock()
        self.showAlert(withTitle: R.string.shared.errorTitle(),
                       withMessage: viewModel.message,
                       buttonTitle: R.string.shared.ok())
    }

    func loggedIn() {
        router?.naviagteToDashboard()
    }
}
