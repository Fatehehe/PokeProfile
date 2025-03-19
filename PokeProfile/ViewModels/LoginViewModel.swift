//
//  LoginViewModel.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 19/03/25.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    static let shared = LoginViewModel()
    
    private let userDatabase = UserDatabase()
    private let disposeBag = DisposeBag()
    
    var username = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    var loginResult = PublishSubject<Bool>()
    
    init() {
        userDatabase.createTable()
    }
    
    func login() {
        guard let username = try? self.username.value(), let password = try? self.password.value() else { return }
        print("Logging in with username: \(username) and password: \(password)")  // Debugging line
        let isAuthenticated = userDatabase.authenticateUser(username: username, password: password)
        
        if isAuthenticated {
            UserDefaults.standard.set(username, forKey: "username")
            print("sukses login harusnya")
            self.username.onNext(username)
            self.password.onNext(password)
            loginResult.onNext(true)
        } else {
            self.username.onNext("")
            self.password.onNext("")
            loginResult.onNext(false)
            print("gaksuskses")
        }
    }

    func register() {
        guard let username = try? self.username.value(), let password = try? self.password.value() else { return }
        print("Registering username: \(username) and password: \(password)")  // Debugging line
        let user = User(username: username, password: password)
        userDatabase.saveUser(user: user)
    }
    
    func logout() {
        self.username.onNext("")
        self.password.onNext("")
        self.loginResult.onNext(false)
        UserDefaults.standard.removeObject(forKey: "username")
        print("Logged out and reset values")
    }

}
