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
    var selectedColor = "FlatFlesh"
    
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
        for item in listToCheck {
            if item.title == textNewCategory.text{
                doubleCount = false
                alertDoubleEntry()
                textNewCategory.becomeFirstResponder()
                break
            } else {
                doubleCount = true
            }
        }
        return doubleCount
    }
    

    @IBAction func buttonPressed(_ sender: Any) {
        if buttonNewCategory.titleLabel?.text == K.buttonState.buttonUnvalid{
            self.dismiss(animated: true, completion: nil)
        } else {
            return
        }
    }
    
    @IBAction func colorPicked(_ sender: UIButton) {
        let color = sender.currentTitleColor
        
        switch color {
        case UIColor(named: "FlatFlesh"):
            shadowView.backgroundColor = K.Colors.flatFlesh
            selectedColor = "FlatFlesh"
        case UIColor(named: "MelonMelody"):
            shadowView.backgroundColor = K.Colors.melonMelody
            selectedColor = "MelonMelody"
        case UIColor(named: "Livid"):
            shadowView.backgroundColor = K.Colors.livid
            selectedColor = "Livid"
        case UIColor(named: "Spray"):
            shadowView.backgroundColor = K.Colors.spray
            selectedColor = "Spray"
        case UIColor(named: "ParadiseGreen"):
            shadowView.backgroundColor = K.Colors.paradiseGreen
            selectedColor = "ParadiseGreen"
        default:
            shadowView.backgroundColor = K.Colors.flatFlesh
            selectedColor = "FlatFlesh"
        }
        

    }
    
}
// MARK: - Label, Text, Button configuration
extension NewCategory {
    func configuration() {

        K.Colors.shadowSettings(for: shadowView, in: radiusView)
        
        buttonNewCategory.backgroundColor = K.Colors.coral
        buttonNewCategory.layer.cornerRadius = 5
        buttonNewCategory.layer.masksToBounds = true
        buttonNewCategory.isHidden = true
        
        textNewCategory.becomeFirstResponder()
        textNewCategory.autocapitalizationType = .words
        textNewCategory.attributedPlaceholder = NSAttributedString(string: "Enter a title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont(name: "Helvetica Neue", size: 24) as Any])
    }
}
    
    
// MARK: - TextField Delegate
extension NewCategory: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        buttonNewCategory.isHidden = true
        buttonNewCategory.setTitle(K.buttonState.buttonEmpty, for: .normal)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            buttonNewCategory.setTitle(K.buttonState.buttonUnvalid, for: .normal)
        }
        else {
            buttonNewCategory.setTitle(K.buttonState.buttonValid, for: .normal)
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
