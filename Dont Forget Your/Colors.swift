//
//  Colors.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 01/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

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
}
