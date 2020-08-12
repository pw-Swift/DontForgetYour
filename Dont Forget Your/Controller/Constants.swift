//
//  Constants.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 01/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

struct K {
    
    //TableViewSection
    static let numberOfSectionsInCategory = 2
    static let numberOfSectionsInItem = 2
    
    //CornerRadius
    static let labelCornerRadius: CGFloat = 15.0
    
    //Segue Identifier
    static let categoryToNew = "CategoryToNew"
    static let cellNewCategory = "CellCategoryToNew"
    static let categoryCell = "CategoryCell"
    
    static let categoryToItems = "CategoryToItems"
    static let itemCell = "ItemCell"
    static let itemCellButton = "ItemCellButton"
    
    static let itemToDetail = "ItemToDetail"
    static let itemToNewDetail = "ItemToNewDetail"
    
    //Images
    static let happyFace = "HappyFace"
    static let sadFace = "SadFace"
    
    //Button States
    static let buttonValid = "OK"
    static let buttonUnvalid = "Cancel"
    static let buttonEmpty = ""
    
    //Path File
    static let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
}


