//
//  ProfileViewController.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 18/03/25.
//

import UIKit
import XLPagerTabStrip

class ProfileViewController: UIViewController, IndicatorInfoProvider {
    var viewModel: ProfileViewModel
    private let logoutButton = UIButton()
        
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            view.backgroundColor = .lightGray
//            
//            logoutButton.setTitle("Logout", for: .normal)
//            logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
//            view.addSubview(logoutButton)
//        }
        
    @objc func logoutTapped() {
        // Navigate back to LoginViewController
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: true)
    }

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        view.addSubview(logoutButton)
        view.backgroundColor = .lightGray
        let label = UILabel(frame: view.bounds)
        label.text = "Profile Tab"
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: viewModel.title)
    }
}
