//
//  NewCategoryListTableViewCell.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 21/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

class NewCategoryListTableViewCell: UITableViewCell {
    @IBOutlet weak var viewItemsRight: UIView!

    @IBOutlet weak var imageRight: UIImageView!
    @IBOutlet weak var labelNumberItemsRight: UILabel!

    @IBOutlet weak var viewItems: UIView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelNumberItems: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewItems.layer.cornerRadius = viewItems.frame.height / 2
        viewItemsRight.layer.cornerRadius = viewItemsRight.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
