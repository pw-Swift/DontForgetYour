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
        static let hangerFlatFlesh = "HangerFlatFlesh"
        static let hangerMelonMelody = "HangerMelonMelody"
        static let hangerLivid = "HangerLivid"
        static let hangerSpray = "HangerSpray"
        static let hangerParadiseGreen = "HangerParadiseGreen"
        
    }
    
    struct buttonState{
        static let buttonValid = "OK"
        static let buttonUnvalid = "Cancel"
        static let buttonEmpty = ""
    }
    
    struct Colors {
        static let coral = UIColor(red: 231/255, green: 62/255, blue: 1/255, alpha: 1.0)

        static let coralGradient = UIColor(red: 230/255, green: 97/255, blue: 51/255, alpha: 1.0)
        static let flatFlesh = UIColor(red: 250/255, green: 211/255, blue: 144/255, alpha: 1.0)
        static let melonMelody = UIColor(red: 248/255, green: 194/255, blue: 145/255, alpha: 1.0)
        static let livid = UIColor(red: 106/255, green: 137/255, blue: 204/255, alpha: 1.0)
        static let spray = UIColor(red: 103/255, green: 204/255, blue: 221/255, alpha: 1.0)
        static let paradiseGreen = UIColor(red: 184/255, green: 233/255, blue: 148/255, alpha: 1.0)
        
        static let colorArray = [flatFlesh, melonMelody, livid, spray, paradiseGreen]
        
        //Others colors for next steps - Beta version
        static let carrotOrange = UIColor(red: 229/255, green: 142/255, blue: 38/255, alpha: 1.0)
        static let jalapenoRed = UIColor(red: 183/255, green: 21/255, blue: 64/255, alpha: 1.0)
        static let darkSapphire = UIColor(red: 12/255, green: 36/255, blue: 97/255, alpha: 0.5)
        static let forestBlues = UIColor(red: 10/255, green: 61/255, blue: 98/255, alpha: 1.0)
        static let reefEncounter = UIColor(red: 7/255, green: 153/255, blue: 146/255, alpha: 1.0)
        
        static let colorArrayDark = [carrotOrange, jalapenoRed, darkSapphire, forestBlues, reefEncounter]
        //#####################################
        
        
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


