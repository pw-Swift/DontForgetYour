//
//  NewCategory.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 01/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

class NewCategory: UIViewController {
   
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var textNewCategory: UITextField!
    @IBOutlet weak var buttonNewCategory: UIButton!
    @IBOutlet weak var imageFace: UIImageView!
    
    var categories: Category?
    var doubleCount = false
    var listToCheck = [Category]()
    var numberOfItems: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        
        if let category = categories {
            textNewCategory.text = category.title
            numberOfItems = category.numberOfItem
        }
        else {
            textNewCategory.text = ""
            numberOfItems = "0 item"
        }
        
        textNewCategory.delegate = self
    }

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        for item in listToCheck{
            if item.title == textNewCategory.text{
                doubleCount = true
                break
            } else{
                doubleCount = false
            }
        }
        if doubleCount == true{
            alertDoubleEntry()
            textNewCategory.becomeFirstResponder()
            return false}
        else {
            return true
        }
    }
    

    @IBAction func buttonPressed(_ sender: Any) {
        if buttonNewCategory.titleLabel?.text == K.buttonUnvalid{
            self.dismiss(animated: true, completion: nil)
        } else {
            return //saveNewCategory()
        }
    }
}
// MARK: - Label, Text, Button configuration
extension NewCategory {
    func configuration() {

        CategoryFunc.shadowSettings(for: shadowView, in: radiusView)
        //Category.gradientColorSettings(for: shadowView, in: radiusView)
        //Category.cellsCornerRadiusSettings(radiusView)
 
        buttonNewCategory.backgroundColor = Colors.coral
        buttonNewCategory.layer.cornerRadius = 5
        buttonNewCategory.layer.masksToBounds = true
        buttonNewCategory.isHidden = true
        
        /*textNewCategory.layer.cornerRadius = Constants.labelCornerRadius
        textNewCategory.layer.borderColor = UIColor(named: "BlackWhite")?.cgColor
        textNewCategory.layer.borderWidth = 1
        textNewCategory.layer.masksToBounds = true*/
        textNewCategory.becomeFirstResponder()
        textNewCategory.autocapitalizationType = .words
        textNewCategory.attributedPlaceholder = NSAttributedString(string: "Enter a title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont(name: "Helvetica Neue", size: 24) as Any])
    }
}
    
    
// MARK: - TextField Delegate
extension NewCategory: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        buttonNewCategory.isHidden = true
        buttonNewCategory.setTitle(K.buttonEmpty, for: .normal)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            buttonNewCategory.setTitle(K.buttonUnvalid, for: .normal)
        }
        else {
            buttonNewCategory.setTitle(K.buttonValid, for: .normal)
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        buttonNewCategory.isHidden = false
    }
}

// MARK: - Alerts management
extension NewCategory{
    func alertDoubleEntry(){
        let alert = UIAlertController(title: "Warning", message: "This entry already exists", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Persistent Data - Core Data
extension NewCategory{
    func saveNewCategory(){
        
        let newCategory = Category(context: context)
        newCategory.title = textNewCategory.text
        newCategory.numberOfItem = ""
        do{
            try context.save()
        } catch {
            print("New category not saved: \(error)")
        }
    }
}
