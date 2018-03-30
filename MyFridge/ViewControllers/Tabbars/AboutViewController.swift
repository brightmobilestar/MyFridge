//
//  AboutViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import FirebaseAuth

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Control Actions
    @IBAction func onBackButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        var isSignedout = false
        do {
            try Auth.auth().signOut()
            isSignedout = true
        } catch { //let error
            
        }
        
        if isSignedout {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNC") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func onVisiteButton(_ sender: Any) {
        if let url = URL(string: "http://myfridgefood.com/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
