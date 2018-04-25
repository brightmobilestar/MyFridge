//
//  GlobData.swift
//  MyFridge
//
//  Created by Administrator on 3/28/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

class GlobData: NSObject {
    
    static var ingredientsList: NSMutableArray!
    static var selectedIngredientsList: NSMutableArray!
    
    static var recipesList: NSMutableArray!
    
    override init() {
        
    }
    
    func initData() {
        if GlobData.ingredientsList == nil {
            GlobData.ingredientsList = NSMutableArray()
        }
        if GlobData.selectedIngredientsList == nil {
            GlobData.selectedIngredientsList = NSMutableArray()
        }
        if GlobData.recipesList == nil {
            GlobData.recipesList = NSMutableArray()
        }
    }
    
    static func sortRecipesArray(_ array: NSMutableArray) {
        array.sort(comparator: { (first, second) -> ComparisonResult in
            let firstName = (first as! RecipeModel).name as! String
            let secondName = (second as! RecipeModel).name as! String
            
            return firstName.compare(secondName)
        })
    }
    
    static func sortIngredientsArray(_ array: NSMutableArray) {
        array.sort(comparator: { (first, second) -> ComparisonResult in
            let firstName = (first as! IngredientModel).name
            let secondName = (second as! IngredientModel).name
            
            return firstName!.compare(secondName!)
        })
    }
    
    //Date to milliseconds
    static func currentTimeInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func showAlert(title: String, msg: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
