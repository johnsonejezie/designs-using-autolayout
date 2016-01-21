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
    
    func loginUserWith(email:String, andPassword password:String, completionHandler:(success:Bool)-> Void){
        var user: User!
        var data:User?
        let parameters = [
            "email": email,
            "password": password,
        ]
        
        let url = sharedDataSingleton.baseURL + "login"
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
//        
        manager.POST(url, parameters: parameters, success: { (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!) -> Void in
            print(responseObject)
            let dictionary:[String: AnyObject] = responseObject as! [String: AnyObject]
            if let message: String = dictionary["message"] as? String {
                if (message == "Invalid email or password" || message == "Error incomplete inputs :email,password") {
                    completionHandler(success: false)
                    return
                }else {
                   data = self.parseDictionary(dictionary)
                    if let result = data {
                        user = result
                    }
                    completionHandler(success: true)
                }
            }
            }) { (operation: AFHTTPRequestOperation!,
                error: NSError!) -> Void in
                print(error)
                completionHandler(success: false)
        }
    }
    
    func resetPassword(email:String, oldPassword:String, newPassword:String, completionBlock:(success:Bool)-> Void){
        let parameter = [
            "email":email,
            "oldpassword":oldPassword,
            "newpassword":newPassword
        ]
        
        let url = sharedDataSingleton.baseURL + "reset_password"
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.POST(url, parameters: parameter, success: { (operation:AFHTTPRequestOperation!, json:AnyObject!) -> Void in
            print(json)
            completionBlock(success: true)
            }) { (operation:AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
                completionBlock(success: false)
        }
        
        
        
    }
    
    
    
    private func parseDictionary(dictionary:[String: AnyObject]) -> User {
        let user = User()
        if let resultDict: AnyObject = dictionary["data"] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    print(resultDict)
                    user.created = resultDict["created"] as! String
                    user.email = resultDict["email"] as! String
                    user.firstName = resultDict["firstname"] as! String
                    user.general_practitioner_id = resultDict["general_practitioner_id"] as! String
                    user.id = resultDict["id"] as! String
                    if let image = resultDict["image"] as? String {
                        user.image = image
                    }
                    user.medical_facility = resultDict["medical_facility"] as! String
    
                    user.clinic_id = resultDict["clinic_id"] as! String
                    user.memberid = resultDict["member_id"] as! String
                    user.modified = resultDict["modified"] as! String
                    if let role = resultDict["role"] as? String {
                        user.role = role 
                    }else {
                        user.role = ""
                    }
                    
                    if let speciality = resultDict["speciality"] as? String {
                        user.speciality = speciality
                    }else {
                        user.speciality = ""
                    }
                    user.surname = resultDict["surname"] as! String
                    
                    if let is_password_set: NSString = resultDict["is_password_set"] as? NSString  {
                        user.is_password_set = is_password_set.boolValue
                    }
                    
                    if let isAdmin: Int = resultDict["is_admin"] as? Int  {
                        if isAdmin == 1 {
                            user.isAdmin = true
                        }
                    }
                }
        }
        sharedDataSingleton.medical_facility = user.medical_facility
        sharedDataSingleton.user = user
        return user
    }
    
    
}
