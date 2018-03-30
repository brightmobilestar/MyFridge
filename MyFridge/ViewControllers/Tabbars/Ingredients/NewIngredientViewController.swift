//
//  NewIngredientViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import PKHUD

class NewIngredientViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    var newIngredient: IngredientModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: functions
    func initData() {
        imagePicker.delegate = self
        if newIngredient == nil {
            newIngredient = IngredientModel()
            
            GlobData.selectedIngredientsList.removeAllObjects()
        }
        
//        self.nameTextField.text = "First Ingredient"
    }
    
    func saveIngredient() {
        
    }
    
    // MARK: Control Actions
    @IBAction func onAddImageButton(_ sender: Any) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true) {
            
        }
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCreateButton(_ sender: Any) {
        
        if self.nameTextField.text == "" {
            
            let vc = UIAlertController(title: nil, message: "Please input Ingredient Name", preferredStyle: UIAlertControllerStyle.alert)
            let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil)
            vc.addAction(closeAction)
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        if let profileImg = self.ingredientImageView.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.7) {
            
            newIngredient.imageData = imageData
            newIngredient.uploadImage(onSuccess: {
                
                self.newIngredient.name = self.nameTextField.text
                
                GlobData.ingredientsList?.add(self.newIngredient)
                
                GlobData.sortIngredientsArray(GlobData.ingredientsList)
                
                IngredientModel.saveIngredients()
                
                PKHUD.sharedHUD.hide(animated: true)
                
                self.navigationController?.popViewController(animated: true)
            }, onError: { error in
                PKHUD.sharedHUD.hide(animated: true)
                
                 PKHUD.sharedHUD.contentView = PKHUDErrorView(title:nil, subtitle: error)
                 PKHUD.sharedHUD.show()
                 PKHUD.sharedHUD.hide(afterDelay: 1.0)
                
//                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            ingredientImageView.image = pickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
