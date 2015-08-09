//
//  AddPatientViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/10/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftForms

protocol addPatientControllerDelegate: class {
    func addPatientViewController(controller: AddPatientViewController,
        didFinishedAddingPatient patient: NSDictionary)
}

class AddPatientViewController: FormViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ENSideMenuDelegate {
    
    var isAnyFieldEmpty:Bool!
    var patientID:String = ""
    var tap:UIGestureRecognizer!
    weak var delegate: addPatientControllerDelegate!
    var imagePicker = UIImagePickerController()
    var patientImageView:UIImageView!
    var image:UIImage?
    
    
    
    @IBAction func slideMenuToggle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }

    
    struct Static {
        static let emptyname = "emptyname"
        static let namesurname = "namesurname"
        static let nameforename = "nameforename"
        static let namemiddlename = "namemiddlename"
        static let lkp_nametitle = "lkp_nametitle"
        static let addressline1 = "addressline1"
        static let addressline2 = "addressline2"
        static let addressline3 = "addressline3"
        static let addressline4 = "addressline4"
        static let addressline5 = "addressline5"
        static let addresspostcode = "addresspostcode"
        static let addressphone = "addressphone"
        static let lkp_addresscounty = "lkp_addresscounty"
        static let addressotherphone = "addressotherphone"
        static let gp = "gp"
        static let gpsurgery = "gpsurgery"
        static let MedicalInsuranceProvider = "MedicalInsuranceProvider"
        static let dob = "dob"
        static let occupation = "occupation"
        static let language = "language"
        static let nationality = "nationality"
        static let medical_facility = "medical_facility"
        static let ischild = "ischild"
        static let maritalstatus = "maritalstatus"
        static let nextofKinContact = "nextofKinContact"
        static let nextofKin = "nextofKin"
        static let button = "button"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.sideMenuController()?.sideMenu?.delegate = self
        
        isAnyFieldEmpty = false
        
        let topView:UIView = UIView(frame: CGRectMake(0, -10, view.frame.size.width, 180))
        topView.backgroundColor = UIColor.clearColor()
        
         patientImageView = UIImageView(frame: CGRectMake((view.frame.size.width - 220)/2, 25, 100, 100))
        
        patientImageView.clipsToBounds = true
        patientImageView.layer.cornerRadius = 100/2

        
        
        patientImageView.image = UIImage(named: "HS3")
        topView.addSubview(patientImageView)
        
        let uploadImgBtn:UIButton = UIButton()
        uploadImgBtn.frame.size = CGSizeMake(120, 30)
        uploadImgBtn.center.y = patientImageView.center.y + 30
        uploadImgBtn.frame.origin.x = 160
        uploadImgBtn.setTitle("UPLOAD PIC", forState: UIControlState.Normal)
        uploadImgBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        uploadImgBtn.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        uploadImgBtn.backgroundColor = UIColor(red: 0.16, green: 0.89, blue: 0.98, alpha: 1)
        uploadImgBtn.layer.cornerRadius = 5
        uploadImgBtn.clipsToBounds = true
        
        topView.addSubview(uploadImgBtn)
        
        
        let patient_id_label:UILabel = UILabel(frame: CGRectMake(15, 150, view.frame.size.width, 20))
        patient_id_label.text = "patient ID: \(patientID)"
        
        topView.addSubview(patient_id_label)
        view.addSubview(topView)
        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "submit:")
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Add Patient View")
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
        self.image = image
        patientImageView.image = image
    }

    func submit(_: UIBarButtonItem!) {
        

        
        
        delegate?.addPatientViewController(self, didFinishedAddingPatient: self.form.formValues())
        
//        self.dismissViewControllerAnimated(true, completion: nil)
        
        let patient: Patient = handleForm()
        
        if (isAnyFieldEmpty == true) {
            println("some fields are empty")
            isAnyFieldEmpty = false
            return
        }

        let fetchModel = PersonNewtworkCall()
        
        fetchModel.createNewPatient(patient, fromMedicalFacility: 4) { (success) -> Void in
            if success == true {
                println("patient successfully created")
            }else {
                println("failed to save patient")
                let alertView = UIAlertView(title: "Error", message: "Failed to save patient.", delegate: self, cancelButtonTitle: "Cancel")
                alertView.delegate = self
                alertView.show()
            }
        }
        
        self.trackEvent("UX", action: "Create new patient", label: "Submit button for creating new patient", value: nil)

    }
    
    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    

    private func loadForm() {
        
        let backgroundColor:UIColor = UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1)
        
        let form = FormDescriptor()
        
        form.title = "Add Patient Form"
        
        
        let section27 = FormSectionDescriptor()
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.emptyname, rowType: .Name, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "", "textField.backgroundColor":UIColor.clearColor(),"textField.layer.cornerRadius": 5,  "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section27.addRow(row)
        
        let section28 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.emptyname, rowType: .Name, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "", "textField.backgroundColor":UIColor.clearColor(),"textField.layer.cornerRadius": 5,  "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section28.addRow(row)
        
        let section1 = FormSectionDescriptor()
         row = FormRowDescriptor(tag: Static.namesurname, rowType: .Name, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : " Surname", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5,  "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section1.addRow(row)
        
        let section2 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.nameforename, rowType: .Name, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : " Forename", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section2.addRow(row)
        
        let section3 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.namemiddlename, rowType: .Name, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : " Middle name", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section3.addRow(row)
        
        let section4 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.lkp_nametitle, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : " Title", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section4.addRow(row)
        
        let section5 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addressline1, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : " Address1", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section5.addRow(row)
        
//        let section6 = FormSectionDescriptor()
//        row = FormRowDescriptor(tag: Static.addressline2, rowType: .Text, title: "")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address2", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
//        section6.addRow(row)
        
//        let section7 = FormSectionDescriptor()
//        row = FormRowDescriptor(tag: Static.addressline3, rowType: .Text, title: "")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address3",  "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5,"textField.textAlignment" : NSTextAlignment.Left.rawValue]
//        section7.addRow(row)
//        
//        let section8 = FormSectionDescriptor()
//        row = FormRowDescriptor(tag: Static.addressline4, rowType: .Text, title: "")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address4", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
//        section8.addRow(row)
//        
//        let section9 = FormSectionDescriptor()
//        row = FormRowDescriptor(tag: Static.addressline5, rowType: .Text, title: "")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address5", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
//        section9.addRow(row)
        
        
        let section10 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addresspostcode, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address post code", "textField.backgroundColor":backgroundColor, "textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section10.addRow(row)
        
        let section11 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addressphone, rowType: .Number, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address phone", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section11.addRow(row)
        
//        let section12 = FormSectionDescriptor()
//        row = FormRowDescriptor(tag: Static.lkp_addresscounty, rowType: .Text, title: "")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address county", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
//        section12.addRow(row)
        
        let section13 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addressotherphone, rowType: .Number, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address other phone", "textField.backgroundColor":backgroundColor, "textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section13.addRow(row)
        
        let section14 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.gp, rowType: .Name, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "gp", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section14.addRow(row)
        
        
        let section15 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.gpsurgery, rowType: .Name, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "gp surgery", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section15.addRow(row)
        
//        let section35 = FormSectionDescriptor()
//        row = FormRowDescriptor(tag: Static.medical_facility, rowType: .Name, title: "")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Medical Facility", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
//        section35.addRow(row)
        
        
        let section16 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.MedicalInsuranceProvider, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Medical Insurance Provider", "textField.backgroundColor":backgroundColor, "textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section16.addRow(row)
    
        let section18 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.dob, rowType: .Date, title: "Date of Birth")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["datePicker.backgroundColor":backgroundColor]
        section18.addRow(row)
        
        let section19 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.occupation, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Occupation", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section19.addRow(row)
        
        let section20 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.language, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Language", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section20.addRow(row)
        
        let section21 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.nationality, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Nationality", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section21.addRow(row)
        
        let section22 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.ischild, rowType: .Picker, title: "is child")
        row.configuration[FormRowDescriptor.Configuration.Options] = [true, false]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch(value) {
                case true:
                    return "true"
                case false:
                    return "false"
            default:
                return nil
            }
        } as TitleFormatterClosure
        row.value = false
        section22.addRow(row)
        
        let section23 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.maritalstatus, rowType: .Picker, title: "Marital Status")
        row.configuration[FormRowDescriptor.Configuration.Options] = ["S", "M", "D", "W"]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch( value ) {
            case "S":
                return "Single"
            case "M":
                return "Married"
            case "D":
                return "Divorced"
            case "W":
                return "Widowed"
            default:
                return nil
            }
        } as TitleFormatterClosure
        
        row.value = "S"
        section23.addRow(row)
        
        let section24 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.nextofKinContact, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Next of kin contact", "textField.backgroundColor":backgroundColor, "textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section24.addRow(row)
        
        let section25 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.nextofKin, rowType: .Name, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Next of kin", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section25.addRow(row)
        form.sections = [section27, section28, section1,section2, section3, section4, section5, section10, section11, section13, section14, section15, section16, section18, section19, section20, section21, section22, section23, section24, section25]
        self.form = form
        
        
    }
    
    func handleForm()->Patient {
         var dateString: String?
        
        let surname: String?
        if let patientSurname = self.form.formValues()["namesurname"] as? String {
            surname = patientSurname
        }else {
            isAnyFieldEmpty = true
            surname = ""
        }
        if let dob:NSDate = self.form.formValues()["dob"] as? NSDate {
            let date = dob
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateString = dateFormatter.stringFromDate(date)
        }else {
            isAnyFieldEmpty = true
            dateString = ""
        }
        let forename:String?
        if let firstName = self.form.formValues()["nameforename"] as? String {
            forename = firstName
        }else {
            isAnyFieldEmpty = true
            forename = ""
        }
        let middlename: String?
        if let middleName = self.form.formValues()["namemiddlename"] as? String {
            middlename = middleName
        }else {
            isAnyFieldEmpty = true
            middlename = ""
        }
        let lkp_nametitle: String?
        if let nameTitle = self.form.formValues()["lkp_nametitle"] as? String {
            lkp_nametitle = nameTitle
        }else {
            isAnyFieldEmpty = true
            lkp_nametitle = ""
        }
        
        let address: String?
        if let patientAddress = self.form.formValues()["addressline1"] as? String {
            address = patientAddress
        }else {
            isAnyFieldEmpty = true
            address = ""
        }
        let addresspostcode: String?
        if let addressPostCode = self.form.formValues()["addresspostcode"] as? String {
            addresspostcode = addressPostCode
        }else {
            isAnyFieldEmpty = true
            addresspostcode = ""
        }
        
        let addressphone: String?
        if let addressPhone = self.form.formValues()["addressphone"] as? String {
            addressphone = addressPhone
        }else {
            isAnyFieldEmpty = true
            addressphone = ""
        }
        
        
        let gp: String?
        if let patientGP = self.form.formValues()["gp"] as? String {
            gp = patientGP
        }else {
            isAnyFieldEmpty = true
            gp = ""
        }
        let gpsurgery: String?
        if let gpSurgery = self.form.formValues()["gpsurgery"] as? String {
            gpsurgery = gpSurgery
        }else {
            isAnyFieldEmpty = true
            gpsurgery = ""
        }
        
        let medicalinsuranceprovider: String?
        if let medicalInsuranceProvider = self.form.formValues()["MedicalInsuranceProvider"] as? String {
            medicalinsuranceprovider = medicalInsuranceProvider
        }else {
            isAnyFieldEmpty = true
            medicalinsuranceprovider = ""
        }
        
        
        let occupation: String?
        if let patientOccupation = self.form.formValues()["occupation"] as? String {
            occupation = patientOccupation
        }else {
            isAnyFieldEmpty = true
            occupation = ""
        }
        let nationality: String?
        if let patientNationality = self.form.formValues()["nationality"] as? String {
            nationality = patientNationality
        }else {
            isAnyFieldEmpty = true
            nationality = ""
        }
        let ischild: Bool?
        if let patientIsChild = self.form.formValues()["ischild"] as? Bool {
            ischild = patientIsChild
        }else {
            isAnyFieldEmpty = true
            ischild = false
        }
        let maritalstatus: String?
        if let patientMaritalStatus = self.form.formValues()["maritalstatus"] as? String {
            maritalstatus = patientMaritalStatus
        }else {
            isAnyFieldEmpty = true
            maritalstatus = "Single"
        }
        
        let next_of_kin_contact: String?
        if let patientNextOfKinContact = self.form.formValues()["nextofKinContact"] as? String {
            next_of_kin_contact = patientNextOfKinContact
        }else {
            isAnyFieldEmpty = true
            next_of_kin_contact = ""
        }
        let addressotherphone: String?
        if let patientAddressOtherPhone = self.form.formValues()["addressotherphone"] as? String {
            addressotherphone = patientAddressOtherPhone
        }else {
            isAnyFieldEmpty = true
            addressotherphone = ""
        }
        let medical_facility_id: String? = "4"
        let patient_id: String?
//        if let id = self.form.formValues()["patient_id"] as? String {
//            patient_id = id
//        }else {
//            isAnyFieldEmpty = true
//            patient_id = ""
//        }
        
        let language: String?
        if let patientLanguage = self.form.formValues()["language"] as? String {
            language = patientLanguage
        }else {
            isAnyFieldEmpty = true
            language = ""
        }
        let next_of_kin: String?
        if let patientNextOfKin = self.form.formValues()["nextofKin"] as? String {
            next_of_kin = patientNextOfKin
        }else {
            isAnyFieldEmpty = true
            next_of_kin = ""
        }
        let imgString:String?
        if let imgData = UIImagePNGRepresentation(image) {
            imgString = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        }else {
            imgString = ""
        }
        
        
        var newPatient = Patient(dob: dateString!, surname: surname!, forename: forename!, middlename: middlename!, lkp_nametitle: lkp_nametitle!, address: address!, addresspostcode: addresspostcode!, addressphone: addressphone!, gp: gp!, gpsurgery: gpsurgery!, medicalinsuranceprovider: medicalinsuranceprovider!, occupation: occupation!, nationality: nationality!, ischild: ischild!, maritalstatus: maritalstatus!, next_of_kin_contact: next_of_kin_contact!, addressotherphone: addressotherphone!, medical_facility_id: medical_facility_id!, patient_id:patientID, language:language!, next_of_kin:next_of_kin!, image:imgString!)

        return newPatient!

    }


}

extension AddPatientViewController {
    
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


