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

class AddPatientViewController: FormViewController {
    
    var tap:UIGestureRecognizer!
    weak var delegate: addPatientControllerDelegate!
    
    struct Static {
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
        static let photo = "photo"
        static let dob = "dob"
        static let occupation = "occupation"
        static let language = "language"
        static let nationality = "nationality"
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
        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "submit:")
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

        // Do any additional setup after loading the view.
    }

    func submit(_: UIBarButtonItem!) {
        
        delegate?.addPatientViewController(self, didFinishedAddingPatient: self.form.formValues())
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
//        let message = self.form.formValues().description
//        
//        let alert: UIAlertView = UIAlertView(title: "Form output", message: message, delegate: nil, cancelButtonTitle: "OK")
//        
//        alert.show()
    }
    
    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    

    private func loadForm() {
        
//        let button: UIButton!
//        button.backgroundColor =
        
        let backgroundColor:UIColor = UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1)
        
        let form = FormDescriptor()
        
        form.title = "Add Patient Form"
        
        let section1 = FormSectionDescriptor()
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.namesurname, rowType: .Name, title: "")
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
        
        let section6 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addressline2, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address2", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section6.addRow(row)
        
        let section7 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addressline3, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address3",  "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5,"textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section7.addRow(row)
        
        let section8 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addressline4, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address4", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section8.addRow(row)
        
        let section9 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addressline5, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address5", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section9.addRow(row)
        
        
        let section10 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addresspostcode, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address post code", "textField.backgroundColor":backgroundColor, "textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section10.addRow(row)
        
        let section11 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.addressphone, rowType: .Number, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address phone", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section11.addRow(row)
        
        let section12 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.lkp_addresscounty, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Address county", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section12.addRow(row)
        
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
        
        
        let section16 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.MedicalInsuranceProvider, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Medical Insurance Provider", "textField.backgroundColor":backgroundColor, "textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section16.addRow(row)
        
        let section17 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.photo, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Photo","textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5,  "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        section17.addRow(row)
        
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
        row = FormRowDescriptor(tag: Static.ischild, rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "is child", "textField.backgroundColor":backgroundColor,"textField.layer.cornerRadius": 5, "textField.textAlignment" : NSTextAlignment.Left.rawValue]
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
        form.sections = [section1,section2, section3, section4, section5, section6, section7, section8, section9, section10, section11, section12, section13, section14, section15, section16, section17, section18, section19, section20, section21, section22, section23, section24, section25]
        self.form = form
        
        
    }


}
