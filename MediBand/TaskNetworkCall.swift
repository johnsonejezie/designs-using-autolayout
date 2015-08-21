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



class TaskNetworkCall{
    
    let operationManger = AFHTTPRequestOperationManager()
    private var dataTask: NSURLSessionDataTask? = nil
    
    func create(task:Task, completionBlock:(success:Bool)->Void){
        let url = "http://www.iconglobalnetwork.com/mediband/api/create_task"
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"text/html") as Set<NSObject>

//        manager.responseSerializer = AFJSONResponseSerializer()
        //        manager.responseSerializer.acceptableContentTypes = nil
        let parameters: NSDictionary = [
            "medical_facility_id": "Teaching Hospital",
            "specialist_id": "2",
            "care_activity_type_id": "1",
            "care_activity_category_id": "3",
//            "selected_staff_ids": ["32", "29"],
            "care_activity_id": "2",
            "patient_id": "419"
        ];
        
        let headers = [
            "Content-Type": "text/html"
        ]
        var jsonData = JSON(parameters)
        
        println(jsonData)
    
//        let URL = NSURL(string: "http://www.iconglobalnetwork.com/mediband/api/create_task")!
//        let mutableURLRequest = NSMutableURLRequest(URL: URL)
//        mutableURLRequest.HTTPMethod = "POST"
//        
//        var JSONSerializationError: NSError? = nil
//        mutableURLRequest.HTTPBody = parameters
////        NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &JSONSerializationError)
//        mutableURLRequest.setValue("text/html", forHTTPHeaderField: "Content-Type")
//        
//        Alamofire.request(mutableURLRequest).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (req, res, json, error) -> Void in
//            println(req)
//            println(res)
//            println(json)
//            println(error)   
//        }
//        
//        
//        println(parameters)
        
        
        
        var error: NSError?
        Alamofire.request(.POST, "http://www.iconglobalnetwork.com/mediband/api/create_task", parameters: parameters as? [String : AnyObject], encoding: .JSON, headers: headers).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (req, resp, json, Newerror) -> Void in
                        println(req)
                        println(resp)
                        println(json)
                        println(Newerror)
        }
            
            
            
            

//            let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &error)
//            println("tjis is json \(json)")
//            println("this is error \(error)")
        
//        manager.POST(url, parameters: jsonData as? AnyObject, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
//                        println("this is it\(responseObject)")
//                        println("this is it\(operation.responseString)")
//                        println("this is it\(operation.request)")
//            }) { (operation:AFHTTPRequestOperation!, error:NSError) -> Void in
//                println("is not it ooo \(error)")
//                println("this is it\(operation.request)")
//        }
    }
    
    func getTaskByPatient(lPatient_id:String, lCare_activity_id: String, completionBlock:(success:Bool)-> Void){
        
        let url = "http://www.iconglobalnetwork.com/mediband/api/get_task_by_patient_id"
        let manager = AFHTTPRequestOperationManager()
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"text/html") as Set<NSObject>

        let data : [String:String] = [
            "patient_id":lPatient_id,
            "care_activity_id":lCare_activity_id
        ];
        
        println("get task data \(data)")
        manager.POST("http://www.iconglobalnetwork.com/mediband/api/get_task_by_patient_id", parameters: data, success: { (requestOperation, responseObject) -> Void in
            println("task by patient id response from server \(responseObject)")
            completionBlock(success: true)
            }, failure:{ (requestOperation, error) -> Void in
                println(error)
                completionBlock(success: false)
        })
        
    }
    func getTaskByStaff(lStaff_id:String, lCare_activity_id: String, completionBlock:(success:Bool)->Void){
        let url = "http://www.iconglobalnetwork.com/mediband/api/get_task_by_staff_id"
        let manager = AFHTTPRequestOperationManager()
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        let data :[String: String] = [
            "staff_id":lStaff_id,
            "care_activity_id":lCare_activity_id
        ]
        manager.POST(url, parameters: data, success: { (requestOperation, responseObject) -> Void in
            println("get staffs by staff id response from server \(responseObject)")
            completionBlock(success: true)
            }, failure:{ (requestOperation, error) -> Void in
                println("error getting staffs \(error)")
                completionBlock(success: false)
        })
    }
}