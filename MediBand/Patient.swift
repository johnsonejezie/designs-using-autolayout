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
    
    
    var surname: String
    
    var forename:String
    
    var middlename:String
    
    var lkp_nametitle:String
    
    var address:String
    
    var addresspostcode:String
    
    var addressphone:String
    
    var gp_id:String
    
    var gpsurgery_id:String
    
    var medicalinsuranceprovider:String
    
    var occupation:String
    
    var nationality:String
    var ischild:String
    var maritalstatus_id:String
    
    var next_of_kin_contact:String
    
    var addressotherphone: String
    
    var medical_facility_id: Int
    
    var patient_id:Int
    
    var image: String
    
    
    init?(surname: String, forename:String, middlename:String,lkp_nametitle:String, address:String,addresspostcode:String, addressphone:String, gp_id:String, gpsurgery_id:String, medicalinsuranceprovider:String, occupation:String, nationality:String, ischild:String, maritalstatus_id:String, next_of_kin_contact:String, addressotherphone: String, medical_facility_id: Int, patient_id:Int, image: String){
        self.surname = surname
        self.forename = forename
        self.middlename = middlename
        self.lkp_nametitle = lkp_nametitle
        self.address = address
        self.addresspostcode = addresspostcode
        self.addressphone = addressphone
        self.gp_id = gp_id
        self.gpsurgery_id = gpsurgery_id
        self.medicalinsuranceprovider = medicalinsuranceprovider
        self.occupation = occupation
        self.nationality = nationality
        self.ischild = ischild
        self.maritalstatus_id = maritalstatus_id
        self.next_of_kin_contact = next_of_kin_contact
        self.addressotherphone = addressotherphone
        self.medical_facility_id = medical_facility_id
        self.patient_id = patient_id
        self.image = image
        
        
    }
    

    
    
    
}