//
//  Patient.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/1/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import Alamofire

class Patient {
    
    var dob: String = ""
    var surname: String = ""
    
    var forename:String = ""
    
    var middlename:String = ""
    
    var lkp_nametitle:String = ""
    
    var address:String = ""
    
    var addresspostcode:String = ""
    
    var addressphone:String = ""
    
    var gp:String = ""
    
    var gpsurgery:String = ""
    
    var medicalinsuranceprovider:String = ""
    
    var occupation:String = ""
    
    var nationality:String = ""
    var ischild:Bool = false
    var maritalstatus:String = ""
    
    var next_of_kin_contact:String = ""
    
    var next_of_kin: String = ""
    
    var addressotherphone: String = ""
    var patient_id:String = ""
    var language: String = ""
    
    var image: AnyObject?
    
    
    init?(dob: String, surname: AnyObject, forename:AnyObject, middlename:AnyObject,lkp_nametitle:AnyObject, address:AnyObject,addresspostcode:String, addressphone:String, gp:String, gpsurgery:String, medicalinsuranceprovider:String, occupation:String, nationality:String, ischild:Bool, maritalstatus:String, next_of_kin_contact:String, addressotherphone: String, patient_id:String, language:String, next_of_kin:String, image:AnyObject){
        self.dob = dob
        self.surname = surname as! String
        self.forename = forename as! String
        self.middlename = middlename as! String
        self.lkp_nametitle = lkp_nametitle as! String
        self.address = address as! String
        self.addresspostcode = addresspostcode
        self.addressphone = addressphone
        self.gp = gp
        self.gpsurgery = gpsurgery
        self.medicalinsuranceprovider = medicalinsuranceprovider
        self.occupation = occupation
        self.nationality = nationality
        self.ischild = ischild
        self.maritalstatus = maritalstatus
        self.next_of_kin = next_of_kin
        self.next_of_kin_contact = next_of_kin_contact
        self.addressotherphone = addressotherphone
        self.patient_id = patient_id
        self.language = language as String
        self.image = image
        
        
    }
    

    
    
    
}