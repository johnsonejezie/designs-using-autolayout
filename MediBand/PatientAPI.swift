//
//  DataFetch.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/1/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire

class PatientAPI {
    var patient: Patient!
    var getSinglePatient:Bool = false
    var patients = [Patient]()
    
    func getAllPatients(assigned_staff:String, fromMedicalFacility medical_facility:String, withPageNumber pageNumber:String, completionHandler:(success:Bool)-> Void) {
       
//        var patientResult = [Patient]()
        let url = sharedDataSingleton.baseURL + "get_patients"
        let parameters = [
            "medical_facility_id": sharedDataSingleton.user.clinic_id,
            "staff_id": assigned_staff,
            "page":pageNumber
        ]
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.POST(url, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            let dictionary = responseObject as! [String:AnyObject]
            self.parseDictionary(dictionary)
            completionHandler(success: true)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completionHandler(success: false)
        }
    }
    
    func createNewPatient(patient:Patient, fromMedicalFacility medical_facility:String, image:UIImage?, isCreatingNewPatient:Bool, completionHandler:(success:Bool)-> Void) {
        var url:String = ""
         getSinglePatient = true
        let parameters:[String: AnyObject] = [
            "patient_id": patient.patient_id,
            "surname": patient.surname,
            "forename":patient.forename,
            "middlename":patient.middlename,
            "lkp_nametitle":patient.lkp_nametitle,
            "address":patient.address,
            "addresspostcode":patient.addresspostcode,
            "addressphone":patient.addressphone,
            "addressotherphone":patient.addressotherphone,
            "gp":patient.gp,
            "gpsurgery":patient.gpsurgery,
            "medicalinsuranceprovider":patient.medicalinsuranceprovider,
            "dob":patient.dob,
            "occupation":patient.occupation,
            "language":patient.language,
            "nationality":patient.nationality,
            "medical_facility_id": patient.medical_facility,
            "ischild":patient.ischild,
            "maritalstatus":patient.maritalstatus,
            "next_of_kin_contact":patient.next_of_kin_contact,
            "next_of_kin":patient.next_of_kin,
            "next_of_kin_relationship": patient.next_of_kin_relationship
        ]
        
        if isCreatingNewPatient == true {
            url = sharedDataSingleton.baseURL + "create_patient"
        }else {
            url = sharedDataSingleton.baseURL + "edit_patient"
        }
        if let anImage:UIImage = image {
            let imgData = UIImageJPEGRepresentation(image!, 0.6)
            let mm = NetData(data: imgData!, mimeType: MimeType.ImageJpeg, filename: "patient_picture.jpg")
            let data:[String: AnyObject] = [
                "patient_id": patient.patient_id,
                "surname": patient.surname,
                "forename":patient.forename,
                "middlename":patient.middlename,
                "lkp_nametitle":patient.lkp_nametitle,
                "address":patient.address,
                "addresspostcode":patient.addresspostcode,
                "addressphone":patient.addressphone,
                "addressotherphone":patient.addressotherphone,
                "gp":patient.gp,
                "gpsurgery":patient.gpsurgery,
                "medicalinsuranceprovider":patient.medicalinsuranceprovider,
                "dob":patient.dob,
                "occupation":patient.occupation,
                "language":patient.language,
                "nationality":patient.nationality,
                "medical_facility_id": patient.medical_facility,
                "ischild":patient.ischild,
                "maritalstatus":patient.maritalstatus,
                "next_of_kin_contact":patient.next_of_kin_contact,
                "next_of_kin":patient.next_of_kin,
                "image": mm
            ]
            
            
            let urlRequest = urlRequestWithComponents(url, parameters: data)
            
            Alamofire.upload(urlRequest.0, data: urlRequest.1)
                .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                }.responseJSON { _, _, result in
            }.responseJSON { _, _, result in
                if (result.value != nil) {
                    if let resultDict:AnyObject = result.value {
                        if let resultError = resultDict["success"] as? Bool {
                            if resultError == false {
                                completionHandler(success: false)
                            }else {
                                if let dict:[String: AnyObject] = resultDict["data"] as? [String: AnyObject]{
                                    self.parseDictionaryToPatient(dict)
                                    completionHandler(success: true)
                                }
                            }
                        }
                       
                    }else {
                        completionHandler(success: false)
                    }
                    
                }else {
                    completionHandler(success: false)
                    
                }
            }
        }else {
            let manager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            manager.POST(url, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                if let dictionary = responseObject["data"] as? [String:AnyObject] {
                    if dictionary.count > 0 {
                        self.parseDictionaryToPatient(dictionary)
                        completionHandler(success: true)
                    }else {
                        completionHandler(success: false)
                    }
                }else {
                   completionHandler(success: false)
                }
                }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    completionHandler(success: false)
            }
        }
    }

    func getPatient(patient_id:String, fromMedicalFacility medical_facility_id:String, completionHandler:(Patient?, NSError?)-> ()){
        getSinglePatient = true;
        let url = sharedDataSingleton.baseURL + "view_patient"
        let parameters = [
            "patient_id": patient_id,
            "medical_facility_id": medical_facility_id,
        ]
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.POST(url, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            if let dictionary = responseObject["data"] as? [String:AnyObject] {
                if dictionary.count == 0 {
                    completionHandler(nil, nil)
                }else {
                    self.parseDictionaryToPatient(dictionary)
                    completionHandler(sharedDataSingleton.selectedPatient, nil)
                }
            }else {
                completionHandler(nil, nil)
            }
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completionHandler(nil, error)
        }
    }

    
    private func parseDictionary(dictionary:[String: AnyObject]) -> [Patient] {
        let patients = [Patient]()
        if let array:AnyObject = dictionary["data"] {
            for resultDict in array as! [AnyObject] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    self.parseDictionaryToPatient(resultDict)
                }
            }
            if let pageNo = dictionary["page_no"] as? String {
                sharedDataSingleton.patientsCurrentPage = Int(pageNo)!
            }
            if let totalPage = dictionary["total_page"] as? Int {
                sharedDataSingleton.patientsTotalPage = totalPage
            }
           sharedDataSingleton.patients = self.patients
        }
        return patients
    }
    
    
    func parseDictionaryToPatient(resultDict:[String: AnyObject]) {
        let patient = Patient()
        if let address: String = resultDict["address"] as? String  {
            patient.address = address
        }else {
            patient.address = ""
        }
        if let addressotherphone: String = resultDict["addressotherphone"] as? String  {
            patient.addressotherphone = addressotherphone
        }else {
            patient.addressotherphone = ""
        }
        if let addressphone: String = resultDict["addressphone"] as? String  {
            patient.addressphone = addressphone
        }else {
            patient.addressphone = ""
        }
        if let addresspostcode: String = resultDict["addresspostcode"] as? String  {
            patient.addresspostcode = addresspostcode
        }else {
            patient.addresspostcode = ""
        }
        if let dob: String = resultDict["dob"] as? String  {
            patient.dob = dob
        }else {
            patient.dob = ""
        }
        if let forename: String = resultDict["forename"] as? String  {
            patient.forename = forename
        }else {
            patient.forename = ""
        }
        if let gp: String = resultDict["gp"] as? String  {
            patient.gp = gp
        }else {
            patient.gp = ""
        }
        if let gpsurgery: String = resultDict["gpsurgery"] as? String  {
            patient.gpsurgery = gpsurgery
        }else {
            patient.gpsurgery = ""
        }
        if let medical_facility: String = resultDict["medical_facility"] as? String  {
            patient.medical_facility = medical_facility
        }else {
            patient.medical_facility = ""
        }
        if let ischild: Bool = resultDict["ischild"] as? Bool  {
            patient.ischild = ischild
        }else {
            patient.ischild = false
        }
        if let language: String = resultDict["language"] as? String  {
            patient.language = language
        }else {
            patient.language = ""
        }
        if let lkp_nametitle: String = resultDict["lkp_nametitle"] as? String  {
            patient.lkp_nametitle = lkp_nametitle
        }else {
            patient.lkp_nametitle = ""
        }
        if let maritalstatus: String = resultDict["maritalstatus"] as? String  {
            patient.maritalstatus = maritalstatus
        }else {
            patient.maritalstatus = "Single"
        }
        if let medicalinsuranceprovider: String = resultDict["medicalinsuranceprovider"] as? String  {
            patient.medicalinsuranceprovider = medicalinsuranceprovider
        }else {
            patient.medicalinsuranceprovider = ""
        }
        if let middlename: String = resultDict["middlename"] as? String  {
            patient.middlename = middlename
        }else {
            patient.middlename = ""
        }
        if let nationality: String = resultDict["nationality"] as? String  {
            patient.nationality = nationality
        }else {
            patient.nationality = ""
        }
        if let next_of_kin: String = resultDict["next_of_kin"] as? String  {
            patient.next_of_kin = next_of_kin
        }else {
            patient.next_of_kin = ""
        }
        if let next_of_kin_contact: String = resultDict["next_of_kin_contact"] as? String  {
            patient.next_of_kin_contact = next_of_kin_contact
        }else {
            patient.next_of_kin_contact = ""
        }
        if let occupation: String = resultDict["occupation"] as? String  {
            patient.occupation = occupation
        }else {
            patient.occupation = ""
        }
        if let patient_id: String = resultDict["patient_id"] as? String  {
            patient.patient_id = patient_id
        }else {
            patient.patient_id = ""
        }
        if let surname: String = resultDict["surname"] as? String  {
            patient.surname = surname
        }else {
            patient.surname = ""
        }
        
        if let next_of_kin_relationship: String = resultDict["next_of_kin_relationship"] as? String  {
            patient.next_of_kin_relationship = next_of_kin_relationship
        }else {
            patient.next_of_kin_relationship = ""
        }
        
        if let image:String = resultDict["image"]  as? String{
            patient.image = image
        }else{
            patient.image = ""
        }
        
        
        if getSinglePatient == true {
            self.patient = patient
            sharedDataSingleton.selectedPatient = self.patient
        }else {
            self.patients.append(patient)
        }
        
        //                    patients.append(patient)
    }
    
    func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        //let boundaryConstant = "myRandomBoundary12345"
        let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add parameters
        for (key, value) in parameters {
            
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            if value is NetData {
                // add image
                let postData = value as! NetData
                
                
                //uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                
                // append content disposition
                let filenameClause = " filename=\"\(postData.filename)\""
                let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
                let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentDispositionData!)
                
                
                // append content type
                //uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
                let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
                let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentTypeData!)
                uploadData.appendData(postData.data)
                
            }else{
                uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
    
    
}