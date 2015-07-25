//
//  AddStaffViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/7/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class AddStaffViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var tap:UITapGestureRecognizer!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var staffImageView: UIImageView!
    
    @IBOutlet weak var editPicButton: UIButton!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var specialityTextField: UITextField!

    @IBOutlet weak var GeneralPractitionerIDLabel: UILabel!

    @IBOutlet weak var GeneralPracticeIDLabel: UILabel!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBAction func editButtonAction(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            println("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }

    @IBAction func saveButtonAction(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        staffImageView.layer.masksToBounds = false
        staffImageView.layer.cornerRadius = staffImageView.frame.size.width / 2
        staffImageView.clipsToBounds = true
        
        
        
                
        firstNameTextField.layer.cornerRadius = 5
        GeneralPracticeIDLabel.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1);
        GeneralPractitionerIDLabel.clipsToBounds = true
        GeneralPracticeIDLabel.clipsToBounds = true
         GeneralPractitionerIDLabel.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1);
        
        
        GeneralPractitionerIDLabel.layer.cornerRadius = 5
        
        GeneralPracticeIDLabel.layer.cornerRadius = 5
        
        GeneralPracticeIDLabel.textColor = UIColor(red: 0.73, green: 0.73, blue: 0.76, alpha: 1)
        GeneralPractitionerIDLabel.textColor = UIColor(red: 0.73, green: 0.73, blue: 0.76, alpha: 1)


        
        lastNameTextField.layer.cornerRadius = 5
        specialityTextField.layer.cornerRadius = 5
        
        firstNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        lastNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        specialityTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)

        
        saveButton.layer.cornerRadius = 4

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("done")
        })
        staffImageView.image = image
    }


    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    

}





