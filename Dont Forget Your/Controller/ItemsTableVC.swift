//
//  ItemsTableVC.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 02/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit
import CoreData

class ItemsTableVC: UITableViewController /*,UINavigationControllerDelegate*/ {

    var items: [Item] = []
    var itemToModify: Bool = true
    var indexToModify: IndexPath?
    var numberOfItems = 0
    var rowNumber = 0
    var colorName = "FlatFlesh"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category?
    
    var imageName: UIImage {
        get{
            let color = colorName
            switch color {
            case "FlatFlesh":
                return UIImage(named: K.Image.hangerFlatFlesh)!
            case "MelonMelody":
                return UIImage(named: K.Image.hangerMelonMelody)!
            case "Livid":
                return UIImage(named: "HangerLivid")!
            case "Spray":
                return UIImage(named: "HangerSpray")!
            case "ParadiseGreen":
                return UIImage(named: "HangerParadiseGreen")!
            default:
                return UIImage(named: "Hanger")!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        //navigationController?.delegate = self
        
        loadItems()
        
        //ItemFunc.itemsAppearance(navigationItem: navigationItem, navigationController: navigationController!, color: colorName)
       // navigationController?.navigationBar.backgroundColor = UIColor(named: colorName)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuOfActions))
        //UINavigationBar.appearance().tintColor = UIColor.lightText
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let navigation = viewController as? CategoryListTableVC {
            navigation.numberOfItems = String(numberOfItems)
            navigation.rowNumber = rowNumber
//            if numberOfItems > 1{
//                navigation.categories[rowNumber].numberOfItem = String("\(numberOfItems) items")
//            } else {
//                navigation.categories[rowNumber].numberOfItem = String("\(numberOfItems) item")
//            }
            
            navigation.categories[rowNumber].numberOfItem = String(numberOfItems)
            navigation.saveCategory()
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
        if indexPath.section == 0 {
            numberOfItems = items.count
            let cell = tableView.dequeueReusableCell(withIdentifier: K.segueIdentifier.itemCell, for: indexPath) as! ItemsTableViewCell
            
            K.Colors.cellsShadowSettings(cell.itemViewCellShadow, cell)
            
            K.Colors.cellsCornerRadiusSettings(cell.itemCellView)
        
            cell.itemName.text = items[indexPath.row].itemName
            cell.itemDescription.text = items[indexPath.row].itemDescription
            
            if items[indexPath.row].checkStatus == false{
                cell.accessoryType = .none
                cell.itemName.textColor = UIColor.label
                cell.itemDescription.textColor = UIColor.label
                cell.itemImage.image = imageName //UIImage(named: K.Image.hanger)
            } else {
                cell.accessoryType = .checkmark
                cell.itemName.textColor = UIColor.systemGray4
                cell.itemDescription.textColor = UIColor.systemGray4
                cell.itemImage.image = UIImage(named: K.Image.hangerGray)
            }
            K.Colors.clearGrayColorWhenTapped(for: cell)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.segueIdentifier.itemCellButton, for: indexPath) as! ItemsTableViewCell

            K.Colors.clearGrayColorWhenTapped(for: cell)
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
        case K.segueIdentifier.itemToDetail:
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
                
                destination.labelDetailText = items[indexPath.row].itemName!
                
                destination.checkStatus = items[indexPath.row].checkStatus
                
            }
            
        case K.segueIdentifier.itemToNewDetail:
            itemToModify = false
            if let destination = segue.destination as? ItemDetailVC{
                destination.checkStatus = false
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
            
            if sourceViewController.buttonValidate.titleLabel?.text == "OK" {
                if itemToModify == true{
                    let row = indexToModify!.row
                    items[row] = sourceItem!
                    saveItems(reloadData: true)
                }
                else {
                    let newItem = Item(context: context)
                    newItem.itemName = newItemName
                    newItem.itemDescription = newItemDescription
                    newItem.checkStatus = newItemCheckStatus! 
                    newItem.rowNumber = Int16(items.count)
                    newItem.parentCategory = selectedCategory
                    items.append(newItem)
                    saveItems(reloadData: true)
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
            self.context.delete(self.items[indexPath.row])
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.numberOfItems = self.items.count
            
            self.saveItems(reloadData: true)
            handler(true)
        }

        action.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            let checkmark = tableView.cellForRow(at: indexPath)?.accessoryType
            let cell = tableView.cellForRow(at: indexPath) as? ItemsTableViewCell
            var action = UIContextualAction()
            if checkmark == .checkmark {
                action = UIContextualAction(style: .normal, title: "Uncheck") { (action, view, handler) in
                    
                    self.items[indexPath.row].checkStatus = false
                    cell?.accessoryType = .none
                    cell?.itemName.textColor = UIColor.label
                    cell?.itemDescription.textColor = UIColor.label
                    cell?.itemImage.image = self.imageName// UIImage(named: "Hanger")
                    action.backgroundColor = UIColor.systemBlue
                    self.saveItems(reloadData: false)
                    handler(true)
                }
            } else {
                action = UIContextualAction(style: .normal, title: "Check") { (action, view, handler) in
                    
                    self.items[indexPath.row].checkStatus = true
                    cell?.accessoryType = .checkmark
                    cell?.itemName.textColor = UIColor.systemGray4
                    cell?.itemDescription.textColor = UIColor.systemGray4
                    cell?.itemImage.image = UIImage(named: "HangerGray")
                    action.backgroundColor = UIColor.systemRed
                    self.saveItems(reloadData: false)
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
            self.performSegue(withIdentifier: K.segueIdentifier.itemToNewDetail, sender: self)
        }))
        
        action.addAction(UIAlertAction(title: "Uncheck all", style: .default, handler: { (action) in
            for i in 0..<self.items.count{
                if self.items[i].checkStatus == true{
                    self.items[i].checkStatus = false
                }
            }
            self.saveItems(reloadData: true)
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
        saveItems(reloadData: true)
        tableView.isEditing = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuOfActions))
    }
}

// MARK: - Persistent Data - Core Data
extension ItemsTableVC{
    func saveItems(reloadData tableViewReloadData: Bool){
        
        for i in 0..<items.count{
            items[i].rowNumber = Int16(i)
        }
       
        if tableViewReloadData == true{
            do{
                try context.save()
            } catch {
                print("Item not saved: \(error)")
            }
            tableView.reloadData()
        } else {
            do{
                try context.save()
            } catch {
                print("Item not saved: \(error)")
            }
            //tableView.reloadData()
        }
    }
    
    func loadItems(){
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedCategory!.title!)
        let sortNumber = NSSortDescriptor(key: "rowNumber", ascending: true)
        request.predicate = predicate
        request.sortDescriptors = [sortNumber]
        
        do {
            let count = try context.count(for: request)
            if count != 0{
                items = try context.fetch(request)
            } else {
                loadSampleData()
            }
        } catch {
            print("Items not loaded: \(error)")
        }
    }
}

// MARK: - Load Samples
extension ItemsTableVC{
    func loadSampleData(){
        
        let itemSample = Item(context: context)
        itemSample.parentCategory = selectedCategory
        itemSample.itemName = "Delete Me"
        itemSample.itemDescription = "Swipe Left"
        itemSample.checkStatus = false
        itemSample.rowNumber = 0
        items.append(itemSample)
        
        let itemSample2 = Item(context: context)
        itemSample2.parentCategory = selectedCategory
        itemSample2.itemName = "Uncheck Me"
        itemSample2.itemDescription = "Swipe Right"
        itemSample2.checkStatus = true
        itemSample2.rowNumber = 1
        items.append(itemSample2)
    }
}



