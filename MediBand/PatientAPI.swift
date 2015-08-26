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
    func getAllPatients(assigned_staff:String, fromMedicalFacility medical_facility:String, withPageNumber pageNumber:String, completionHandler:(success:Bool)-> Void) {
        var patientResult = [Patient]()
        let url = "http://www.iconglobalnetwork.com/mediband/api/get_patients"
        let parameters = [
            "medical_facility_id": medical_facility,
            "staff_id": assigned_staff
        ]
        
        println(parameters)
        let headers = [
            "Content-Type": "application/json"
        ]

        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.POST(url, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            println("patiens response object \(responseObject)")
            let dictionary = responseObject as! [String:AnyObject]
            patientResult = self.parseDictionary(dictionary)
            completionHandler(success: true)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completionHandler(success: false)
        }
    }
    
    func createNewPatient(patient:Patient, fromMedicalFacility medical_facility:String, image:UIImage?, completionHandler:(success:Bool)-> Void) {
        
        var imgData = UIImageJPEGRepresentation(image!, 0.6)
        let mm = NetData(data: imgData, mimeType: MimeType.ImageJpeg, filename: "patient_picture.jpg")
        var data:[String: AnyObject] = [
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
        println(data)
        let url = "http:/iconglobalnetwork.com/mediband/api/create_patient"
        let urlRequest = urlRequestWithComponents(url, parameters: data)
        
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }
            .responseJSON { (request, response, JSON, error) in
                println("REQUEST \(request)")
                println("RESPONSE \(response)")
                println("JSON \(JSON)")
                println("ERROR \(error)")
        }
    }
    
    
    
    func getPatient(patient_id:String, fromMedicalFacility medical_facility_id:String, completionHandler:(success:Bool)-> Void){
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
    
    func editPatient(patient:Patient, image: UIImage?, completionHandler:(success:Bool)-> Void) {
//        var imageData = NSData(contentsOfFile: imagePath, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)

        var imgData = UIImageJPEGRepresentation(image!, 0.5)
        let mm = NetData(jpegImage: image!, compressionQuanlity: 0.8, filename: "patientPicture")

//        let mm = NetData(data: imgData, mimeType: "image/jpg", filename: "picture.jpg")
        var data:[String: AnyObject] = [
            "patient_id": patient.patient_id,
            "surname": patient.surname,
            "forename":patient.forename,
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
            "medical_facility_id": patient.medical_facility,
            "ischild":patient.ischild,
            "maritalstatus":patient.maritalstatus,
            "next_of_kin_contact":patient.next_of_kin_contact,
            "next_of_kin":patient.next_of_kin,
            "image":mm
        ]
        let url = "http:/iconglobalnetwork.com/mediband/api/edit_patient"
        
        
        let urlRequest = urlRequestWithComponents(url, parameters: data)
        
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }
            .responseJSON { (request, response, JSON, error) in
                println("REQUEST \(request)")
                println("RESPONSE \(response)")
                println("JSON \(JSON)")
                println("ERROR \(error)")
        }
        
        
        
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        println(data)

    }
    
    private func parseDictionary(dictionary:[String: AnyObject]) -> [Patient] {
        var patients = [Patient]()
        if let array:AnyObject = dictionary["data"] {
            for resultDict in array as! [AnyObject] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    self.parseDictionaryToPatient(resultDict)
                }
            }
        }
//        sharedDataSingleton.patients = patients
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
        if let image: AnyObject = resultDict["image"]  {
            patient.image = image
        }else {
            patient.image = ""
        }
        sharedDataSingleton.patients.append(patient)
        //                    patients.append(patient)
    }
    
    func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
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
                var postData = value as! NetData
                
                
                //uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                
                // append content disposition
                var filenameClause = " filename=\"\(postData.filename)\""
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