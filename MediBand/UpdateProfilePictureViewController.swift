//
//  UpdateProfilePictureViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 9/20/15.
//  Copyright © 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner
import Haneke
import JLToast

class UpdateProfilePictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var selectPictureBtn: UIButton!
    var imagePicker = UIImagePickerController()
    var staff = Staff()
    var staffImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadBtn.backgroundColor = sharedDataSingleton.theme
//        cancelBtn.backgroundColor = sharedDataSingleton.theme
        if (sharedDataSingleton.user.image != "") {
            let URL = NSURL(string: sharedDataSingleton.user.image)!
            
            profileImage.hnk_setImageFromURL(URL)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func selectPicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func upload() {
        
        self.update()
    }
    @IBAction func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func pressed(sender: UIButton!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
        self.staffImage = image
        self.profileImage.image = image
    }
    
    func update(){
        
        let constants = Contants()
        
        let indexOfSpecialist = constants.specialist.indexOf(sharedDataSingleton.user.speciality)
//        ({$0 == sharedDataSingleton.user.speciality})
        if indexOfSpecialist == nil {
            
            staff.speciality = ""
        }else {
            let count: Int = indexOfSpecialist! + 1
            staff.speciality = String(count)
        }
        
        staff.general_practional_id = sharedDataSingleton.user.general_practitioner_id
        staff.member_id = sharedDataSingleton.user.memberid
        staff.medical_facility_id = sharedDataSingleton.user.clinic_id
        let indexOfRole = constants.role.indexOf(sharedDataSingleton.user.role)
//        ({$0 == sharedDataSingleton.user.role})
        if indexOfRole == nil {
            staff.role = ""
        }else {
//            let indexAsString 
            let count: Int = indexOfRole! + 1
            staff.role = String(count)
        }
            staff.email = sharedDataSingleton.user.email
            staff.surname = sharedDataSingleton.user.surname
            staff.firstname = sharedDataSingleton.user.firstName
        
        if !Reachability.connectedToNetwork() {
            let dictionary: Dictionary<String, Any> = ["requestType": "CreateStaff", "value": staff, "image": staffImage, "isCreatingNewStaff": false, "description":"Change profile picture"]
            sharedDataSingleton.outbox.append(dictionary)
            JLToast.makeText("Saved to Outbox").show()
            return
        }
//
        SwiftSpinner.show("Updating profile picture")
        let staffMethods = StaffNetworkCall()
        staffMethods.create(staff, image: staffImage, isCreatingNewStaff: false) { (success) -> Void in
            if success == true {
                SwiftSpinner.hide({ () -> Void in
                    let alertView = SCLAlertView()
                    alertView.showEdit(self, title: "Sucess", subTitle: "Profile picture changed", closeButtonTitle: "OK", duration: 2000)
                })
            }else {
                SwiftSpinner.hide({ () -> Void in
                    let alertView = SCLAlertView()
                    alertView.showError("Error", subTitle: "An error occurred. Please try again later", closeButtonTitle: "OK", duration: 200)
                    alertView.alertIsDismissed({ () -> Void in
                        
                    })
                })
                
            }
        }
    }
//}
}

