//
//  StaffAPI.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/24/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class StaffAPI: NSObject,NSURLConnectionDataDelegate {
    
    
    enum Path {
        case CREATE_STAFF
        case EDIT_STAFF
        case GET_ALL_STAFF
        case GET_SINGLE_STAFF
    }
    
    typealias APICallback = ((AnyObject?, NSError?) -> ())
    let responseData = NSMutableData()
    var statusCode:Int = -1
    var callback: APICallback! = nil
    var path: Path! = nil
    var result = [Staff]()
    var staff = Staff()
    
    
    func getAllStaff(medical_facility_id:String, inPageNumber pageNumber:String, callback: APICallback) {
        let url = "http://www.iconglobalnetwork.com/mediband/api/get_staff"
        let body = "medical_facility_id=\(medical_facility_id)&&page=\(pageNumber)"
        makeHTTPPostRequest(Path.GET_ALL_STAFF, callback: callback, url: url, body: body)
    }
    
    func getStaff(email:String, callback: APICallback) {
        let url = "http://iconglobalnetwork.com/mediband/api/view_staff"
        let body = "email=\(email)"
        makeHTTPPostRequest(Path.GET_SINGLE_STAFF, callback: callback, url: url, body: body)
    }
    
    func editStaff(staff: Staff, callback: APICallback) {
        let url = "http://iconglobalnetwork.com/mediband/api/edit_staff"
        let body = "surname=\(staff.surname)&firstname=\(staff.firstname)&speciality_id=\(staff.speciality)&medical_facility_id=\(staff.medical_facility_id)&general_practitioner_id=\(staff.general_practional_id)&email=\(staff.email)&member_id=\(staff.member_id)&role_id=\(staff.role)"
        makeHTTPPostRequest(Path.EDIT_STAFF, callback: callback, url: url, body: body)
    }
    
    func createStaff(staff: Staff, image:UIImage?, callback: APICallback) {
            let mm = NetData(jpegImage: image!, compressionQuanlity: 0.3, filename: "staffPicture")
        let url = "http://iconglobalnetwork.com/mediband/api/create_staff"
        let body = "surname=\(staff.surname)&firstname=\(staff.firstname)&speciality_id=\(staff.speciality)&medical_facility_id=\(staff.medical_facility_id)&general_practitioner_id=\(staff.general_practional_id)&email=\(staff.email)&member_id=\(staff.member_id)&role_id=\(staff.role)&image=\(mm)"
        println(body)
        makeHTTPPostRequest(Path.CREATE_STAFF, callback: callback, url: url, body: body)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        let httpResponse = response as! NSHTTPURLResponse
        statusCode = httpResponse.statusCode
        switch (httpResponse.statusCode) {
        case 201, 200, 401:
            self.responseData.length = 0
        default:
            println("ignore")
        }
    }
    
    
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.responseData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        var error: NSError?
        var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(self.responseData, options: NSJSONReadingOptions.MutableLeaves, error: &error)
        if (error != nil) {
            callback(nil, error)
            return
        }
        switch(statusCode, self.path!) {
        case (200, Path.GET_ALL_STAFF):
            callback(self.handleGetAllStaff(json), nil)
        case (200, Path.GET_SINGLE_STAFF):
            self.callback(self.handleGetSingleStaff(json), nil)
        case (200, Path.CREATE_STAFF):
            callback(self.handleCreateStaff(json), nil)
        case (200, Path.EDIT_STAFF):
            callback(self.handleEditStaff(json), nil)
        default:
            // Unknown Error
            callback(nil, nil)
        }
    }
    
    
    func handleGetAllStaff(json: AnyObject)-> [Staff]? {
        println("this is staff json \(json)")
        if let array:AnyObject = json["data"] {
            for resultDict in array as! [AnyObject] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    self.parseDict(resultDict)
                }
            }
            return result
        }
        
        return nil
    }
    
    func handleGetSingleStaff(json: AnyObject)-> Staff? {
        println("this is staff json \(json)")
        if let resultDict = json["data"] as? [String: AnyObject] {
            self.parseDict(resultDict)
            return staff
        }
        
        return nil
    }
    
    func handleCreateStaff(json: AnyObject)-> Staff? {
        println("this is staff json \(json)")
        if let resultDict = json["data"] as? [String: AnyObject] {
            self.parseDict(resultDict)
            return staff
        }
        return nil
    }
    
    func handleEditStaff(json: AnyObject)-> Staff? {
        println("this is staff json \(json)")
        if let resultDict = json["data"] as? [String: AnyObject] {
            self.parseDict(resultDict)
            return staff
        }
        return nil
    }
    
    func makeHTTPPostRequest(path: Path, callback: APICallback, url: NSString, body: NSString) {
        self.path = path
        self.callback = callback
        let request = NSMutableURLRequest(URL: NSURL(string: url as String)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let conn = NSURLConnection(request: request, delegate:self)
        if (conn == nil) {
            callback(nil, nil)
        }
    }
    
    
    func parseDict(dict:[String:AnyObject]) {
        var staffData = Staff()
        staffData.id = dict["id"] as! String
        if let general_practional_id:String = dict["general_practional_id"]  as? String{
            staffData.general_practional_id = general_practional_id;
        }else{
            staffData.general_practional_id = "N/A"
        }
        
        if let speciality:String = dict["speciality"]  as? String{
            staffData.speciality = speciality;
        }else{
            staffData.speciality = "N/A"
        }
        
        if let member_id:String = dict["member_id"]  as? String{
            staffData.member_id = member_id;
        }else{
            staffData.member_id = "N/A"
        }
        if let role:String = dict["role"]  as? String{
            staffData.role = role;
        }else{
            staffData.role = "N/A"
        }
        staffData.firstname = dict["firstname"] as! String
        staffData.surname = dict["surname"] as! String
        if let image:String = dict["image"]  as? String{
            staffData.image = image;
        }else{
            staffData.image = ""
        }
        staffData.email = dict["email"] as! String
        
        print(staffData)
        
        switch(self.path!) {
        case (Path.GET_ALL_STAFF):
            sharedDataSingleton.allStaffs.append(staffData)
            result.append(staffData)
        case (Path.GET_SINGLE_STAFF):
            self.staff = staffData
        case (Path.CREATE_STAFF):
            self.staff = staffData
        case (Path.EDIT_STAFF):
            self.staff = staffData
        default:
            // Unknown Error
            println("error")
        }
        
        
        
    }

    
    
}
