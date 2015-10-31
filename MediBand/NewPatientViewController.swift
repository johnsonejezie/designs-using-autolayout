//
//  NewPatientViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 9/12/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import XLForm
import SwiftSpinner
import Haneke
import JLToast
protocol addPatientControllerDelegate: class {
    func addPatientViewController(controller: NewPatientViewController,
        didFinishedAddingPatient patient: NSDictionary)
}
class NewPatientViewController: XLFormViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private enum Tags : String {
        
        case emptyname = "emptyname"
        case anotherEmptyname = "anotherEmptyname"
        case surname = "surname"
        case forename = "forename"
        case middleName = "middleName"
        case title = "title"
        case address = "address"
        case addressPostCode = "addressPostCode"
        case addressPhone = "addressPhone"
        case addressOtherPhone = "addressOtherPhone"
        case gp = "gp"
        case gpsurgery = "gpsurgery"
        case medicalInsuranceProvider = "medicalInsuranceProvider"
        case dateOfBirth = "dateOfBirth"
        case occupation = "occupation"
        case language = "language"
        case nationality = "nationality"
        case ischild = "ischild"
        case maritalStatus = "maritalStatus"
        case nextOfKinContact = "nextOfKinContact"
        case nextOfKin = "nextOfKin"
        case nextOfkinRelationship = "nextOfKinRelationship"
        case patientID = "patientID"
    }
    
    var isEditingPatient:Bool = false
    
    //    var selectedPatient: Patient?
    
    var isAnyFieldEmpty:Bool!
    var patientID:String = ""
    var tap:UIGestureRecognizer!
    weak var delegate: addPatientControllerDelegate!
    var imagePicker = UIImagePickerController()
    var patientImageView:UIImageView!
    var patientImage:UIImage?
    
  
    @IBOutlet var navBar: UIBarButtonItem!

    required init?(coder aDecoder: NSCoder) {
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
        
        //Patient ID
        row = XLFormRowDescriptor(tag: "patientID", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "patient ID"
        row.required = false
        row.disabled = true
        row.value = sharedDataSingleton.patientID
        section.addFormRow(row)
        
        // Surname
        row = XLFormRowDescriptor(tag: "surname", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Surname"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.surname
        }
        section.addFormRow(row)
        
        // Forename
        row = XLFormRowDescriptor(tag: "forename", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Forename"
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.forename
        }
        section.addFormRow(row)
        
        // Middle Name
        row = XLFormRowDescriptor(tag: "middleName", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Middle name"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.middlename
        }
        section.addFormRow(row)
        
        
        // Title
        row = XLFormRowDescriptor(tag: "title", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Title")
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.lkp_nametitle
        }else {
            row.value = XLFormOptionsObject(value: 0, displayText: "Mr")
        }
        row.selectorTitle = "Title"
        row.selectorOptions = [XLFormOptionsObject(value: 0, displayText:"Mr"),
            XLFormOptionsObject(value: 1, displayText:"Mrs"),
            XLFormOptionsObject(value: 2, displayText:"Miss"),
            XLFormOptionsObject(value: 3, displayText:"Master"),
            
        ]
        section.addFormRow(row)
        
        
        
        // Address
        row = XLFormRowDescriptor(tag: "address", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Address"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.address
        }
        section.addFormRow(row)
        
        // Address post code
        row = XLFormRowDescriptor(tag: "addressPostCode", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Address post code"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.addresspostcode
        }
        section.addFormRow(row)
        
        // Address phone
        row = XLFormRowDescriptor(tag: "addressPhone", rowType: XLFormRowDescriptorTypePhone)
        row.cellConfigAtConfigure["textField.placeholder"] = "Address phone"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.addressphone
        }
        section.addFormRow(row)
        
        // Address other phone
        row = XLFormRowDescriptor(tag: "addressOtherPhone", rowType: XLFormRowDescriptorTypePhone)
        row.cellConfigAtConfigure["textField.placeholder"] = "Address other phone"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.addressotherphone
        }
        section.addFormRow(row)
        
        // GP
        row = XLFormRowDescriptor(tag: "gp", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "GP"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.gp
        }
        section.addFormRow(row)
        
        // GPSurgery
        row = XLFormRowDescriptor(tag: "gpsurgery", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "GPSurgery"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.gpsurgery
        }
        section.addFormRow(row)
        
        // Medical Insurance Provider
        row = XLFormRowDescriptor(tag: "medicalInsuranceProvider", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Medical Insurance Provider"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.medicalinsuranceprovider
        }
        section.addFormRow(row)
        
        // Occupation
        row = XLFormRowDescriptor(tag: "occupation", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Occupation"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.occupation
        }
        section.addFormRow(row)
        
        // Language
        row = XLFormRowDescriptor(tag: "language", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Language"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.language
        }
        section.addFormRow(row)
        
        // Nationality
        row = XLFormRowDescriptor(tag: "nationality", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Nationality"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.nationality
        }
        section.addFormRow(row)
        
        // Next of kin
        row = XLFormRowDescriptor(tag: "nextOfKin", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Next of kin"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.next_of_kin
        }
        section.addFormRow(row)
        
        // Next of kin relationship
        row = XLFormRowDescriptor(tag: "nextOfKinRelationship", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Next of kin relationship"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.next_of_kin_relationship
        }
        section.addFormRow(row)
        
        // Next of kin contact
        row = XLFormRowDescriptor(tag: "nextOfKinContact", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Next of kin contact"
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.next_of_kin_contact
        }
        section.addFormRow(row)
        
        // Under 18
        row = XLFormRowDescriptor(tag: "ischild", rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Under 18")
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.ischild
        }else {
            row.value = false
        }
        section.addFormRow(row)
        
        //Date of Birth
        row = XLFormRowDescriptor(tag: "dateOfBirth", rowType: XLFormRowDescriptorTypeDateInline, title: "Date of Birth")
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            let dateString = sharedDataSingleton.selectedPatient.dob
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let date = dateFormatter.dateFromString(dateString)
            print(dateString)
            print(date)
            row.value = date
        }else {
          row.value = NSDate()
        }
        section.addFormRow(row)
        
        // Marital Status
        row = XLFormRowDescriptor(tag: "maritalStatus", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Marital Status")
        row.required = true
        if sharedDataSingleton.selectedPatient != nil {
            row.value = sharedDataSingleton.selectedPatient.maritalstatus
        }else {
           row.value = XLFormOptionsObject(value: 0, displayText: "Single")
        }
        row.selectorTitle = "Marital Status"
        row.selectorOptions = [XLFormOptionsObject(value: 0, displayText:"Single"),
            XLFormOptionsObject(value: 1, displayText:"Married"),
            XLFormOptionsObject(value: 2, displayText:"Civil Partner"),
            XLFormOptionsObject(value: 3, displayText:"Divorced"),
            XLFormOptionsObject(value: 4, displayText:"Widowed"),
            
        ]
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
        if self.revealViewController() != nil {
            navBar.target = self.revealViewController()
            navBar.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        print("patient id \(patientID)")
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        let topView:UIView = UIView(frame: CGRectMake(0, 45, view.frame.size.width, 160))
        topView.backgroundColor = UIColor.whiteColor()
        
        patientImageView = UIImageView(frame: CGRectMake((view.frame.size.width - 220)/2, 25, 100, 100))
        
        patientImageView.clipsToBounds = true
        patientImageView.layer.cornerRadius = 100/2
        patientImageView.image = UIImage(named: "defaultImage")
        if sharedDataSingleton.selectedPatient != nil {
            if sharedDataSingleton.selectedPatient.image != "" {
                let URL = NSURL(string: sharedDataSingleton.selectedPatient.image)!
                
                patientImageView.hnk_setImageFromURL(URL)
            }
        }
        
        topView.addSubview(patientImageView)
        
        let uploadImgBtn:UIButton = UIButton()
        uploadImgBtn.frame.size = CGSizeMake(120, 30)
        uploadImgBtn.center.y = patientImageView.center.y + 30
        uploadImgBtn.frame.origin.x = 180
        uploadImgBtn.setTitle("UPLOAD PIC", forState: UIControlState.Normal)
        uploadImgBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        uploadImgBtn.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        uploadImgBtn.backgroundColor = UIColor(red: 0.16, green: 0.89, blue: 0.98, alpha: 1)
        uploadImgBtn.layer.cornerRadius = 5
        uploadImgBtn.clipsToBounds = true
        uploadImgBtn.backgroundColor = sharedDataSingleton.theme
        
        topView.addSubview(uploadImgBtn)
        self.tableView.addSubview(topView)
        
    }
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        sharedDataSingleton.selectedPatient = nil
    }
    
    func pressed(sender: UIButton!) {
        print("upload")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            print("done")
        })
        self.patientImage = image
        patientImageView.image = image
    }
    
    @IBAction func submit(sender: UIBarButtonItem) {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first)
            return
        }else {
            let patient: Patient = handleForm()
            var message :String = ""
            var outboxMessage:String = ""
            if isEditingPatient == true {
                message = "Updating patient record"
                outboxMessage = "Update patient with ID \(patientID)"
            }else {
                message = "Creating patient record"
                outboxMessage = "Create patient with ID \(patientID)"
            }
            
            if !Reachability.connectedToNetwork() {
                let dictionary: Dictionary<String, Any> = ["requestType": "CreateNewPatient", "value": patient, "fromMedicalFacility": sharedDataSingleton.user.clinic_id, "image": patientImage, "isCreatingNewPatient": !isEditingPatient, "description":outboxMessage]
                sharedDataSingleton.outbox.append(dictionary)
                JLToast.makeText("Saved to Outbox").show()
                
                return
            }
            
            SwiftSpinner.show(message, animated: true)
            let patientAPI = PatientAPI()
            patientAPI.createNewPatient(patient, fromMedicalFacility: sharedDataSingleton.user.clinic_id, image: self.patientImage, isCreatingNewPatient: !isEditingPatient) { (success) -> Void in
                if success == true {
                    SwiftSpinner.hide({ () -> Void in
                        let patientProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PatientProfileViewController") as! PatientProfileViewController
                        patientProfileViewController.patient = sharedDataSingleton.selectedPatient
                        self.navigationController?.pushViewController(patientProfileViewController, animated: true)
                    })
                }else {
                    SwiftSpinner.hide({ () -> Void in
                        let alertView = SCLAlertView()
                        alertView.showError("Erro", subTitle: "An error occurred. Please try again later", closeButtonTitle: "Ok", duration: 200)
                        alertView.alertIsDismissed({ () -> Void in
                            
                        })
                    })
                }
            }
            
            self.trackEvent("UX", action: "Create new patient", label: "Submit button for creating new patient", value: nil)
        }
        self.tableView.endEditing(true)
    }
    
    
    
    func handleForm()->Patient {
        var dateString: String?
        
        
        var results = [String:String]()
        if let fullName = form.formRowWithTag(Tags.surname.rawValue)!.value as? String {
            results["name"] = fullName
        }
        print(results)
        
        let surname: String?
        if let patientSurname = form.formRowWithTag(Tags.surname.rawValue)!.value as? String {
            surname = patientSurname
        }else {
            isAnyFieldEmpty = true
            surname = ""
        }
        if let dob:NSDate = form.formRowWithTag(Tags.dateOfBirth.rawValue)!.value as? NSDate {
            print(dob)
            let date = dob
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateString = dateFormatter.stringFromDate(date)
//            dateString = dob
        }else {
            isAnyFieldEmpty = true
            dateString = ""
        }
        let forename:String?
        if let firstName = form.formRowWithTag(Tags.forename.rawValue)!.value as? String {
            forename = firstName
        }else {
            isAnyFieldEmpty = true
            forename = ""
        }
        let middlename: String?
        if let middleName = form.formRowWithTag(Tags.middleName.rawValue)!.value as? String {
            middlename = middleName
        }else {
            isAnyFieldEmpty = true
            middlename = ""
        }
//        form.formRowWithTag(Tags.maritalStatus.rawValue)!.value as? String
        let lkp_nametitle: String?
        if let nameTitle = form.formRowWithTag(Tags.title.rawValue)!.value?.formDisplayText() {
            lkp_nametitle = nameTitle
        }else {
            isAnyFieldEmpty = true
            lkp_nametitle = "Mr"
        }
        
        let address: String?
        if let patientAddress = form.formRowWithTag(Tags.address.rawValue)!.value as? String {
            address = patientAddress
        }else {
            isAnyFieldEmpty = true
            address = ""
        }
        let addresspostcode: String?
        if let addressPostCode = form.formRowWithTag(Tags.addressPostCode.rawValue)!.value as? String {
            addresspostcode = addressPostCode
        }else {
            isAnyFieldEmpty = true
            addresspostcode = ""
        }
        let addressphone: String?
        if let addressPhone = form.formRowWithTag(Tags.addressPhone.rawValue)!.value as? String {
            addressphone = addressPhone
        }else {
            isAnyFieldEmpty = true
            addressphone = ""
        }
        
        let gp: String?
        if let patientGP = form.formRowWithTag(Tags.gp.rawValue)!.value as? String {
            gp = patientGP
        }else {
            isAnyFieldEmpty = true
            gp = ""
        }
        let gpsurgery: String?
        if let gpSurgery = form.formRowWithTag(Tags.gpsurgery.rawValue)!.value as? String {
            gpsurgery = gpSurgery
        }else {
            isAnyFieldEmpty = true
            gpsurgery = ""
        }
        
        let medicalinsuranceprovider: String?
        if let medicalInsuranceProvider = form.formRowWithTag(Tags.medicalInsuranceProvider.rawValue)!.value as? String {
            medicalinsuranceprovider = medicalInsuranceProvider
        }else {
            isAnyFieldEmpty = true
            medicalinsuranceprovider = ""
        }
        let occupation: String?
        if let patientOccupation = form.formRowWithTag(Tags.occupation.rawValue)!.value as? String {
            occupation = patientOccupation
        }else {
            isAnyFieldEmpty = true
            occupation = ""
        }
        let nationality: String?
        if let patientNationality = form.formRowWithTag(Tags.nationality.rawValue)!.value as? String {
            nationality = patientNationality
        }else {
            isAnyFieldEmpty = true
            nationality = ""
        }
        let ischild: Bool?
        if let patientIsChild = form.formRowWithTag(Tags.ischild.rawValue)!.value as? Bool {
            ischild = patientIsChild
        }else {
            isAnyFieldEmpty = true
            ischild = false
        }
        let maritalstatus: String?
        if let patientMaritalStatus = form.formRowWithTag(Tags.maritalStatus.rawValue)!.value?.formDisplayText() {
            maritalstatus = patientMaritalStatus
        }else {
            isAnyFieldEmpty = true
            maritalstatus = "Single"
        }
        
        let next_of_kin_contact: String?
        if let patientNextOfKinContact = form.formRowWithTag(Tags.nextOfKinContact.rawValue)!.value as? String {
            next_of_kin_contact = patientNextOfKinContact
        }else {
            isAnyFieldEmpty = true
            next_of_kin_contact = ""
        }
        let addressotherphone: String?
        if let patientAddressOtherPhone = form.formRowWithTag(Tags.addressOtherPhone.rawValue)!.value as? String {
            addressotherphone = patientAddressOtherPhone
        }else {
            isAnyFieldEmpty = true
            addressotherphone = ""
        }
        let medical_facility: String? = "4"
        
        
        let language: String?
        if let patientLanguage = form.formRowWithTag(Tags.language.rawValue)!.value as? String {
            language = patientLanguage
        }else {
            isAnyFieldEmpty = true
            language = ""
        }
        let next_of_kin: String?
        if let patientNextOfKin = form.formRowWithTag(Tags.nextOfKin.rawValue)!.value as? String {
            next_of_kin = patientNextOfKin
        }else {
            isAnyFieldEmpty = true
            next_of_kin = ""
        }
        
        let next_of_kin_relationship: String?
        if let patientNextOfKinRelationship = form.formRowWithTag(Tags.nextOfkinRelationship.rawValue)!.value as? String {
            next_of_kin_relationship = patientNextOfKinRelationship
        }else {
            isAnyFieldEmpty = true
            next_of_kin_relationship = ""
        }
        
        let newPatient = Patient()
        newPatient.dob = dateString!
        newPatient.surname = surname!
        newPatient.forename = forename!
        newPatient.middlename = middlename!
        newPatient.lkp_nametitle = lkp_nametitle!
        newPatient.address = address!
        newPatient.addresspostcode = addresspostcode!
        newPatient.addressphone = addressphone!
        newPatient.gp = gp!
        newPatient.gpsurgery = gpsurgery!
        newPatient.medical_facility = medical_facility!
        newPatient.medicalinsuranceprovider = medicalinsuranceprovider!
        newPatient.occupation = occupation!
        newPatient.nationality = nationality!
        newPatient.ischild = ischild!
        newPatient.maritalstatus = maritalstatus!
        newPatient.next_of_kin_contact = next_of_kin_contact!
        newPatient.addressotherphone = addressotherphone!
        newPatient.patient_id = patientID
        newPatient.language = language!
        newPatient.next_of_kin = next_of_kin!
        newPatient.next_of_kin_relationship = next_of_kin_relationship!
        
        return newPatient
        
    }
    
    
    
    
    // MARK: XLFormDescriptorDelegate
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if formRow.tag == "starts" {
            let startDateDescriptor = self.form.formRowWithTag("starts")!
            let dateStartCell: XLFormDateCell = startDateDescriptor.cellForFormController(self) as! XLFormDateCell
        }
    }


}

extension NewPatientViewController {
    
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
class NativeEventNavigationViewController : UINavigationController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.tintColor = UIColor.redColor()
    }
    
}
