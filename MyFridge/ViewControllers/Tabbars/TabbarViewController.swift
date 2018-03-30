//
//  TabbarViewController.swift
//  MyFridge
//
//  Created by Administrator on 3/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit


class TabbarViewController: UITabBarController {
    
    //TAB BAR COLORING PROGRAMATICALLY
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: function
    func loadData() {
        IngredientModel.readIngredients( onSuccess: {
            
        }, onError: { error in
            
        })
        
        RecipeModel.readRecipes( onSuccess: {
            
        }, onError: { error in
            
        })
    }
}
