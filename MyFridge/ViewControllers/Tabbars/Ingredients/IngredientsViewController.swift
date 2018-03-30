//
//  IngredientsViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage

class IngredientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var findRecipesView: UIView!
    @IBOutlet weak var selectedIngredTableView: UITableView!
    
    var selectedIngredientsArray: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        selectedIngredientsArray = NSMutableArray.init()
        readData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ingredientsTableView.reloadData()
        findRecipesView.isHidden = true
        selectedIngredTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readData() {
//        PKHUD.sharedHUD.contentView = PKHUDProgressView()
//        PKHUD.sharedHUD.show()
        
        IngredientModel.readIngredients( onSuccess: {
            
//            PKHUD.sharedHUD.hide(animated: true)
            
            self.ingredientsTableView.reloadData()
            
        }, onError: { error in
            
//            PKHUD.sharedHUD.hide(animated: true)
            
             PKHUD.sharedHUD.contentView = PKHUDErrorView(title:"Error", subtitle: error)
             PKHUD.sharedHUD.show()
             PKHUD.sharedHUD.hide(afterDelay: 1.0)
            
        })
    }
    
    func moveFindView() {
        
        if selectedIngredientsArray.count > 0 {
            findRecipesView.isHidden = false
        } else {
            findRecipesView.isHidden = true
        }
    }
    
    // MARK: - TableView datasource & delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.isEqual(ingredientsTableView) {
            return GlobData.ingredientsList!.count
        } else { // If selectedIngredTableView
            return selectedIngredientsArray.count
        }        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var ingredient = IngredientModel()
        
        if tableView.isEqual(ingredientsTableView) {
            ingredient = GlobData.ingredientsList!.object(at: indexPath.row) as! IngredientModel
            
            if selectedIngredientsArray.contains(ingredient) {
                
                if let backView = cell.viewWithTag(10) {
                    backView.backgroundColor = UIColor.white
                }
                
                if let nameLabel = cell.viewWithTag(20) as? UILabel {
                    nameLabel.textColor = UIColor.black
                }
            } else {
                
                if let backView = cell.viewWithTag(10) as? UIView {
                    backView.backgroundColor = UIColor.clear
                }
                
                if let nameLabel = cell.viewWithTag(20) as? UILabel {
                    nameLabel.textColor = UIColor.white
                }
            }
        } else { // If selectedIngredTableView
            ingredient = selectedIngredientsArray.object(at: indexPath.row) as! IngredientModel
        }
        
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
        
        if tableView.isEqual(ingredientsTableView) {
            let ingredient = GlobData.ingredientsList!.object(at: indexPath.row)
            
            if !selectedIngredientsArray.contains(ingredient) {
                selectedIngredientsArray.add(ingredient)
            } else {
                selectedIngredientsArray.remove(ingredient)
            }
        } else { // If selectedIngredTableView
            let ingredient = selectedIngredientsArray.object(at: indexPath.row)
            
            selectedIngredientsArray.remove(ingredient)
        }
        self.moveFindView()
        
        GlobData.sortIngredientsArray(selectedIngredientsArray)
        
        GlobData.selectedIngredientsList = selectedIngredientsArray
        
        ingredientsTableView.reloadData()
        selectedIngredTableView.reloadData()
    }
    
    // MARK: Control Actions
    @IBAction func onCancelButton(_ sender: Any) {
        selectedIngredientsArray.removeAllObjects()
        
        ingredientsTableView.reloadData()
        selectedIngredTableView.reloadData()
    }
    @IBAction func onAddIngredientButton(_ sender: Any) {
        
    }
    @IBAction func onFindRecipesButton(_ sender: Any) {
        
    }
}

