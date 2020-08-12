//
//  ItemsTableVC.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 02/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

class ItemsTableVC: UITableViewController, UINavigationControllerDelegate {

    var items: [Item] = []
    var itemToModify: Bool = true
    var indexToModify: IndexPath?
    var dataFilePath = URL(string: "")
    var numberOfItems = 0
    var rowNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        navigationController?.delegate = self
    
        if let savedItems = loadItems(){
            items = savedItems
            if items.isEmpty{
                loadSampleData()
            }
        } else {loadSampleData()}
        
        
        
        loadSampleData()
        Item.itemsAppearance(navigationItem: navigationItem, navigationController: navigationController!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuOfActions))
        UINavigationBar.appearance().tintColor = UIColor.lightText
        
        
    }
  
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let test = viewController as? CategoryListTableVC{
            navigationController.navigationBar.tintColor = UIColor.systemBlue
            test.numberOfItems = String(numberOfItems)
            test.rowNumber = rowNumber
            if numberOfItems > 1{
                test.categories[rowNumber].numberOfItem = String("\(numberOfItems) items")
            }else{
                test.categories[rowNumber].numberOfItem = String("\(numberOfItems) item")
            }
            
            test.saveCategories()
            test.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return K.numberOfSectionsInItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return items.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else {
            return 140
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            numberOfItems = items.count
            let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCell, for: indexPath) as! ItemsTableViewCell
            
            //Category.cellsGradientColorSettings(cell.itemCellView, cell)
            
            Category.cellsShadowSettings(cell.itemViewCellShadow, cell)
            
            Category.cellsCornerRadiusSettings(cell.itemCellView)
        
            cell.itemName.text = items[indexPath.row].itemName
            cell.itemDescription.text = items[indexPath.row].itemDescription
            if items[indexPath.row].checkStatus == false{
                cell.accessoryType = .none
                cell.itemName.textColor = UIColor.label
                cell.itemDescription.textColor = UIColor.label
                cell.itemImage.image = UIImage(named: "Hanger")
            } else{
                cell.accessoryType = .checkmark
                cell.itemName.textColor = UIColor.systemGray4
                cell.itemDescription.textColor = UIColor.systemGray4
                cell.itemImage.image = UIImage(named: "HangerGray")
            }
            
            Colors.clearGrayColorWhenTapped(for: cell)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCellButton, for: indexPath) as! ItemsTableViewCell
            //cell.separatorInset = UIEdgeInsets(top: 0, left: cell.frame.width, bottom: 0, right: 0)
            Colors.clearGrayColorWhenTapped(for: cell)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return true
        } else {return false}
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(rowToMove, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section{
            return sourceIndexPath
        } else {return proposedDestinationIndexPath}
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case K.itemToDetail:
            itemToModify = true
            if let destination = segue.destination as? ItemDetailVC{
                guard let selectedItemCell = sender as? ItemsTableViewCell else{
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                guard let indexPath = tableView.indexPath(for: selectedItemCell) else{
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                indexToModify = indexPath
                
                let selectedItem = items[indexPath.row]
                
                destination.item = selectedItem
                
                destination.labelDetailText = items[indexPath.row].itemName
                
                destination.checkStatus = items[indexPath.row].checkStatus
            }
            
        case K.itemToNewDetail:
            itemToModify = false
            if let destination = segue.destination as? ItemDetailVC{
                destination.item = Item(itemName: "", itemDescription: "", checkStatus: false)
                destination.labelDetailText = "New Item"
            }
        default:
            return
        }

    }
    
    @IBAction func unwindToItemDetail(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? ItemDetailVC{
            let newItemName = sourceViewController.textName.text
            let newItemDescription = sourceViewController.textDescription.text
            let newItemCheckStatus = sourceViewController.checkStatus
            let sourceItem = sourceViewController.item
            
            if sourceViewController.buttonValidate.titleLabel?.text == "OK"{
                if itemToModify == true{
                    let row = indexToModify!.row
                    items[row] = sourceItem!
                    saveItems()
                    tableView.reloadRows(at: [indexToModify!], with: .none)
                }
                else {
                    let newItem = Item(itemName: newItemName!, itemDescription: newItemDescription!, checkStatus: newItemCheckStatus!)
                    items.append(newItem)
                    saveItems()
                    tableView.reloadData()
                }
            }
        }
    }

    @IBAction func buttonPressed(_ sender: Any) {
    }
}

// MARK: - Swipe Actions

extension ItemsTableVC {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.numberOfItems = self.items.count
            self.saveItems()
            handler(true)
        }

        action.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0{
            let checkmark = tableView.cellForRow(at: indexPath)?.accessoryType
            let cell = tableView.cellForRow(at: indexPath) as? ItemsTableViewCell
            var action = UIContextualAction()
            if checkmark == .checkmark{
                action = UIContextualAction(style: .normal, title: "Uncheck") { (action, view, handler) in
                    //tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    self.items[indexPath.row].checkStatus = false
                    cell?.accessoryType = .none
                    cell?.itemName.textColor = UIColor.label
                    cell?.itemDescription.textColor = UIColor.label
                    cell?.itemImage.image = UIImage(named: "Hanger")
                    action.backgroundColor = UIColor.systemBlue
                    self.saveItems()
                    handler(true)
                }
            } else {
                action = UIContextualAction(style: .normal, title: "Check") { (action, view, handler) in
                    //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    self.items[indexPath.row].checkStatus = true
                    cell?.accessoryType = .checkmark
                    cell?.itemName.textColor = UIColor.systemGray4
                    cell?.itemDescription.textColor = UIColor.systemGray4
                    cell?.itemImage.image = UIImage(named: "HangerGray")
                    action.backgroundColor = UIColor.systemRed
                    self.saveItems()
                    handler(true)
                }
            }
            if action.title == "Check"{
                action.backgroundColor = UIColor.systemBlue
            } else {
                action.backgroundColor = UIColor.systemRed
            }
            let configuration = UISwipeActionsConfiguration(actions: [action])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        } else {
            return nil
        }
    }
}

// MARK: - Other functions
extension ItemsTableVC{

    
    @objc func menuOfActions(){
        let action = UIAlertController()
        action.addAction(UIAlertAction(title: "New Item", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: K.itemToNewDetail, sender: self)
        }))
        
        action.addAction(UIAlertAction(title: "Uncheck all", style: .default, handler: { (action) in
            for i in 0..<self.items.count{
                if self.items[i].checkStatus == true{
                    self.items[i].checkStatus = false
                }
            }
            self.saveItems()
            self.tableView.reloadData()
        }))
        
        action.addAction(UIAlertAction(title: "Reorder rows", style: .default, handler: { (action) in
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.endReorderingRows))
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        action.pruneNegativeWidthConstraints() //remove constraint error from alert menu view
        self.present(action, animated: true, completion: nil)
        
    }
    
    @objc func endReorderingRows(){
        saveItems()
        tableView.isEditing = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuOfActions))
    }
}

// MARK: - Persistent Data
extension ItemsTableVC{
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error encoding items array \(error)")
        }
        
    }
    
    func loadItems() -> [Item]?{
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
               items = try decoder.decode([Item].self, from: data)
            } catch{
                print("Error decoding items array \(error)")
            }
        }
        return items
    }

    func loadSampleData(){
        if items.isEmpty{
            let sampleOne = Item(itemName: "Delete me", itemDescription: "Swipe Left", checkStatus: false)
            let sampleTwo = Item(itemName: "Edit me", itemDescription: "Swipe Right", checkStatus: true)
            items.append(sampleOne)
            items.append(sampleTwo)
        }
    }
}


