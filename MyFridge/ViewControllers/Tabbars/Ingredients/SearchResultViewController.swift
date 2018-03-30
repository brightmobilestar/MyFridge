//
//  SearchResultViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/28/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import PKHUD

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var resultRecipesArray: NSMutableArray!
    
    @IBOutlet weak var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initData()
        
        self.searchRecipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: function
    func initData() {
        resultRecipesArray = NSMutableArray.init()
    }
    
    func searchRecipes() {
        
        for recipe in GlobData.recipesList {
            let model = recipe as! RecipeModel
            
            if self.checkContainsSelectedIngredients(model) {
                self.resultRecipesArray.add(model)
            }
        }
        
        if self.resultRecipesArray.count == 0 {
            GlobData.showAlert(title: "", msg: "No Result", viewController: self)
        }
        
        GlobData.sortRecipesArray(self.resultRecipesArray)
        
        resultTableView.reloadData()
        
        GlobData.selectedIngredientsList.removeAllObjects()
    }
    
    func checkContainsSelectedIngredients(_ recipe: RecipeModel) -> Bool {
        
        for ingredient in GlobData.selectedIngredientsList {
            let model1 = ingredient as! IngredientModel
            
            if ( !self.checkContainsOneIngredient(recipe, model1) ) {
                return false
            }
        }
        
        return true
    }
    
    func checkContainsOneIngredient(_ recipe:RecipeModel, _ ingredient: IngredientModel) -> Bool {
        for ingre in recipe.ingredientArray {
            let model = ingre as! IngredientModel
            
            if ( model.name == ingredient.name) {
                return true
            }
        }
        
        return false
    }
    
    func moveToDetail(_ recipe: RecipeModel) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewRecipeVC") as? NewRecipeViewController {
            
            viewController.newRecipe = recipe
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - TableView datasource & delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultRecipesArray.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let recipe = resultRecipesArray!.object(at: indexPath.row) as! RecipeModel
        
        // Image
        let imageView:UIImageView = cell.viewWithTag(1) as! UIImageView
        let url = URL(string: recipe.imageUrl!)
        imageView.sd_setImage(with: url, completed: nil)
        
        // Name
        if let nameLabel = cell.viewWithTag(2) as? UILabel {
            nameLabel.minimumScaleFactor = 0.5
            nameLabel.numberOfLines = 0
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.text = recipe.name
        }
        
        // Ingredients
        var strIngredients = ""
        for ingredient in recipe.ingredientArray {
            let model = ingredient as! IngredientModel
            if strIngredients.count == 0 {
                strIngredients = model.name
            } else {
                strIngredients = strIngredients + ", " + model.name
            }
        }
        if let nameLabel = cell.viewWithTag(3) as? UILabel {
            nameLabel.text = strIngredients
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recipe = resultRecipesArray!.object(at: indexPath.row) as! RecipeModel
        self.moveToDetail(recipe)
    }
    
    // MARK: Control Actions
    @IBAction func onBackButton(_ sender: Any) {
        
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

