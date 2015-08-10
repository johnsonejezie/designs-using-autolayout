//
//  LoginNetworkCall.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/10/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AFNetworking


class Login {
    
    func loginUserWith(email:String, andPassword password:String) -> User {
        var user: User!
        let data:User?
        let parameters = [
            "email": email,
            "password": password,
        ]
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let url = "http://www.iconglobalnetwork.com/mediband/api/login"
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
//        
//        manager.POST(url, parameters: parameters, success: { (operation: AFHTTPRequestOperation!,
//            responseObject: AnyObject!) -> Void in
//            println(responseObject)
//            let dictionary:[String: AnyObject] = responseObject as! [String: AnyObject]
////            data = self.parseDictionary(dictionary)
//            if let result = data {
//                user = result
//            }
//            }) { (operation: AFHTTPRequestOperation!,
//                error: NSError!) -> Void in
//                println(error)
//        }
        return user
    }
    
    private func parseDictionary(dictionary:[String: AnyObject]) -> User {
        let user = User?()
        if let resultDict: AnyObject = dictionary["data"] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    user?.created = resultDict["created"] as! String
                    user?.email = resultDict["email"] as! String
                    user?.firstName = resultDict["firstname"] as! String
                    user?.general_practitioner_id = resultDict["general_practitioner_id"] as! String
                    user?.id = resultDict["id"] as! Int
                    user?.image = resultDict["image"]!
                    user?.medical_facility = resultDict["medical_facility"] as! String
                    user?.memberid = resultDict["member_id"] as! String
                    user?.modified = resultDict["modified"] as! String
                    user?.role = resultDict["role"] as! String
                    user?.speciality = resultDict["speciality"] as! String
                    user?.surname = resultDict["surname"] as! String
                }
        }
        return user!
    }
    
    
}
