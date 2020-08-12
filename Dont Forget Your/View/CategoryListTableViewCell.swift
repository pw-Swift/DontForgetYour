//
//  CategoryListTableViewCell.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 31/07/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {

   
    @IBOutlet weak var viewCategoryCellShadow: UIView!
    
    @IBOutlet weak var viewCategoryCell: UIView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var numberOfItem: UILabel!
    @IBOutlet weak var buttonAdd: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
