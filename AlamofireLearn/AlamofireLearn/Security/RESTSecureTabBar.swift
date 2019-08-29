//
//  RESTSecureTabBar.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/28/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit

class RESTSecureTabBar: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let publicRESTVC = PublicRESTVC()
        let secureRESTVC = SecuredRESTVC()
        
        publicRESTVC.tabBarItem = UITabBarItem(title: "Pokemon", image: UIImage(named: "pokemon"), tag: 1)
        secureRESTVC.tabBarItem = UITabBarItem(title: "Evolve", image: UIImage(named: "evolve"), tag: 2)
        self.viewControllers = [publicRESTVC, secureRESTVC]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(popUpLoginScreen))
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLoginSuccess),
                                               name: NSNotification.Name("login_sucess"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = self.selectedViewController?.tabBarItem.title
    }
    
    func tabBarController(_: UITabBarController, didSelect: UIViewController) {
        self.navigationItem.title = didSelect.tabBarItem.title
    }
    
    @objc func popUpLoginScreen() {
        let loginVC = LoginVC()
        self.present(loginVC, animated: true)
    }
    
    
    @objc func onLoginSuccess() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        ServerSetting.logout()
        NotificationCenter.default.post(name: NSNotification.Name("logout"), object: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(popUpLoginScreen))
    }
}
