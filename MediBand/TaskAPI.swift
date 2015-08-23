//
//  TaskNetworkCall.swift
//  MediBand
//
//  Created by Kehinde Shittu on 8/4/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//
import Foundation
import UIKit
import AFNetworking
import Alamofire

typealias JSONDictionary = Dictionary<String, AnyObject>
typealias JSONArray = Array<AnyObject>

class TaskAPI: NSObject,NSURLConnectionDataDelegate {
    
    enum Path {
        case CREATE_TASK
        case GET_TASK_BY_STAFF
        case GET_TASK_BY_PATIENT
    }
    
    typealias APICallback = ((AnyObject?, NSError?) -> ())
    let responseData = NSMutableData()
    var statusCode:Int = -1
    var callback: APICallback! = nil
    var path: Path! = nil
    var patientTasks = [Task]()
    var staffTasks = [Task]()
    var isPatientTask:Bool = false
    var isCreatingTask:Bool = false
    var task = Task()
    
    
    func getTaskByStaff(staff_id: String, page:String, callback: APICallback) {
        let url = "http://www.iconglobalnetwork.com/mediband/api/get_task_by_staff_id"
        let body = "staff_id=\(staff_id)&page=\(page)"
        makeHTTPPostRequest(Path.GET_TASK_BY_STAFF, callback: callback, url: url, body: body)
    }
    
    func getTaskByPatient(patient_id: String, page:String, callback: APICallback) {
        isPatientTask = true
        if sharedDataSingleton.isCheckingNewPatientID == true {
            sharedDataSingleton.isCheckingNewPatientID = false
            patientTasks = []
        }
        let url = "http://www.iconglobalnetwork.com/mediband/api/get_task_by_patient_id"
        let body = "patient_id=\(patient_id)&page=\(page)"
        makeHTTPPostRequest(Path.GET_TASK_BY_PATIENT, callback: callback, url: url, body: body)
//        isPatientTask = false
    }
    
    func createTask(task: Task, callback: APICallback) {
        isCreatingTask = true
        let url = "http://www.iconglobalnetwork.com/mediband/api/create_task"
        let body = "patient_id=\(task.patient_id)&care_activity_id=\(task.care_activity_id)&specialist_id=\(task.specialist_id)&care_activity_type_id=\(task.care_activity_type_id)&care_activity_category_id=1&selected_staff_ids=\(task.selected_staff_ids)&medical_facility_id=\(sharedDataSingleton.user.medical_facility)&resolution=\(task.resolution)"
        makeHTTPPostRequest(Path.CREATE_TASK, callback: callback, url: url, body: body)
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
        case (200, Path.GET_TASK_BY_STAFF):
            callback(self.handleGetTaskByStaff(json), nil)
        case (200, Path.GET_TASK_BY_PATIENT):
            self.callback(self.handleGetTaskByPatient(json), nil)
        case (200, Path.CREATE_TASK):
            callback(self.handleCreateTask(json), nil)
        default:
            // Unknown Error
            callback(nil, nil)
        }
    }
    
    
    func handleGetTaskByStaff(json: AnyObject)-> [Task]? {
        println("this is staff json \(json)")
        if let array:AnyObject = json["data"] {
            for resultDict in array as! [AnyObject] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    self.parseDictionaryToTask(resultDict)
                }
            }
            return staffTasks
        }

        return nil
    }
    
    func handleGetTaskByPatient(json: AnyObject)-> [Task]? {
        println("this is staff json \(json)")
        if let array:AnyObject = json["data"] {
            for resultDict in array as! [AnyObject] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    self.parseDictionaryToTask(resultDict)
                }
            }
            isPatientTask = false
            return patientTasks
        }
        return nil
    }
    
    func handleCreateTask(json: AnyObject)-> Task? {
        println("this is staff json \(json)")
        if let resultDict = json["data"] as? [String: AnyObject] {
            self.parseDictionaryToTask(resultDict)
            return self.task
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
    
    func parseDictionaryToTask(resultDict:[String: AnyObject]) {
            let task = Task()
            if let care_activity_category_id: String = resultDict["care_activity_category_id"] as? String {
                task.care_activity_category_id = care_activity_category_id as String
            }else {
                task.care_activity_category_id = ""
            }
            if let care_activity_id: String = resultDict["care_activity_id"] as? String {
                task.care_activity_id = care_activity_id as String
            }else {
                task.care_activity_id = ""
            }
            if let care_activity_type_id: String = resultDict["care_activity_type_id"] as? String {
                task.care_activity_type_id = care_activity_type_id as String
            }else {
                task.care_activity_type_id = ""
            }
            if let created: String = resultDict["created"] as? String {
                task.created = created as String
            }else {
                task.created = ""
            }
            if let id: String = resultDict["id"] as? String {
                task.id = id as String
            }else {
                task.id = ""
            }
            if let modified: String = resultDict["modified"] as? String {
                task.modified = modified as String
            }else {
                task.modified = ""
            }
            if let patient_id: String = resultDict["patient_id"] as? String {
                task.patient_id = patient_id as String
            }else {
                task.patient_id = ""
            }
            if let resolution: String = resultDict["resolution"] as? String {
                task.resolution = resolution as String
            }else {
                task.resolution = "Assigned"
            }
            if let specialist_id: String = resultDict["specialist_id"] as? String {
                task.specialist_id = specialist_id as String
            }else {
                task.specialist_id = ""
            }
            if let selected_staff_ids:AnyObject = resultDict["selected_staff_ids"] {
                for attending_staff in selected_staff_ids as! [AnyObject] {
                    let staff = Staff()
                    if let otherAttendingStaff = attending_staff as? [String:AnyObject] {
                        if let image: String = otherAttendingStaff["image"] as? String {
                            staff.image = image as String
                        }
                        if let member_id: String = otherAttendingStaff["member_id"] as? String {
                            staff.member_id = member_id as String
                        }
                        if let name: String = otherAttendingStaff["name"] as? String {
                            staff.name = name as String
                        }
                        if let staff_id: String = otherAttendingStaff["staff_id"] as? String {
                            staff.id = staff_id as String
                        }
                    }
                    
                    task.attending_professionals.append(staff)
                }
            }
        if isCreatingTask == true {
            self.task = task
            isCreatingTask = false
        }else {
            if isPatientTask == true {
                patientTasks.append(task)
            }else {
                staffTasks.append(task)
            }
        }
    }
}