//
//  ItemFunc.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 02/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//


import UIKit
struct ItemFunc: Codable {

    static func itemsAppearance(navigationItem: UINavigationItem, navigationController: UINavigationController){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.init(named: "CoralGradient")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.standardAppearance = appearance
        navigationController.navigationBar.tintColor = UIColor.lightText
    }
}
