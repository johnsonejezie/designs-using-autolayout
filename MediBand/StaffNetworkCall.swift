//
//  StaffNetworkCall.swift
//  MediBand
//
//  Created by Kehinde Shittu on 8/4/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AFNetworking

class StaffNetworkCall{


    let operationManger = AFHTTPRequestOperationManager()
    
//    var staff = Staff?()
    
    func create(staff:Staff){
        
        println("this is staff obj \(staff)")
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        
        let data : [String:AnyObject] = ["medical_facility_id":staff.medical_facility_id,"speciality_id":staff.speciality_id,"general_practitioner_id":staff.general_practional_id,"member_id":staff.member_id,"role_id":staff.role_id,"email":staff.email,"surname":staff.surname,"firstname":staff.firstname,"image":staff.image];
           println("this is staff obj \(data)")
        self.operationManger.POST("http://iconglobalnetwork.com/mediband/api/create_staff", parameters: data, success: { (requestOperation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            println("staff created \(responseObject)")
            }, failure:{ (requestOperation, error) -> Void in
                println("error creating staff \(error)")
        })
        
    }
    
    func edit(staff:Staff){
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        self.operationManger.POST("http://iconglobalnetwork.com/mediband/api/edit_staff", parameters: staff, success: { (requestOperation, responseObject) -> Void in
            println(responseObject)
            }, failure:{ (requestOperation, error) -> Void in
                println(error)
        })
        
    }
    
    
    func viewStaff(email:String!){
       
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        let data : [String:String] = ["email":email]
        self.operationManger.POST("http://iconglobalnetwork.com/mediband/api/view_staff", parameters: data, success: { (requestOperation, responseObject) -> Void in
            println(" view staff :: \(responseObject)")
            }, failure:{ (requestOperation, error) -> Void in
            println(" view staff :: \(error)")
        })
    }
    
    
    func getStaffs(medical_facility_id:Int!){
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        let data : [String:Int] = ["medical_facility_id":medical_facility_id]
        self.operationManger.POST("http://www.iconglobalnetwork.com/mediband/api/get_staff", parameters: data, success: { (requestOperation, responseObject) -> Void in
            println(responseObject)
            }, failure:{ (requestOperation, error) -> Void in
                println(error)
        })
    }
    
}