//
//  DataFetch.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/1/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AFNetworking

class PersonNewtworkCall {
    
    var patient = Patient?()
    
    func getAllPatients(assigned_staff:String, fromMedicalFacility medical_facility_id:Int)->Patient{
        let url = "http://www.iconglobalnetwork.com/mediband/api/get_patients"
        
        let parameters = [
            "medical_facility_id": medical_facility_id,
            "assigned_staff": assigned_staff
        ]
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.GET(url, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            println(responseObject)
            
            var jsonObject:JSON = JSON(responseObject!)
            
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
            
            let gp_id = jsonObject["gp"].int
            
            let gpsurgery_id = jsonObject["gpsurgery"].int
            
            let medicalinsuranceprovider_id = jsonObject["medicalinsuranceprovider_id"].int
            
            let image: AnyObject = jsonObject["image"].object
            
            let dob = jsonObject["dob"].stringValue
            
            let occupation = jsonObject["occupation"].stringValue
            
            let language = jsonObject["language"].stringValue
            
            let nationality = jsonObject["nationality"].stringValue
            
            let ischild = jsonObject["ischild"].bool
            
            let maritalstatus = jsonObject["maritalstatus"].int
            
            let next_of_kin_contact = jsonObject["next_of_kin_contact"].stringValue
            
            let next_of_kin = jsonObject["next_of_kin"].stringValue
            
            let created = jsonObject["created"].stringValue
            let patient_clinic_id = jsonObject["patient_id"].int
            
            let modified = jsonObject["modified"].stringValue
            
//            self.patient = Patient(dob: dob,surname: surname, forename: forename, middlename: middlename, lkp_nametitle: lkp_nametitle, address: address, addresspostcode: addresspostcode, addressphone: addressphone, gp_id: gp_id!, gpsurgery_id: gpsurgery_id!, medicalinsuranceprovider: medicalinsuranceprovider_id!, occupation: occupation, nationality: nationality, ischild: ischild!, maritalstatus_id: maritalstatus_id!, next_of_kin_contact: next_of_kin_contact, addressotherphone: addressotherphone, medical_facility_id: medical_facility_id, patient_id: patient_id! , image: image as! NSData)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
        return self.patient!
        
    }
    
    func createNewPatient(patient:Patient, fromMedicalFacility medical_facility_id:Int, completionHandler:(success:Bool)-> Void) {
        
        var data:[String: AnyObject] = [
            "medical_facility_id": patient.medical_facility_id,
            "patient_id": patient.patient_id,
            "surname": patient.surname,
            "forename":patient.surname,
            "middlename":patient.middlename,
            "lkp_nametitle":patient.lkp_nametitle,
            "address":patient.address,
            "addresspostcode":patient.addresspostcode,
            "addressphone":patient.addressphone,
            "addressotherphone":patient.addressotherphone,
            "gpsurgery":patient.gpsurgery,
            "medicalinsuranceprovider":patient.medicalinsuranceprovider,
            "dob":patient.dob,
            "occupation":patient.occupation,
            "language":patient.language,
            "nationality":patient.nationality,
            "ischild":patient.ischild,
            "maritalstatus":patient.maritalstatus,
            "next_of_kin_contact":patient.next_of_kin_contact,
            "next_of_kin":patient.next_of_kin,
            "image":patient.image!
        ]
        println(data)
        
        let url = "http:/iconglobalnetwork.com/mediband/api/create_patient"
        
        let parameters = [
            "medical_facility_id": medical_facility_id,
        ]
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        var success:Bool?
        let manager = AFHTTPRequestOperationManager()
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.POST(url, parameters: data, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            println("JSON: \(responseObject)")
        }) { (req, error) -> Void in
            println("error in creating patient\(error.description)")
        }

        
    }
    
    func getPatient(patient_id:Int, fromMedicalFacility medical_facility_id:Int, completionHandler:(success:Bool)-> Void){
        let url = "http://www.iconglobalnetwork.com/mediband/api/view_patient"
        let parameters = [
            "patient_id": patient_id,
            "medical_facility_id": medical_facility_id,
        ]
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.POST(url, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            println("JSON: \(responseObject)")
            completionHandler(success: true)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error in getting single patient\(error.description)")
            completionHandler(success: true)
        }
        println(parameters)
    }
    
    func editPatient(patient:Patient, completionHandler:(success:Bool)-> Void) {
        
        let url = "http:/iconglobalnetwork.com/mediband/api/edit_patient"
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.POST(url, parameters: nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            println("JSON: \(responseObject)")
            }) { (req, error) -> Void in
                println("error in creating patient\(error.description)")
        }
        
        
    }
        
    
    
}