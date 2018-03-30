//
//  SignupViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import FirebaseAuth
import PKHUD

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Params
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    // MARK: ViewController Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: Functions
    func initData() {
        imagePicker.delegate = self
        
//        self.emailTextField.text = "yi.lingdao@hotmail.com"
//        self.passTextField.text = "administrator123"
    }
    
    func register(_ email: String, _ password: String) {
        
        if !GlobData.isValidEmail(testStr: emailTextField.text!) {
            GlobData.showAlert(title: "Error", msg: "Invaild email", viewController: self)
            return
        }
        if firstNameTextField.text?.count == 0 {
            GlobData.showAlert(title: "Error", msg: "Please enter first name", viewController: self)
            return
        }
        if lastNameTextField.text?.count == 0 {
            GlobData.showAlert(title: "Error", msg: "Please enter last name", viewController: self)
            return
        }
        if passTextField.text?.count == 0 {
            GlobData.showAlert(title: "Error", msg: "Please enter password", viewController: self)
            return
        }
        if passTextField.text != confirmPwdTextField.text {
            GlobData.showAlert(title: "Error", msg: "Password doesn't match to the confirm password", viewController: self)
            return
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        if let profileImg = self.profileImageView.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.7) {
            
            AuthService.signUp(username: email, email: email, password: password, imageData: imageData, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, onSuccess: {
                
                PKHUD.sharedHUD.hide(animated: true)
                self.moveToHome()
                
            }, onError: { (error) in
                PKHUD.sharedHUD.hide(animated: true)
                
                PKHUD.sharedHUD.contentView = PKHUDErrorView(title:nil, subtitle: error)
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
            })
        }
        
    }
    
    func moveToHome() {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Control Actions
    @IBAction func onAddImageButton(_ sender: Any) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true) {
            
        }
    }
    @IBAction func onBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onRegisterButton(_ sender: Any) {
        
        self.register(self.emailTextField.text!, self.passTextField.text!)
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
