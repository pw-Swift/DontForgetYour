//
//  ItemFunc.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 02/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//


import UIKit
struct ItemFunc: Codable {

    static func itemsAppearance(navigationItem: UINavigationItem, navigationController: UINavigationController, color: String){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(named: color) //K.Colors.coralGradient
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont(name: "Snell Roundhand", size: 17)!]//[.foregroundColor: UIColor.lightText]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont(name: "Snell Roundhand", size: 34)!]//[.foregroundColor: UIColor.lightText]
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.standardAppearance = appearance
        navigationController.navigationBar.tintColor = UIColor.label//UIColor.lightText
    }
}
