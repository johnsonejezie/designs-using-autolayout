//
//  NewTaskViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 9/13/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import XLForm
import SwiftSpinner
import JLToast



class NewTaskViewController: XLFormViewController {
    var patientImageView:UIImageView!
    
    
    private enum Tags : String {
        
        case emptyname = "emptyname"
        case specialist = "specialist"
        case careActivity = "careActivity"
        case careType = "careType"
        case resolution = "resolution"
        case selectedStaff = "selectedStaff"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
         UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
        getStaff()
        
        self.tableView.contentInset = UIEdgeInsetsMake(75, 0, 0, 0)
        self.tableView.backgroundColor = UIColor.whiteColor()
        view.backgroundColor = UIColor.whiteColor()
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        let topView:UIView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 250))
        topView.backgroundColor = UIColor.whiteColor()
        
        patientImageView = UIImageView()
        
        patientImageView.frame.size = CGSizeMake(140, 140)
        patientImageView.center.y = topView.center.y - 10
        patientImageView.center.x = topView.center.x
        patientImageView.clipsToBounds = true
        patientImageView.layer.cornerRadius = 140/2
        patientImageView.image = UIImage(named: "defaultImage")
        if sharedDataSingleton.selectedPatient != nil {
            if sharedDataSingleton.selectedPatient.image != "" {
                let URL = NSURL(string: sharedDataSingleton.selectedPatient.image)!
                patientImageView.hnk_setImageFromURL(URL)
            }
        }
        
        topView.addSubview(patientImageView)
        
        let label:UILabel = UILabel()
        label.frame.size = CGSizeMake(topView.frame.size.width, 21)
        label.frame.origin.y = patientImageView.frame.height + 60
        label.center.x = patientImageView.center.x
        label.textAlignment = NSTextAlignment.Center
        label.text = sharedDataSingleton.selectedPatient.forename + " " + sharedDataSingleton.selectedPatient.surname
        
        topView.addSubview(label)
        
        self.tableView.addSubview(topView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setScreeName("Create Task View")
        if let specialist = form.formRowWithTag(Tags.specialist.rawValue)!.value?.formDisplayText() {
            sharedDataSingleton.specialistFilterString = specialist
        }
        print(sharedDataSingleton.specialistFilterString)
    }
    
    @IBAction func submit(sender: UIBarButtonItem) {
        
        let task = Task()
        
        self.trackEvent("UX", action: "New Task created", label: "Save button to create new task", value: nil)
        
        var results = [String:AnyObject]()
        if let care_activity_id = form.formRowWithTag(Tags.careActivity.rawValue)!.value?.formValue() as? Int {
            task.care_activity_id = String(care_activity_id)
            results["care_activity_id"] = care_activity_id
        }
        
        if let care_activity_type_id = form.formRowWithTag(Tags.careType.rawValue)!.value?.formValue() as? Int {
            task.care_activity_type_id = String(care_activity_type_id)
        }
        
        if let resolution_id = form.formRowWithTag(Tags.resolution.rawValue)!.value?.formValue() as? Int {
            task.resolution = String(resolution_id)
            results["resolution_id"] = resolution_id
        }
        if let specialist_id = form.formRowWithTag(Tags.specialist.rawValue)!.value?.formValue() as? Int {
            task.specialist_id = String(specialist_id)
        }
        
        if let staff_ids = form.formRowWithTag(Tags.selectedStaff.rawValue)!.value as? [String] {
            
            print(staff_ids)
            
               task.selected_staff_ids = staff_ids
            
            
        }else {
            let alertView = UIAlertView(title: "Form Error", message: "Select a staff for this task", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
            return
        }
        task.patient_id = sharedDataSingleton.selectedPatient.patient_id
        
        print(form.formRowWithTag(Tags.selectedStaff.rawValue)!.value)
        
        if !Reachability.connectedToNetwork() {
            let dictionary: Dictionary<String, Any> = ["requestType": "CreateTask", "description":"Create task for patient with ID \(task.patient_id)", "value": task]
            sharedDataSingleton.outbox.append(dictionary)
            JLToast.makeText("Saved to Outbox").show()
            return
        }
        SwiftSpinner.show("Creating Task", animated: true)
        let taskAPI = TaskAPI()
        taskAPI.createTask(task, callback: { (createdtask:AnyObject?, error:NSError?) -> () in
            if error != nil {

            }else {
                if let newtask = createdtask as? Task {
                    SwiftSpinner.hide(nil)
                    sharedDataSingleton.selectedIDs = []
                    self.performSegueWithIdentifier("UnwindToPatientProfile", sender: nil)
                    print("this is newtask \(newtask.resolution)")
                }
                
            }
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    
    func getStaff(){
        let staffMethods = StaffNetworkCall()
        
        if sharedDataSingleton.allStaffs.count == 0 {
            staffMethods.getStaffs(sharedDataSingleton.user.clinic_id, inPageNumber: "1", completionBlock: { (done) -> Void in
                if(done){
                    print("all staffs fetched and passed from staff table view controller")
                }else{
                    print("error fetching and passing all staffs from staff table view controller")
                }
            })
        }
    }
    
    @IBAction func saveActionButton() {
        
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        
        form = XLFormDescriptor(title: "Patient Form")
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        
        // Empty
        row = XLFormRowDescriptor(tag: "empty", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = ""
        row.required = false
        section.addFormRow(row)
        
        // Empty
        row = XLFormRowDescriptor(tag: "empty", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = ""
        row.required = false
        section.addFormRow(row)
        
        // Empty
        row = XLFormRowDescriptor(tag: "empty", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = ""
        row.required = false
        section.addFormRow(row)
        
        // Empty
        row = XLFormRowDescriptor(tag: "empty", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = ""
        row.required = false
        section.addFormRow(row)
        
        // Empty
        row = XLFormRowDescriptor(tag: "empty", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = ""
        row.required = false
        section.addFormRow(row)
        
        // Empty
        row = XLFormRowDescriptor(tag: "details", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Select Task Details"
        row.required = false
        row.disabled = true
        section.addFormRow(row)
        
        // Specialist
        row = XLFormRowDescriptor(tag: "specialist", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Specialty")
        row.value = XLFormOptionsObject(value: 1, displayText: "Anaesthetics")
        row.selectorTitle = "Anaesthetics"
        row.selectorOptions = [XLFormOptionsObject(value: 1, displayText:"Anaesthetics"),
            XLFormOptionsObject(value: 2, displayText:"Cardiology"),
            XLFormOptionsObject(value: 3, displayText:"Clinical Haematology"),
            XLFormOptionsObject(value: 4, displayText:"Clinical Immunology and Allergy"),
            XLFormOptionsObject(value: 5, displayText:"Clinical Oncology"),
            XLFormOptionsObject(value: 6, displayText:"Dermatology"),
            XLFormOptionsObject(value: 7, displayText:"Emergency"),
            XLFormOptionsObject(value: 8, displayText:"ENT"),
            XLFormOptionsObject(value: 9, displayText:"Gastroenterology"),
            XLFormOptionsObject(value: 10, displayText:"General Medicine"),
            XLFormOptionsObject(value: 11, displayText:"General Surgery"),
            XLFormOptionsObject(value: 12, displayText:"Geriatric Medicine"),
            XLFormOptionsObject(value: 13, displayText:"Gynaecology"),
            XLFormOptionsObject(value: 14, displayText:"Medical Oncology"),
            XLFormOptionsObject(value: 15, displayText:"Nephrology"),
            XLFormOptionsObject(value: 16, displayText:"Neurology"),
            XLFormOptionsObject(value: 17, displayText:"Ophthalmology"),
            XLFormOptionsObject(value: 18, displayText:"Oral & Maxillo Facial Surgery"),
            XLFormOptionsObject(value: 19, displayText:"Oral Surgery"),
            XLFormOptionsObject(value: 20, displayText:"Paediatrics"),
            XLFormOptionsObject(value: 21, displayText:"Radiology"),
            XLFormOptionsObject(value: 22, displayText:"Rehabilitation"),
            XLFormOptionsObject(value: 23, displayText:"Respiratory Medicine"),
            XLFormOptionsObject(value: 24, displayText:"Rheumatology"),
            XLFormOptionsObject(value: 25, displayText:"Trauma & Orthopaedics"),
            XLFormOptionsObject(value: 26, displayText:"Urology")
        ]
        row.required = true
        section.addFormRow(row)
        
        // Care Activity
        row = XLFormRowDescriptor(tag: "careActivity", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Care Activity")
        row.value = XLFormOptionsObject(value: 1, displayText: "Admin Event")
        row.selectorTitle = "Admin Event"
        row.selectorOptions = [XLFormOptionsObject(value: 1, displayText:"Admin Event"),
            XLFormOptionsObject(value: 2, displayText:"OP Attendance"),
            XLFormOptionsObject(value: 3, displayText:"IP Attendance Activity"),
            XLFormOptionsObject(value: 4, displayText:"Received Referral Activity"),
            XLFormOptionsObject(value: 5, displayText:"A&E Activity")
        ]
        row.required = true
        section.addFormRow(row)
        
        // Care Type
        row = XLFormRowDescriptor(tag: "careType", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Type of Care Activity")
        row.value = XLFormOptionsObject(value: 1, displayText: "Admin Event")
        print(row.value?.formValue())
        row.selectorTitle = "Admin Event"
        row.selectorOptions = [XLFormOptionsObject(value: 1, displayText:"Admin EventT"),
            XLFormOptionsObject(value: 2, displayText:"Administration Error"),
            XLFormOptionsObject(value: 3, displayText:"Transfer of Care"),
            XLFormOptionsObject(value: 4, displayText:"Outpatient - Follow Up"),
            XLFormOptionsObject(value: 5, displayText:"Outpatient Clinic"),
            XLFormOptionsObject(value: 6, displayText:"Inpatient"),
            XLFormOptionsObject(value: 7, displayText:"Emergency Care Activity"),
            
        ]
        row.required = true
        section.addFormRow(row)
        
        // Resolution
        row = XLFormRowDescriptor(tag: "resolution", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Resolution")
        row.value = XLFormOptionsObject(value: 1, displayText: "Closed")
        row.selectorTitle = "Closed"
        row.selectorOptions = [XLFormOptionsObject(value: 1, displayText:"Closed"),
            XLFormOptionsObject(value: 2, displayText:"Referral Transfer"),
            XLFormOptionsObject(value: 3, displayText:"Outpatient Clinic"),
            XLFormOptionsObject(value: 4, displayText:"Admin Event"),
            XLFormOptionsObject(value: 5, displayText:"Inpatient Did Not Attend"),
            XLFormOptionsObject(value: 6, displayText:"Outpatient Did Not Attend"),
            XLFormOptionsObject(value: 7, displayText:"Inpatient Discharge"),
            XLFormOptionsObject(value: 8, displayText:"End of OP Attendance"),
            XLFormOptionsObject(value: 9, displayText:"Admitted As Inpatient")
        ]
        row.required = true
        section.addFormRow(row)
        
        // Select Staff
        row = XLFormRowDescriptor(tag: "selectedStaff", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Select Staff")
        row.action.viewControllerClass = UsersTableViewController.self
        row.required = true
        section.addFormRow(row)
        
        self.form = form
    }
    
    
}

extension NewTaskViewController {
    
    func setScreeName(name: String) {
        self.title = name
        self.sendScreenView(name)
    }
    
    func sendScreenView(screenName: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.title)
        let build = GAIDictionaryBuilder.createScreenView().set(screenName, forKey: kGAIScreenName).build() as NSDictionary
        
        tracker.send(build as [NSObject: AnyObject])
    }
    
    func trackEvent(category: String, action: String, label: String, value: NSNumber?) {
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build()
        tracker.send(trackDictionary as [NSObject: AnyObject])
    }
    
}

extension UINavigationController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if visibleViewController is NewTaskViewController {
            return UIInterfaceOrientationMask.Portrait
        }
        return UIInterfaceOrientationMask.All
    }
}

