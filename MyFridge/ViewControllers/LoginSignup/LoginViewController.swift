//
//  LoginViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import FirebaseAuth
import PKHUD
//import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    
    // MARK: Params
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.emailTextField.text = "yi.lingdao@hotmail.com"
//        self.passwordTextField.text = "administrator123"
        
        if let user = Auth.auth().currentUser {
            self.moveToHome()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    // MARK: functions
    func login(_ email: String, _ password: String) {
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        AuthService.signIn(email: email, password: password, onSuccess: {
            
            PKHUD.sharedHUD.hide(animated: true)
            self.moveToHome()
        }, onError: { error in
            
            PKHUD.sharedHUD.hide(animated: true)
            
            
            PKHUD.sharedHUD.contentView = PKHUDErrorView(title:"Login Error", subtitle: error)
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 1.0)
            
//            self.moveToHome()
        })
    }
    
    func moveToHome() {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") {
            
//            self.present(viewController, animated: true, completion: {
//
//            })
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: Control Actions
    @IBAction func onLoginButton(_ sender: Any) {
        
        self.login(self.emailTextField.text!, self.passwordTextField.text!)
    }
    
    @IBAction func onSignupButton(_ sender: Any) {
        
    }
}

