//
//  TaskNetworkCall.swift
//  MediBand
//
//  Created by Kehinde Shittu on 8/4/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AFNetworking

class TaskNetworkCall{
    
    let operationManger = AFHTTPRequestOperationManager()
    
    func create(task:Task){
        
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        
        let data :[String:AnyObject]=["medical_facility_id":task.medical_facility_id,"speciality_id":task.speciality_id,"care_activity_type_id":task.care_activity_type_id,"care_activity_category_id":task.care_activity_category_id,"selected_staff_ids":task.selected_staff_ids,"care_activity_id":task.care_activity_id,"patient_id":task.patient_id];
        
        println("create task data \(data)")
        self.operationManger.POST("http://www.iconglobalnetwork.com/mediband/api/create_task", parameters: data, success: { (requestOperation, responseObject) -> Void in
            println(responseObject)
            }, failure:{ (requestOperation, error) -> Void in
                println(error)
        })
    }
    
    func getTaskByPatient(lPatient_id:Int, lCare_activity_id: Int){
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        
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