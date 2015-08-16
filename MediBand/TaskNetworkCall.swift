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
    
    func create(task:Task){
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.AllowFragments)
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        let headers = [
            "Content-Type": "text/html; charset=UTF-8"
        ]
        let data:[String:AnyObject] = [
            "medical_facility_id":"Teaching Hospital",
            "speciality_id":"2",
            "care_activity_type_id":"1",
            "care_activity_category_id":"3",
            "selected_staff_ids":["32", "29"],
            "care_activity_id":"2",
            "patient_id":"419"
        ];
        
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var session = NSURLSession(configuration: configuration)
        let url = "http://www.iconglobalnetwork.com/mediband/api/create_task"
        let nsUrl = NSURL(string: url)
        
        Just.post(url, data: data, asyncProgressHandler: { (progress) -> Void in
            println("progress \(progress)")
        }) { (result) -> Void in
            println("this is result \(result.content)")
            var error:NSError?
            if let json = NSJSONSerialization.JSONObjectWithData(result.content!, options:NSJSONReadingOptions.AllowFragments, error: &error) as? [String: AnyObject] {
                
                                                    println(json)
            }else {
                println(error)
            }

        }
//        
//        let request = NSMutableURLRequest(URL: nsUrl!)
//        
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        request.HTTPMethod = "POST"
//        var err: NSError?
//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted, error: &err)
//        dataTask = session.dataTaskWithRequest(request, completionHandler: { (dataresp, response, errorResp) -> Void in
//            
//                        if (errorResp != nil) {
//                            println("this is error \(errorResp)")
//                        }else if let httpResponse = response as? NSHTTPURLResponse {
//                            if httpResponse.statusCode == 200 {
//                                println("this is data \(dataresp)")
//                                var error: NSError?
//                                if let json = NSJSONSerialization.JSONObjectWithData(dataresp, options:NSJSONReadingOptions.AllowFragments, error: &error) as? [String: AnyObject] {
//                                    println(error)
//                                    println(json)
//                                }else {
//                                    println(error)
//                                }
//                            }
//                        }
//            
//        })
//
////        dataTask = session.dataTaskWithURL(nsUrl!, completionHandler: { (dataresp, response, error) -> Void in
////            if (error != nil) {
////                println("this is error \(error)")
////            }else if let httpResponse = response as? NSHTTPURLResponse {
////                if httpResponse.statusCode == 200 {
////                    println("this is data \(dataresp)")
////                    var error: NSError?
////                    if let json = NSJSONSerialization.JSONObjectWithData(dataresp, options:NSJSONReadingOptions(0), error: &error) as? [String: AnyObject] {
////                        println(json)
////                    }
////                }
////            }
////        })
//        dataTask?.resume()
        
//        manager.POST(url, parameters: data, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            println("this is response \(response)")
//            }) { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
//            println("this is error \(error)")
//        }
        
        

    }
    
    func getTaskByPatient(lPatient_id:Int, lCare_activity_id: Int){
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json") as Set<NSObject>
        
        let data : [String:Int] = ["patient_id":lPatient_id, "care_activity_id":lCare_activity_id];
        println("get task data \(data)")
        self.operationManger.POST("http://www.iconglobalnetwork.com/mediband/api/get_task_by_patient_id", parameters: data, success: { (requestOperation, responseObject) -> Void in
            println(responseObject)
            }, failure:{ (requestOperation, error) -> Void in
                println(error)
        })
        
    }
    
    
    func getTaskByStaff(lStaff_id:Int, lCare_activity_id: String){
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        let data : [String:AnyObject] = ["staff_id":lStaff_id, "care_activity_id":lCare_activity_id];
        self.operationManger.POST("http://www.iconglobalnetwork.com/mediband/api/get_task_by_staff_id", parameters: data, success: { (requestOperation, responseObject) -> Void in
            println("get staffs by staff id response from server \(responseObject)")
            }, failure:{ (requestOperation, error) -> Void in
                println("error getting staffs \(error)")
        })
        
    }
}