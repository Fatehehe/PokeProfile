//
//  ProfileViewController.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 18/03/25.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController, IndicatorInfoProvider {
    var viewModel: ProfileViewModel
    
    private let disposeBag = DisposeBag()
    
    
    private let textUsername = UILabel()
    private let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        LoginViewModel.shared.username
            .bind(to: textUsername.rx.text)
            .disposed(by: disposeBag)
        
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        view.backgroundColor = .systemBackground
        textUsername.font = UIFont.systemFont(ofSize: 24)
        textUsername.textColor = .white
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .red
        logoutButton.layer.cornerRadius = 10
        
        textUsername.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textUsername)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            textUsername.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textUsername.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: textUsername.bottomAnchor, constant: 100),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    
    }
    
    @objc func logoutTapped() {
        // Navigate back to LoginViewController
        LoginViewModel.shared.logout()
        
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: viewModel.title)
    }
}
