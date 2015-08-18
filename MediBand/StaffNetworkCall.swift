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
        
    func create(staff:Staff){
        
        println("this is staff obj \(staff)")
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        
        let data : [String:AnyObject] = ["medical_facility_id":staff.medical_facility_id,
            "speciality_id":staff.speciality_id,
            "general_practitioner_id":staff.general_practional_id,
            "member_id":staff.member_id,
            "role_id":staff.role_id,
            "email":staff.email,
            "surname":staff.surname,
            "firstname":staff.firstname,
            "image":staff.image
        ];
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
    
    
    func getStaffs(medical_facility_id:String!, completionBlock:(done:Bool)->Void){
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        let data : [String:String] = ["medical_facility_id":medical_facility_id]
        self.operationManger.POST("http://www.iconglobalnetwork.com/mediband/api/get_staff", parameters: data, success: { (requestOperation, responseObject) -> Void in
            println(responseObject)
            
            let responseDicts = responseObject as! [String:AnyObject]
            if let arrayDict:AnyObject = responseDicts["data"]{
            
                self.parseStaffs(arrayDict as! [AnyObject], completionBlock: { (done) -> Void in
                    if (done) {
                        println("all staffs parsed")
                         completionBlock(done:true)
                    }
                })
            }

            }, failure:{ (requestOperation, error) -> Void in
                println(error)
             
                  completionBlock(done:false)
        })
    }
    
    
    func parseStaffs(staffArray:[AnyObject], completionBlock:(done:Bool)->Void)-> Void{
        
        var result = [Staff]()
        for data in staffArray as [AnyObject]{
            if let dict = data as? [String:AnyObject] {
                
                print(dict)
                
                var staffData = Staff()
                print(Staff())
                staffData.id = dict["id"] as! String
//                staffData.general_practional_id = dict["general_practional_id"] as! String
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
                
//                staffData.member_id = dict["member_id"] as! String
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
                
                    result.append(staffData);
                
            }

            
        }
        sharedDataSingleton.allStaffs = result
         println("staff count 1 \(sharedDataSingleton.allStaffs.count) ")
         println("staff count result \(result.count) ")
        completionBlock(done:true)
    }
}