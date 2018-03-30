//
//  NewRecipeViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import PKHUD

class NewRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var imageEditButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var editRecipesButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var newRecipe: RecipeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ingredientsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: functions
    func initData() {
        imagePicker.delegate = self
        
        if (self.newRecipe != nil) {
            titleLabel.text = "My Recipe"
            createButton.isHidden = true
            nameTextField.isEnabled = false
            editRecipesButton.isHidden = true
            imageEditButton.isEnabled = false
            
            self.nameTextField.text = self.newRecipe.name
            
            GlobData.selectedIngredientsList = self.newRecipe.ingredientArray
        } else {
            self.newRecipe = RecipeModel()
            
            GlobData.selectedIngredientsList.removeAllObjects()
        }
        
//        self.nameTextField.text = "First Recipe"
    }
    
    // MARK: - TableView datasource & delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if GlobData.selectedIngredientsList == nil {
            GlobData.selectedIngredientsList = NSMutableArray()
        }
        return GlobData.selectedIngredientsList!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let ingredient = GlobData.selectedIngredientsList!.object(at: indexPath.row) as! IngredientModel
        
        // Image
        let imageView:UIImageView = cell.viewWithTag(1) as! UIImageView
        let url = URL(string: ingredient.imageUrl!)
        imageView.sd_setImage(with: url, completed: nil)
        // Name
        if let nameLabel = cell.viewWithTag(20) as? UILabel {
            nameLabel.text = ingredient.name
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            let closeAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
            vc.addAction(closeAction)
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        if GlobData.selectedIngredientsList!.count == 0 {
            let vc = UIAlertController(title: nil, message: "Please select Ingredients", preferredStyle: UIAlertControllerStyle.alert)
            let closeAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
            vc.addAction(closeAction)
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        if let profileImg = self.recipeImageView.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.7) {
            
            newRecipe.imageData = imageData
            newRecipe.uploadImage(onSuccess: {
                
                self.newRecipe.name = self.nameTextField.text
                self.newRecipe.ingredientArray = GlobData.selectedIngredientsList
                
                GlobData.recipesList?.add(self.newRecipe)
                
                GlobData.sortRecipesArray(GlobData.recipesList)
                
                RecipeModel.saveRecipes()
                
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
            recipeImageView.image = pickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

