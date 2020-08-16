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
    
    struct segueIdentifier {
        static let categoryToNew = "CategoryToNew"
        static let cellNewCategory = "CellCategoryToNew"
        static let categoryCell = "CategoryCell"
        
        static let categoryToItems = "CategoryToItems"
        static let itemCell = "ItemCell"
        static let itemCellButton = "ItemCellButton"
        
        static let itemToDetail = "ItemToDetail"
        static let itemToNewDetail = "ItemToNewDetail"
    }

    
    struct Image{
        static let happyFace = "HappyFace"
        static let sadFace = "SadFace"
        static let hanger = "Hanger"
        static let hangerGray = "HangerGray"
    }
    
    struct buttonState{
        static let buttonValid = "OK"
        static let buttonUnvalid = "Cancel"
        static let buttonEmpty = ""
    }
    
    struct Colors {
        
        static let coral = UIColor(red: 231/255, green: 62/255, blue: 1/255, alpha: 1.0)
        
        static let coralGradient = UIColor(red: 230/255, green: 97/255, blue: 51/255, alpha: 1.0)
        
        static let labelWhite = UIColor(named: "LabelWhite")
        
        static func colorGradient(for view: UIView) -> CAGradientLayer{
            let gradient = CAGradientLayer()
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.colors = [coral.cgColor, coralGradient.cgColor]
            return gradient
        }

        static func clearGrayColorWhenTapped (for cell: UITableViewCell){
            //No gray color when I touch a cell - Cancel gray color selection default
            let backgroundColorCell = UIView()
            backgroundColorCell.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundColorCell
        }
        
        static func cellsShadowSettings(_ view: UIView, _ cell: UITableViewCell){
            
            view.layer.shadowOpacity = 0.1
            view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view.layer.shadowColor = UIColor.systemGray.cgColor
            view.layer.cornerRadius = K.labelCornerRadius
            //view.frame = cell.bounds
        }
        
        static func shadowSettings(for view: UIView, in parentView: UIView){
            
            view.layer.shadowOpacity = 0.1
            view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view.layer.shadowColor = UIColor.systemGray.cgColor
            view.layer.cornerRadius = K.labelCornerRadius
            view.frame = parentView.bounds
        }
        
        static func cellsGradientColorSettings(_ view: UIView, _ cell: UITableViewCell){
            let gradientCellBackground = K.Colors.colorGradient(for: view)
            gradientCellBackground.frame = cell.bounds
            view.layer.insertSublayer(gradientCellBackground, at: 0)
        }
        
        static func gradientColorSettings(for view: UIView, in parentView: UIView){
            let gradientCellBackground = K.Colors.colorGradient(for: view)
            gradientCellBackground.frame = parentView.bounds
            view.layer.insertSublayer(gradientCellBackground, at: 0)
        }
        
        static func cellsCornerRadiusSettings(_ view: UIView){
            view.layer.cornerRadius = K.labelCornerRadius
            view.layer.masksToBounds = true
        }
    }
 
}


