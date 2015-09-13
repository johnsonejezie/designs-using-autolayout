





import XLForm
import SwiftSpinner

class NativeEventFormViewController : XLFormViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private enum Tags : String {
        
        case emptyname = "emptyname"
        case forename = "forename"
        case surname = "surname"
        case gpID = "gpID"
        case memberID = "memberID"
        case email = "email"
        case role = "role"
        case specialist = "specialist"

    }


    let constants = Contants()
    var staffImageView:UIImageView!
    var imagePicker = UIImagePickerController()
    var isUpdatingStaff = false
    var staff = Staff()
    var staffImage:UIImage?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
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
        
        
        // Surname
        row = XLFormRowDescriptor(tag: "surname", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Surname"
        row.required = true
        if sharedDataSingleton.selectedStaff != nil {
            row.value = sharedDataSingleton.selectedStaff.surname
        }
        section.addFormRow(row)
        
        // Forename
        row = XLFormRowDescriptor(tag: "forename", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Forename"
        row.required = true
        if sharedDataSingleton.selectedStaff != nil {
            row.value = sharedDataSingleton.selectedStaff.firstname
        }
        section.addFormRow(row)
        
        // Email
        row = XLFormRowDescriptor(tag: "email", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Email"
        row.required = true
        if sharedDataSingleton.selectedStaff != nil {
            row.value = sharedDataSingleton.selectedStaff.email
        }
        section.addFormRow(row)
        
        // GP
        row = XLFormRowDescriptor(tag: "gpID", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "GP"
        row.required = true
        if sharedDataSingleton.selectedStaff != nil {
            row.value = sharedDataSingleton.selectedStaff.general_practional_id
        }
        section.addFormRow(row)
        
        // staff ID
        row = XLFormRowDescriptor(tag: "memberID", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Staff ID"
        row.required = true
        if sharedDataSingleton.selectedStaff != nil {
            row.value = sharedDataSingleton.selectedStaff.member_id
        }
        section.addFormRow(row)
        
        // Role Status
        row = XLFormRowDescriptor(tag: "role", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Role")
        row.value = XLFormOptionsObject(value: 1, displayText: "Doctor")
        row.selectorTitle = "Doctor"
        row.selectorOptions = [XLFormOptionsObject(value: 1, displayText:"Doctor"),
                              XLFormOptionsObject(value: 2, displayText:"Nurse"),
                            XLFormOptionsObject(value: 3, displayText:"Allied Health Profession"),
            XLFormOptionsObject(value: 4, displayText:"Admin"),
            
        ]
        row.required = true
        if sharedDataSingleton.selectedStaff != nil {
            row.value = sharedDataSingleton.selectedStaff.role
        }
        section.addFormRow(row)
        
        // Specialist
        row = XLFormRowDescriptor(tag: "specialist", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Specialist")
        row.value = constants.specialist[0]
        row.selectorTitle = "Cardiology"
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
        if sharedDataSingleton.selectedStaff != nil {
            row.value = sharedDataSingleton.selectedStaff.speciality
        }
        section.addFormRow(row)
        
        self.form = form
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        self.tableView.backgroundColor = UIColor.whiteColor()
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        let topView:UIView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 200))
        topView.backgroundColor = UIColor.whiteColor()
        
        staffImageView = UIImageView()
        staffImageView.frame.size = CGSizeMake(120, 120)
        staffImageView.center.y = topView.center.y - 20
        staffImageView.center.x = topView.center.x
        
        staffImageView.clipsToBounds = true
        staffImageView.layer.cornerRadius = 120/2
        staffImageView.image = UIImage(named: "defaultImage")
        topView.addSubview(staffImageView)
        
        let uploadImgBtn:UIButton = UIButton()
        uploadImgBtn.frame.size = CGSizeMake(120, 30)
        uploadImgBtn.frame.origin.y = staffImageView.frame.size.height + 40
        uploadImgBtn.center.x = staffImageView.center.x
        uploadImgBtn.setTitle("UPLOAD PIC", forState: UIControlState.Normal)
        uploadImgBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        uploadImgBtn.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        uploadImgBtn.backgroundColor = UIColor(red: 0.16, green: 0.89, blue: 0.98, alpha: 1)
        uploadImgBtn.layer.cornerRadius = 5
        uploadImgBtn.clipsToBounds = true
        
        topView.addSubview(uploadImgBtn)
        self.tableView.addSubview(topView)
        
        
        if sharedDataSingleton.selectedStaff.image != "" {
            let URL = NSURL(string: staff.image)!
            staffImageView.hnk_setImageFromURL(URL)
        }else {
            staffImageView.image = UIImage(named: "defaultImage")
        }
        
    }
    
    
    
    
    
    @IBAction func submit(sender: UIBarButtonItem) {
        
        var message:String = ""
        if isUpdatingStaff == true {
            message = "Updating Staff"
        }else {
            message = "Creating Staff"
        }
        
        SwiftSpinner.show(message, animated: true)
        
        staff.medical_facility_id = sharedDataSingleton.user.clinic_id
        
        if let specialist_id = form.formRowWithTag(Tags.specialist.rawValue)!.value?.formValue() as? String {
            staff.speciality = String(specialist_id)
        }
        
        if let general_practional_id = form.formRowWithTag(Tags.gpID.rawValue)!.value as? String {
            staff.general_practional_id = general_practional_id
            
        }
        
        if let member_id = form.formRowWithTag(Tags.memberID.rawValue)!.value as? String {
            staff.member_id = member_id
        }
        
        if let role = form.formRowWithTag(Tags.role.rawValue)!.value?.formValue() as? Int {
            staff.role = String(role)
        }
        
        if let email = form.formRowWithTag(Tags.email.rawValue)!.value as? String {
            staff.email = email
        }
        if let surname = form.formRowWithTag(Tags.surname.rawValue)!.value as? String {
            staff.surname = surname
        }
        if let forename = form.formRowWithTag(Tags.forename.rawValue)!.value as? String {
            staff.firstname = forename
        }
        
        var staffMethods = StaffNetworkCall()
        staffMethods.create(staff, image: staffImage, isCreatingNewStaff: !isUpdatingStaff) { (success) -> Void in
            if success == true {
                SwiftSpinner.hide(completion: { () -> Void in
                    //                                self.delegate.addStaffViewController(self, finishedAddingStaff: self.staff)
                    let staffProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StaffProfileViewController") as! StaffProfileViewController
                    staffProfileViewController.staff = sharedDataSingleton.selectedStaff
                    self.navigationController?.pushViewController(staffProfileViewController, animated: true)
                })
            }else {
                SwiftSpinner.hide(completion: { () -> Void in
                    let alertView = SCLAlertView()
                    alertView.showError("Erro", subTitle: "An error occurred. Please try again later", closeButtonTitle: "Ok", duration: 200)
                    alertView.alertIsDismissed({ () -> Void in
                        
                    })
                })
                
            }
        }
        
        self.trackEvent("UX", action: "Create new staff", label: "Save button: create new staff", value: nil)
        
        
    }
    
    func pressed(sender: UIButton!) {
        println("upload")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("done")
        })
        self.staffImage = image
        staffImageView.image = image
    }
    

// MARK: XLFormDescriptorDelegate

    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)


    }



}

extension NativeEventFormViewController {
    
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