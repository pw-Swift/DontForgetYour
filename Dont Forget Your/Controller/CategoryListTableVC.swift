//
//  CategoryListTableVC.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 31/07/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit
import CoreData

class CategoryListTableVC: UITableViewController, UINavigationControllerDelegate {

    
    var categories = [Category]()
    var selectedCellIndex: IndexPath?
    var categoryToModify: Bool = false
    var numberOfItems: String?
    var rowNumber: Int?
    
    var dataFilePath = K.dataFilePath
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var entityCount: Int{
        let request = NSFetchRequest<Category>(entityName: "Category")
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("not able to count \(error)")
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.tableFooterView = UIView()
        navigationController?.delegate = self
        
        
        if entityCount != 0{
            loadCategory()
        } else {
            loadSampleData()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(menuOfActions))
  
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
            CategoryFunc.cellsShadowSettings(cell.viewCategoryCellShadow, cell)
            
            CategoryFunc.cellsGradientColorSettings(cell.viewCategoryCell, cell)
            
            CategoryFunc.cellsCornerRadiusSettings(cell.viewCategoryCell)
            
            //Set the text of the label Category
            cell.category.text = categories[indexPath.row].title
            cell.numberOfItem.text = String(categories[indexPath.row].numberOfItem!)
            
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
        
        for i in 0..<categories.count{
            categories[Int(i)].rowNumber = Int16(i)
        }
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        } else { return proposedDestinationIndexPath}
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
            switch segue.identifier {
            case K.cellNewCategory:
                if let destination = segue.destination as? NewCategory{
                    let category = categories[selectedCellIndex!.row]
                    
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
                            destination.selectedCategory = categories[index.row]
//                            destination.dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(categories[index.row].title).plist")
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
                    let indexRowCategory = categories[cellIndex.row]
                    categories[cellIndex.row].title = sourceTextNewCategory!
                    indexRowCategory.numberOfItem = sourceNumberOfItems!
                    saveCategory()
                }

            } else {
                let modifiedCategory = Category(context: context)
                modifiedCategory.title = sourceTextNewCategory
                modifiedCategory.numberOfItem = sourceNumberOfItems
                categories.append(modifiedCategory)
                saveCategory()
            }
            //saveCategory()
        }
        else {
            return
        }
        
        tableView.reloadData()
    }
    
 
    @IBAction func buttonAdd(_ sender: Any) {
        categoryToModify = false
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
            
            self.context.delete(self.categories[indexPath.row])

            self.categories.remove(at: indexPath.row)
            
            self.saveCategory()
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
        saveCategory()
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

// MARK: - Persistent Datas - Core Data
extension CategoryListTableVC{
    func saveCategory(){
        do{
            try context.save()
        } catch {
            print("Category not saved: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let sortNumber = NSSortDescriptor(key: "rowNumber", ascending: true)
        request.sortDescriptors = [sortNumber]
        do{
            categories = try context.fetch(request)
        } catch {
            print("Unable to load categories: \(error)")
        }
    }
}

// MARK: - Load Samples
extension CategoryListTableVC{
     func loadSampleData () {
        
        let categorySample = Category(context: context)
        categorySample.title = "Delete Me"
        categorySample.numberOfItem = "Swipe Left"
        categorySample.rowNumber = 0
        categories.append(categorySample)
        
        let categorySample2 = Category(context: context)
        categorySample2.title = "Edit Me"
        categorySample2.numberOfItem = "Swipe Right"
        categorySample2.rowNumber = 1
        categories.append(categorySample2)
        
        let categorySample3 = Category(context: context)
        categorySample3.title = "New Category"
        categorySample3.numberOfItem = "Click on the add button"
        categorySample2.rowNumber = 2
        categories.append(categorySample3)
    }
}
// MARK: - Persistent Datas - Codable
//extension CategoryListTableVC{
//    func saveCategories(){
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(self.categories)
//            try data.write(to: self.dataFilePath!)
//        } catch{
//            print("Error encoding categories array \(error)")
//        }
//    }
//
//    func loadCategories() -> [Category]?{
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                categories = try decoder.decode([Category].self, from: data)
//            }catch{
//                print("Error decoding categories array \(error)")
//            }
//        }
//        return categories
//    }

//
//}
