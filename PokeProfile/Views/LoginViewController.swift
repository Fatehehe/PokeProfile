//
//  LoginViewController.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 18/03/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    func navigateToLanding() {
        let landingVC = LandingViewController()
        navigationController?.pushViewController(landingVC, animated: true)
    }
}
