//
//  SignUpVC.swift
//  MDB Social
//
//  Created by Jennessa Ma on 3/2/21.
//

import UIKit
import NotificationBannerSwift

class SignUpVC: UIViewController {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign Up"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let fullNameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Full Name:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let emailTextField: AuthTextField = {
        let tf = AuthTextField(title: "Email:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let usernameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Username:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Password:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let signUpButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Sign Up!", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let signupButtonHeight: CGFloat = 44.0
    
    private let contentEdgeInset = UIEdgeInsets(top: 35, left: 40, bottom: 30, right: 40)
    
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(red: 246/255, green: 244/255, blue: 244/255, alpha: 1)
        view.backgroundColor = .background
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdgeInset.right)
        ])
        
        view.addSubview(stack)
        stack.addArrangedSubview(fullNameTextField)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(passwordTextField)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                       constant: 60)
        ])
        
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            signUpButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: signupButtonHeight)
        ])
        
        signUpButton.layer.cornerRadius = signupButtonHeight / 2
        signUpButton.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }
    
    @objc func didTapSignUp(_ sender: UIButton) {
        guard let fullName = fullNameTextField.text, fullName != "" else {
            showErrorBanner(withTitle: "Missing full name",
                            subtitle: "Please provide a full name")
            return
        }
        
        guard let email = emailTextField.text, email != "" else {
            showErrorBanner(withTitle: "Missing email",
                            subtitle: "Please provide an email")
            return
        }
        
        guard let username = usernameTextField.text, username != "" else {
            showErrorBanner(withTitle: "Missing username",
                            subtitle: "Please provide a username")
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            showErrorBanner(withTitle: "Missing password",
                            subtitle: "Please provide a password")
            return
        }
        
        signUpButton.showLoading()
        FIRAuthProvider.shared.signUp(withFullname: fullName, withEmail: email, withUsername: username,
                                      withPassword: password) { [weak self] result in
            defer {
                self?.signUpButton.hideLoading()
            }
            
            switch result {
            case .success:
                //copied from SignInVC
                guard let window = UIApplication.shared
                        .windows.filter({ $0.isKeyWindow }).first else { return }
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                window.rootViewController = vc
                let options: UIView.AnimationOptions = .transitionCrossDissolve
                let duration: TimeInterval = 0.3
                UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
            case .failure(let error):
                self?.showErrorBanner(withTitle: error.localizedDescription)
            }
        }
        
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}
