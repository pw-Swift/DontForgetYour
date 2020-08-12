//
//  Category.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 31/07/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit


struct Category: Codable {
    var title: String
    var numberOfItem: String
    
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
        let gradientCellBackground = Colors.colorGradient(for: view)
        gradientCellBackground.frame = cell.bounds
        view.layer.insertSublayer(gradientCellBackground, at: 0)
    }
    
    static func gradientColorSettings(for view: UIView, in parentView: UIView){
        let gradientCellBackground = Colors.colorGradient(for: view)
        gradientCellBackground.frame = parentView.bounds
        view.layer.insertSublayer(gradientCellBackground, at: 0)
    }
    
    static func cellsCornerRadiusSettings(_ view: UIView){
        view.layer.cornerRadius = K.labelCornerRadius
        view.layer.masksToBounds = true
    }
}


