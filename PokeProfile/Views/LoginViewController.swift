//
//  LoginViewController.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 18/03/25.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
//    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let registerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Bind the UI elements to the ViewModel
        usernameTextField.rx.text.orEmpty.bind(to: LoginViewModel.shared.username).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: LoginViewModel.shared.password).disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: {
                LoginViewModel.shared.login()
            })
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .subscribe(onNext: {
                LoginViewModel.shared.register()
            })
            .disposed(by: disposeBag)
        
        LoginViewModel.shared.loginResult
            .subscribe(onNext: { success in
                print("Login result received: \(success)") // Debugging line
                if success {
                    self.navigateToLanding()
                } else {
                    self.showLoginFailedAlert()
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                }
            })
            .disposed(by: disposeBag)

    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Setup TextFields and Buttons
        usernameTextField.placeholder = "Username"
        usernameTextField.textColor = .white
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.cornerRadius = 10
        
        passwordTextField.placeholder = "Password"
        passwordTextField.textColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 10
        
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .blue
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .green
        
        // Add UI elements to the view
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        // Set up constraints (example using AutoLayout)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            usernameTextField.widthAnchor.constraint(equalToConstant: 200),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    
    private func navigateToLanding() {
        let landingVC = LandingViewController()
        landingVC.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(landingVC, animated: true)
        self.present(landingVC, animated: true)
    }
    
    private func showLoginFailedAlert() {
        let alert = UIAlertController(title: "Error", message: "Invalid credentials", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

