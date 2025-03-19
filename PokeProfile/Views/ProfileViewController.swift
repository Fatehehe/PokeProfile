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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        LoginViewModel.shared.username
            .bind(to: textUsername.rx.text)
            .disposed(by: disposeBag)
    }

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        view.backgroundColor = .lightGray
        textUsername.font = UIFont.systemFont(ofSize: 24)
        textUsername.textColor = .black
        
        textUsername.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textUsername)
        
        NSLayoutConstraint.activate([
            textUsername.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textUsername.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    
    }
    
    @objc func logoutTapped() {
        // Navigate back to LoginViewController
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: viewModel.title)
    }
}
