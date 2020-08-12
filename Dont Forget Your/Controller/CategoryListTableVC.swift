//
//  CategoryListTableVC.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 31/07/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

class CategoryListTableVC: UITableViewController, UINavigationControllerDelegate {

    
    var categories = [Category]()
    var selectedCellIndex: IndexPath?
    var categoryToModify: Bool = false
    var numberOfItems: String?
    var rowNumber: Int?
    
    var dataFilePath = K.dataFilePath

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        navigationController?.delegate = self
        
        if let savedCategory = loadCategories(){
            categories = savedCategory
            if categories.isEmpty{
                loadSampleData()
            }
        } else {loadSampleData()}
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuOfActions))
  
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return K.numberOfSectionsInCategory
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return categories.count
        }
        else {
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCell, for: indexPath) as! CategoryListTableViewCell
            
            //Configure the view containing the lables
            Category.cellsShadowSettings(cell.viewCategoryCellShadow, cell)
            
            Category.cellsGradientColorSettings(cell.viewCategoryCell, cell)
            
            Category.cellsCornerRadiusSettings(cell.viewCategoryCell)
            
            //Set the text of the label Category
            cell.category.text = categories[indexPath.row].title
            cell.numberOfItem.text = String(categories[indexPath.row].numberOfItem)
            
            //No gray color when I touch a cell - Cancel gray color selection default
            Colors.clearGrayColorWhenTapped(for: cell)
            return cell
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonAdd", for: indexPath) as! CategoryListTableViewCell
            tableView.rowHeight = 120
            return cell
        }
  
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return true
        } else { return false}
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = categories[sourceIndexPath.row]
        categories.remove(at: sourceIndexPath.row)
        categories.insert(rowToMove, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        } else { return proposedDestinationIndexPath}
    }
    
    /*override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
        }
        else {return true}
    }*/

    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
            switch segue.identifier {
            case K.cellNewCategory:
                if let destination = segue.destination as? NewCategory{
                    let categoryTitle = categories[selectedCellIndex!.row].title
                    var category = Category(title: "", numberOfItem: "")
                    if let categoryNumber = numberOfItems{
                        category = Category(title: categoryTitle, numberOfItem: categoryNumber)
                    } else{
                        category = Category(title: categoryTitle, numberOfItem: "")
                    }
                    
                    destination.categories = category
                }
            case K.categoryToNew:
                if let destination = segue.destination as? NewCategory{
                    destination.listToCheck = categories
                }
            case K.categoryToItems:
                if let destination = segue.destination as? ItemsTableVC{
                    if let selectedCell = sender as? CategoryListTableViewCell{
                        if let index = tableView.indexPath(for: selectedCell){
                            destination.navigationItem.title = categories[index.row].title
                            destination.dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(categories[index.row].title).plist")
                            destination.rowNumber = index.row
                        }
                    }
                    
                }
            default:
                return
            }
        

        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToCategoryListTableVC(_ unwindSegue: UIStoryboardSegue) {

        let sourceViewController = unwindSegue.source as? NewCategory
        let sourceButtonNewCategory = sourceViewController?.buttonNewCategory.titleLabel?.text
        let sourceTextNewCategory = sourceViewController?.textNewCategory.text
        let sourceNumberOfItems = sourceViewController?.numberOfItems
        if sourceButtonNewCategory == "OK"{
            if categoryToModify == true {
                if let cellIndex = selectedCellIndex{
                    var indexRowCategory = categories[cellIndex.row]
                    let originalPathItems = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(indexRowCategory.title).plist")
                    let newPathItems = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(sourceTextNewCategory!).plist")
                    categories[cellIndex.row].title = sourceTextNewCategory!
                    indexRowCategory.numberOfItem = sourceNumberOfItems!
                    if FileManager.default.fileExists(atPath: originalPathItems!.path){
                        do{
                            try FileManager.default.moveItem(at: originalPathItems!, to: newPathItems!)
                        }catch{
                            print("Error changing path Name: \(error)")
                        }
                    }

                    saveCategories()
                }

            } else {
                let newCategory = Category(title: sourceTextNewCategory!, numberOfItem: sourceNumberOfItems!)
                categories.append(newCategory)
                saveCategories()
            }
            tableView.reloadData()
        }
        else {
            return
        }

    }
    
 
    @IBAction func buttonAdd(_ sender: Any) {
        categoryToModify = false
        //performSegue(withIdentifier: Constants.newCategory, sender: self)
    }
}

// MARK: - Swipe Actions

extension CategoryListTableVC {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0{
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
                self.deleteAlert(tableView, indexPath)
                handler(true)
            }
            delete.image = UIImage(systemName: "trash")
            let configuration = UISwipeActionsConfiguration(actions: [delete])
            configuration.performsFirstActionWithFullSwipe = true
            
            return configuration
        }else {
            return nil
        }
       
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0{
            let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
                self.selectedCellIndex = indexPath
                self.performSegue(withIdentifier: K.cellNewCategory, sender: nil)
                handler(true)
            }
            edit.backgroundColor = .systemBlue
            edit.image = UIImage(systemName: "square.and.pencil")
            let configuration = UISwipeActionsConfiguration(actions: [edit])
            configuration.performsFirstActionWithFullSwipe = true
            categoryToModify = true
            return configuration
        } else {
            return nil
        }

    }
}

// MARK: - Other functions
extension CategoryListTableVC{
    func doubleEntryAlert(){
        let actionDoubleEntry = UIAlertController(title: "Warning", message: "The name you have entered already exists.  Please choose a new one", preferredStyle: .alert)
        actionDoubleEntry.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        self.present(actionDoubleEntry, animated: true, completion: nil)
    }

    func deleteAlert(_ tableView: UITableView, _ indexPath: IndexPath){
        let deleteAlerte = UIAlertController(title: "Warning", message: "All the items contained in the List will be deleted", preferredStyle: .alert)
        deleteAlerte.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        deleteAlerte.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(self.categories[indexPath.row].title).plist")
        
            if FileManager.default.fileExists(atPath: dataFilePath!.path){
                do{
                  
                    try FileManager.default.removeItem(at: dataFilePath!)
                    
                }catch{
                    print("Error: not able to delete items - \(error)")
                }
            }
            self.categories.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.saveCategories()
        }))
        self.present(deleteAlerte, animated: true, completion: nil)
    }
    @objc func menuOfActions(){
        let action = UIAlertController()
        action.addAction(UIAlertAction(title: "New Title", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: K.categoryToNew, sender: self)
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
        tableView.isEditing = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuOfActions))
    }
    
}


extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

// MARK: - Persistent Datas
extension CategoryListTableVC{
    func saveCategories(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.categories)
            try data.write(to: self.dataFilePath!)
        } catch{
            print("Error encoding categories array \(error)")
        }
    }
    
    func loadCategories() -> [Category]?{
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                categories = try decoder.decode([Category].self, from: data)
            }catch{
                print("Error decoding categories array \(error)")
            }
        }
        return categories
    }
    func loadSampleData () {
        if categories.isEmpty{
            let categorySampleOne = Category(title: "Delete me", numberOfItem: "Swipe Left")
            let categorySampleTwo = Category(title: "Edit me", numberOfItem: "Swipe Right")
            let categorySampleThree = Category(title: "New Title", numberOfItem: "Click on the add button")
            categories.append(categorySampleOne)
            categories.append(categorySampleTwo)
            categories.append(categorySampleThree)
        }
    }
    
}
