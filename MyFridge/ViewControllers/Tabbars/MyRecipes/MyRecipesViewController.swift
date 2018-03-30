//
//  MyRecipesViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage

class MyRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recipesTableView: UITableView!
    
    var searchRecipes: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchRecipes = NSMutableArray.init()
        readData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recipesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: functions
    func readData() {
        //        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        //        PKHUD.sharedHUD.show()
        
        RecipeModel.readRecipes( onSuccess: {
            
            //            PKHUD.sharedHUD.hide(animated: true)
            
            self.recipesTableView.reloadData()
            
        }, onError: { error in
            
            //            PKHUD.sharedHUD.hide(animated: true)
            
            PKHUD.sharedHUD.contentView = PKHUDErrorView(title:"Error", subtitle: error)
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 1.0)
            
        })
    }
    
    func searchRecipe(_ searchText: String) {
        
        searchRecipes.removeAllObjects()
        
        for recipe in GlobData.recipesList {
            let model = recipe as! RecipeModel
            
            if model.name.contains(searchText) {
                searchRecipes.add(model)
            }
        }
        
        recipesTableView.reloadData()
    }
    
    func moveToDetail(_ recipe: RecipeModel) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewRecipeVC") as? NewRecipeViewController {
            
            viewController.newRecipe = recipe
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    // MARK: Serchbar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchRecipe(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        recipesTableView.reloadData()
    }
    
    // MARK: - TableView datasource & delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBar.text?.count != 0 {
            return searchRecipes.count
        } else {
            return GlobData.recipesList!.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var recipe = RecipeModel()
        if searchBar.text?.count != 0 {
            recipe = searchRecipes!.object(at: indexPath.row) as! RecipeModel
        } else {
            recipe = GlobData.recipesList!.object(at: indexPath.row) as! RecipeModel
        }
        
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
        
        var recipe = RecipeModel()
        if searchBar.text?.count != 0 {
            recipe = searchRecipes!.object(at: indexPath.row) as! RecipeModel
        } else {
            recipe = GlobData.recipesList!.object(at: indexPath.row) as! RecipeModel
        }
        self.moveToDetail(recipe)
    }
    
    // MARK: Control Actions
    @IBAction func onAddRecipeButton(_ sender: Any) {
        
    }
}

