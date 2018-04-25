//
//  RecipeModel.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class RecipeModel: NSObject {
    
    var imageData: Data!
    var imageUrl: String!
    var name: String!
    var ingredientArray: NSMutableArray!
    
    
    override init() {
        imageData = Data()
        imageUrl = ""
        name = ""
        ingredientArray = NSMutableArray()
    }
    
    static func readRecipes(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        let ref = Database.database().reference()
        let ingredReference = ref.child(FireBase_RECIPES)
        ingredReference.observe(.value) { (snapshot) in
            let _value = snapshot.value as? NSArray
            
            if _value == nil {
                
            } else {
                
                GlobData.recipesList?.removeAllObjects()
                
                for dic  in _value! {
                    
                    let dicc = dic as! NSDictionary
                    let model = RecipeModel.init()
                    model.imageUrl = dicc.value(forKey: REC_IMAGEURL) as? String
                    model.name = dicc.value(forKey: REC_NAME) as? String
                    
                    model.ingredientArray = NSMutableArray()
                    let ingredArray = dicc.value(forKey: REC_INGREDIENTS) as! NSArray
                    for dic1  in ingredArray {
                        
                        let dicc1 = dic1 as! NSDictionary
                        let model1 = IngredientModel.init()
                        model1.imageUrl = dicc1.value(forKey: ING_IMAGEURL) as? String
                        model1.name = dicc1.value(forKey: ING_NAME) as? String
                        
                        model.ingredientArray.add(model1)
                    }
                    
                    GlobData.recipesList?.add(model)
                }
            }
            
            GlobData.sortRecipesArray(GlobData.recipesList)
            
//            GlobData.recipesList.sort(comparator: { (first, second) -> ComparisonResult in
//                let firstName = first.name as! String
//                let secondName = second.name as! String
//
//                return firstName.compare(secondName)
//                }
            
            
//            GlobData.recipesList.sort(by: { (first: IngredientModel, second: IngredientModel) -> Bool in
//                first.name < second.name
//            })
//
            onSuccess()
        }
    }
    
    static func saveRecipes() {
        
        let array = RecipeModel.convertToDictionaryArray(GlobData.recipesList!)
        
        let ref = Database.database().reference()
        let ingredReference = ref.child(FireBase_RECIPES)
        
        if array.count == 1 {
            ingredReference.setValue(array)
        } else {
            
            let childUpdates = ["/" + FireBase_RECIPES: array]
            ref.updateChildValues(childUpdates)
        }
    }
    
    func uploadImage(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        let currentTime = "Rec_" + String(GlobData.currentTimeInMiliseconds()) + ".png"
        
        let storageRef = Storage.storage().reference().child(currentTime)//.child(currentTime)
        
        storageRef.putData(imageData!, metadata: nil) { (metadata, error) in
            if error != nil {
                onError(error?.localizedDescription)
            } else {
                let _imageUrl = metadata?.downloadURL()?.absoluteString
                self.imageUrl = _imageUrl
                onSuccess()
            }
        }
    }
    
    static func convertToDictionaryArray(_ orinArray: NSMutableArray) -> NSArray {
        
        let mutArray = NSMutableArray.init()
        
        for recipe in orinArray {
            
            let model = recipe as! RecipeModel
            
            let mutArray1 = NSMutableArray.init()
            for ingredient in model.ingredientArray {
                
                let model1 = ingredient as! IngredientModel
                let dic1 = NSDictionary.init(objects: [model1.name!, model1.imageUrl], forKeys: [ING_NAME as NSCopying, ING_IMAGEURL as NSCopying])
                
                mutArray1.add(dic1)
            }
            
            let dic = NSDictionary.init(objects: [model.name!, model.imageUrl, mutArray1.copy() as! NSArray], forKeys: [REC_NAME as NSCopying, REC_IMAGEURL as NSCopying, REC_INGREDIENTS as NSCopying])
            mutArray.add(dic)
        }
        
        return mutArray.copy() as! NSArray
    }
    
}
