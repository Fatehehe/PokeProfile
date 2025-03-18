//
//  LandingViewController.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 18/03/25.
//

import UIKit
import XLPagerTabStrip

class LandingViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .blue
        settings.style.buttonBarItemBackgroundColor = .blue
        settings.style.selectedBarBackgroundColor = .red
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        
        super.viewDidLoad()
        
        buttonBarView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonBarView.heightAnchor.constraint(equalToConstant: 50),
            
            containerView.topAnchor.constraint(equalTo: buttonBarView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let homeVC = HomeViewController(viewModel: HomeViewModel())
        let profileVC = ProfileViewController(viewModel: ProfileViewModel())
        return [homeVC, profileVC]
    }
}
