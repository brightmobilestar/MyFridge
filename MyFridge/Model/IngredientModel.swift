//
//  IngredientModel.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

class IngredientModel: NSObject {
    
    var imageData: Data!
    var imageUrl: String!
    var name: String!
    
    var isSelected: Bool!
    
    override init() {
        imageData = Data()
        imageUrl = ""
        name = ""
        
        isSelected = false
    }
    
    static func readIngredients(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        let ref = Database.database().reference()
        let ingredReference = ref.child(FireBase_INGREDIENTS)
        ingredReference.observe(.value) { (snapshot) in
            let _value = snapshot.value as? NSArray
            
            if _value == nil {
                
            } else {
                
                GlobData.ingredientsList?.removeAllObjects()
                
                for dic in _value! {
                    
                    let dicc = dic as! NSDictionary
                    let model = IngredientModel.init()
                    model.imageUrl = dicc.value(forKey: ING_IMAGEURL) as? String
                    model.name = dicc.value(forKey: ING_NAME) as? String
                    
                    GlobData.ingredientsList?.add(model)
                }
            }
            
            GlobData.sortIngredientsArray(GlobData.ingredientsList)
            
            onSuccess()
        }
    }
    
    static func saveIngredients() {
        
        let array = IngredientModel.convertToDictionaryArray(GlobData.ingredientsList!)
        
        let ref = Database.database().reference()
        let ingredReference = ref.child(FireBase_INGREDIENTS)
        
        if array.count == 1 {
            ingredReference.setValue(array)
        } else {
            
            let childUpdates = ["/" + FireBase_INGREDIENTS: array]
            ref.updateChildValues(childUpdates)
        }
    }
    
    func uploadImage(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        let currentTime = "Ing_" + String(GlobData.currentTimeInMiliseconds()) + ".png"
        
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
        
        for ingredient in orinArray {
            
            let model = ingredient as! IngredientModel
            let dic = NSDictionary.init(objects: [model.name!, model.imageUrl], forKeys: [ING_NAME as NSCopying, ING_IMAGEURL as NSCopying])
             mutArray.add(dic)
        }
        
        return mutArray.copy() as! NSArray
    }
 
    
}
