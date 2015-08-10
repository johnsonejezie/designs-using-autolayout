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
    func getAllPatients(assigned_staff:String, fromMedicalFacility medical_facility:String)->[Patient]{
        var patientResult = [Patient]()
        let url = "http://www.iconglobalnetwork.com/mediband/api/get_patients"
        let parameters = [
            "medical_facility_id": medical_facility,
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
            let dictionary = responseObject as! [String:AnyObject]
            patientResult = self.parseDictionary(dictionary)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
        return patientResult
    }
    
    func createNewPatient(patient:Patient, fromMedicalFacility medical_facility:String, completionHandler:(success:Bool)-> Void) {
        var data:[String: AnyObject] = [
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
        let url = "http:/iconglobalnetwork.com/mediband/api/create_patient"
        let parameters = [
            "medical_facility_id": medical_facility,
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
    
    func getPatient(patient_id:Int, fromMedicalFacility medical_facility_id:String, completionHandler:(success:Bool)-> Void){
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
    
    private func parseDictionary(dictionary:[String: AnyObject]) -> [Patient] {
        var patients = [Patient]()
        if let array:AnyObject = dictionary["data"] {
            for resultDict in array as! [AnyObject] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    let patient = Patient?()
                    patient?.address = (resultDict["address"] as? String)!
                    patient?.addressotherphone = resultDict["addressotherphone"] as! String
                    patient?.addressphone = resultDict["addressphone"] as! String
                    patient?.addresspostcode = resultDict["addresspostcode"] as! String
                    patient?.dob = resultDict["dob"] as! String
                    patient?.forename = resultDict["forename"] as! String
                    patient?.gp = resultDict["gp"] as! String
                    patient?.gpsurgery = resultDict["gpsurgery"] as! String
                    patient?.ischild = resultDict["ischild"] as! Bool
                    patient?.language = resultDict["language"] as! String
                    patient?.lkp_nametitle = resultDict["lkp_nametitle"] as! String
                    patient?.maritalstatus = resultDict["maritalstatus"] as! String
                    patient?.medicalinsuranceprovider = resultDict["medicalinsuranceprovider"] as! String
                    patient?.middlename = resultDict["middlename"] as! String
                    patient?.nationality = resultDict["nationality"] as! String
                    patient?.next_of_kin = resultDict["next_of_kin"] as! String
                    patient?.next_of_kin_contact = resultDict["next_of_kin_contact"] as! String
                    patient?.occupation = resultDict["occupation"] as! String
                    patient?.patient_id = resultDict["patient_id"] as! String
                    patient?.surname = resultDict["surname"] as! String
                    if let image: AnyObject = resultDict["image"]  {
                         patient?.image = image
                    }
                    if let result = patient {
                        patients.append(result)
                    }
                }
            }
        }
        return patients
    }
}