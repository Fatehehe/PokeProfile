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
    private let disposeBag = DisposeBag()
    
    private let pokeProfileLabel : UILabel = {
        let label = UILabel()
        label.text = "POKEMON PROFILE"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let pokeProfileImage : UIImageView = {
        let pk = UIImageView()
        pk.image = UIImage(named: "pokeball")
        pk.contentMode = .scaleAspectFit
        return pk
    }()
    
    private var usernameTextField : UITextField = {
        let usn = UITextField()
        usn.placeholder = "Username"
        usn.textColor = .white
        usn.layer.borderColor = UIColor.lightGray.cgColor
        usn.autocapitalizationType = .none
        usn.autocorrectionType = .no
        usn.layer.borderWidth = 1.0
        usn.layer.cornerRadius = 10
        return usn
    }()
    
    private let passwordTextField : UITextField = {
        let pwd = UITextField()
        pwd.placeholder = "Password"
        pwd.textColor = .white
        pwd.isSecureTextEntry = true
        pwd.layer.borderColor = UIColor.lightGray.cgColor
        pwd.autocapitalizationType = .none
        pwd.autocorrectionType = .no
        pwd.layer.borderWidth = 1.0
        pwd.layer.cornerRadius = 10
        return pwd
    }()
    
    private let loginButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .systemRed
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private let registerButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .systemRed
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        usernameTextField.rx.text.orEmpty
            .bind(to: LoginViewModel.shared.username)
            .disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty
            .bind(to: LoginViewModel.shared.password)
            .disposed(by: disposeBag)
        
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
                print("Login result received: \(success)")
                if success {
                    self.navigateToLanding()
                } else {
                    self.showLoginFailedAlert()
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                }
            })
            .disposed(by: disposeBag)
        
        LoginViewModel.shared.registerResult
            .subscribe(onNext: { success in
                if success {
                    let alert = UIAlertController(
                        title: "Registration Success",
                        message: "Registration successful. Now please try logging in.",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(
                        title: "Registration Failed",
                        message: "Username already exists. Please try again.",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(pokeProfileLabel)
        view.addSubview(pokeProfileImage)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        pokeProfileLabel.translatesAutoresizingMaskIntoConstraints = false
        pokeProfileImage.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pokeProfileLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            pokeProfileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pokeProfileImage.topAnchor.constraint(equalTo: pokeProfileLabel.bottomAnchor, constant: 20),
            pokeProfileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokeProfileImage.heightAnchor.constraint(equalToConstant: 150),
            
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.topAnchor.constraint(equalTo: pokeProfileImage.bottomAnchor, constant: 50),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func navigateToLanding() {
        let landingVC = LandingViewController()
        landingVC.modalPresentationStyle = .fullScreen
        self.present(landingVC, animated: true)
    }
    
    private func showLoginFailedAlert() {
        let alert = UIAlertController(title: "Login Failed", message: "Username or password is incorrect", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default))
        present(alert, animated: true)
    }
    
    private func showRegisterFailedAlert() {
        let alert = UIAlertController(title: "Registration Failed", message: "Username already exists", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default))
        present(alert, animated: true)
    }
}
