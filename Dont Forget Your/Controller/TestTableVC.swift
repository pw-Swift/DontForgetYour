//
//  TestTableVC.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 21/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

class TestTableVC: UITableViewController {

    let testArray = [["23", "Portugal"],["104", "Montagne"], ["32", "Ski"], ["11", "School"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewCategoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! NewCategoryListTableViewCell
        
        
        let random = K.Colors.colorArray.randomElement()
        
        cell.viewItems.backgroundColor = random
        cell.labelNumberItems.text = testArray[indexPath.row][0]
        cell.labelCategory.text = testArray[indexPath.row][1]
//        cell.viewItemsRight.backgroundColor = random
        cell.labelNumberItemsRight.text = "3"
        cell.imageRight.tintColor = random
        cell.layer.shadowColor = random?.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 2
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
      


        
//        cell.checkmark.tintColor = random
//        cell.itemChecked.text = "3"
//        let int1 = Int(testArray[indexPath.row][0])
//        cell.itemsLeft.text = String(int1! - 3)
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
