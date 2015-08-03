//
//  DataFetch.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/1/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import Alamofire

class PersonNewtworkCall {
    
    var patient = Patient?()
    
    func getAllPatients(patients:Patient, fromMedicalFacility medical_facility_id:Int)->Patient{
        let url = "http://www.iconglobalnetwork.com/mediband/api/get_patients"
        
        let parameters = [
            "medical_facility_id": medical_facility_id,
        ]
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        request(.GET, url, parameters: parameters, encoding: .JSON, headers: headers).responseJSON
            { request, response, json, error in
                
                if error != nil {
                    
                    var jsonObject:JSON = JSON(json!)
                    
                    let id:String = jsonObject["id"].stringValue
                    
                    let medical_facility = jsonObject["medical_facility"].int
                    
                    let surname =  jsonObject["surname"].stringValue
                    
                    let forename = jsonObject["forename"].stringValue
                    
                    let middlename = jsonObject["middlename"].stringValue
                    
                    let lkp_nametitle = jsonObject["lkp_nametitle"].stringValue
                    
                    let address = jsonObject["address"].stringValue
                    let addressphone = jsonObject["addressphone"].stringValue
                    
                    let addresspostcode = jsonObject["addresspostcode"].stringValue
                    
                    let country = jsonObject["country"].stringValue
                    
                    let addressotherphone = jsonObject["addressotherphone"].stringValue
                    
                    let gp = jsonObject["gp"].stringValue
                    
                    let gpsurgery = jsonObject["gpsurgery"].stringValue
                    
                    let medicalinsuranceprovider_id = jsonObject["medicalinsuranceprovider_id"].stringValue
                    
                    let image = jsonObject["image"].stringValue
                    
                    let dob = jsonObject["dob"].stringValue
                    
                    let occupation = jsonObject["occupation"].stringValue
                    
                    let language = jsonObject["language"].stringValue
                    
                    let nationality = jsonObject["nationality"].stringValue
                    
                    let ischild = jsonObject["ischild"].stringValue
                    
                    let maritalstatus = jsonObject["maritalstatus"].stringValue
                    
                    let next_of_kin_contact = jsonObject["next_of_kin_contact"].stringValue
                    
                    let next_of_kin = jsonObject["next_of_kin"].stringValue
                    
                    let created = jsonObject["created"].stringValue
                    let patient_id = jsonObject["patient_id"].int
                    
                    let modified = jsonObject["modified"].stringValue
                    self.patient = Patient(surname: surname, forename: forename, middlename: middlename, lkp_nametitle: lkp_nametitle, address: address, addresspostcode: addresspostcode, addressphone: addressphone, gp_id: gp, gpsurgery_id: gpsurgery, medicalinsuranceprovider: medicalinsuranceprovider_id, occupation: occupation, nationality: nationality, ischild: ischild, maritalstatus_id: maritalstatus, next_of_kin_contact: next_of_kin_contact, addressotherphone: addressotherphone, medical_facility_id: medical_facility_id, patient_id: patient_id! , image: image)
                }else {
                    
                }
                
                
        }
        
        return self.patient!
        
        
    }
    
    func createNewPatient(patient:Patient, fromMedicalFacility medical_facility_id:Int, completionHandler:(success:Bool)-> Void) {
        
        let url = "http:/iconglobalnetwork.com/mediband/api/create_patient"
        
        let parameters = [
            "medical_facility_id": medical_facility_id,
        ]
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        var success:Bool?
        
        request(.POST, url, parameters: parameters, encoding: .JSON, headers: headers).responseJSON{req, res, json, error in
            let jsonObject:JSON = JSON(json!)
            success = jsonObject["success"].bool
            
            if (success == true) {
                completionHandler(success: true)
            }else{
                completionHandler(success: false)
            }
            
        }
        
    }
    
    
}