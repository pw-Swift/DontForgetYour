//
//  ItemDetailVC.swift
//  Dont Forget Your
//
//  Created by Pierre Waroquier on 02/08/2020.
//  Copyright © 2020 Pierre Waroquier. All rights reserved.
//

import UIKit

class ItemDetailVC: UIViewController {
    
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var buttonValidate: UIButton!
    @IBOutlet weak var textDescription: UITextField!
    
    var labelDetailText = "New Item"
    var checkStatus: Bool?
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelDetail.text = labelDetailText
        
        configuration()
        
        if let itemDetails = item{
            textName.text = itemDetails.itemName
            textDescription.text = itemDetails.itemDescription
            checkStatus = itemDetails.checkStatus
        }
        
        textName.delegate = self
        textDescription.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIButton, button === buttonValidate{
            let segueName = textName.text
            let segueDescription = textDescription.text
            let itemToSegue = Item(itemName: segueName!, itemDescription: segueDescription!, checkStatus: checkStatus ?? false)
            
            item = itemToSegue
        }
    }

    @IBAction func buttonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Label, Text, Button configuration
extension ItemDetailVC {
    
    func configuration() {
        
        textName.autocapitalizationType = .words
        /*textName.layer.cornerRadius = Constants.labelCornerRadius
        textName.layer.borderWidth = 1
        textName.layer.borderColor = UIColor(named: "BlackWhite")?.cgColor
        textName.layer.masksToBounds = true*/
        textName.becomeFirstResponder()
        
        textDescription.autocapitalizationType = .words
       /* textDescription.layer.cornerRadius = Constants.labelCornerRadius
        textDescription.layer.borderWidth = 1
        textDescription.layer.borderColor = UIColor(named: "BlackWhite")?.cgColor
        textDescription.layer.masksToBounds = true*/
        
        buttonValidate.isHidden = true
        buttonValidate.layer.cornerRadius = K.labelCornerRadius
        buttonValidate.layer.masksToBounds = true
        buttonValidate.backgroundColor = Colors.coral
    }

}

// MARK: - TextFied Delegate
extension ItemDetailVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        buttonValidate.isHidden = true
        buttonValidate.setTitle(K.buttonEmpty, for: .normal)
        labelDetail.text = labelDetailText
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textName.text != ""{
            buttonValidate.setTitle(K.buttonValid, for: .normal)
            labelDetail.text = textName.text
        } else {
            buttonValidate.setTitle(K.buttonUnvalid, for: .normal)
            textName.placeholder = "A name must be entered to be valid"
            labelDetail.text = labelDetailText
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        buttonValidate.isHidden = false
    }
}
