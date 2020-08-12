//
//  ItemsTableViewCell.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 02/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemViewCellShadow: UIView!
    @IBOutlet weak var itemCellView: UIView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
