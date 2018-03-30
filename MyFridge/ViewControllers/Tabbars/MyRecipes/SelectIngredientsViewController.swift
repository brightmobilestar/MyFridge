//
//  SelectIngredientsViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class SelectIngredientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    private func resetSelectedIngredients() {
        
        for ingredient in GlobData.ingredientsList! {
            let model = ingredient as! IngredientModel
            if (GlobData.selectedIngredientsList!.contains(ingredient)) {
                model.isSelected = true
            } else {
                model.isSelected = false
            }
        }
    }
    
    private func getSelectedIngredients() {
        GlobData.selectedIngredientsList?.removeAllObjects()
        
        for ingredient in GlobData.ingredientsList! {
            if (ingredient as! IngredientModel).isSelected {
                GlobData.selectedIngredientsList?.add(ingredient)
            }
        }
        
        GlobData.sortIngredientsArray(GlobData.selectedIngredientsList)
    }
    
    // MARK: - TableView datasource & delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GlobData.ingredientsList!.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let ingredient = GlobData.ingredientsList!.object(at: indexPath.row) as! IngredientModel
        
        // Image
        let imageView:UIImageView = cell.viewWithTag(1) as! UIImageView
        let url = URL(string: ingredient.imageUrl!)
        imageView.sd_setImage(with: url, completed: nil)
        // Name
        if let nameLabel = cell.viewWithTag(20) as? UILabel {
            nameLabel.text = ingredient.name
        }
        
        // To check if this is selected
        if ingredient.isSelected! {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ingredient = GlobData.ingredientsList!.object(at: indexPath.row) as! IngredientModel
        
        ingredient.isSelected = !ingredient.isSelected
        
        self.ingredientsTableView.reloadData()
    }
    
    // MARK: Control Actions
    @IBAction func onCancelButton(_ sender: Any) {
        
        self.resetSelectedIngredients()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onOkButton(_ sender: Any) {
        
        self.getSelectedIngredients()
        self.navigationController?.popViewController(animated: true)
    }
}
