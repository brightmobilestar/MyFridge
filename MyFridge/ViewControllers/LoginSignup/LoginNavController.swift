//
//  LoginNavViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class LoginNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initGlobParams()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Control Actions
    func initGlobParams() {
        GlobData().initData()
    }
    
    // MARK: Control Actions
    @IBAction func onLoginButton(_ sender: Any) {
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onSignupButton(_ sender: Any) {
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
}

