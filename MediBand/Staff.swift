//
//  Staff.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/1/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import XLForm


class Staff: NSObject, XLFormOptionObject {
    var medical_facility_id:String = ""
    var speciality_id:String = ""
    var general_practional_id:String  = ""
    var member_id:String  = ""
    var role_id:String  = ""
    var email:String  = ""
    var surname:String  = ""
    var firstname:String  = ""
    var image:String = ""
    var staffs:[NSMutableDictionary] = []
    var id:String  = ""
    var created:String  = ""
    var modified:String  = ""
    var role:String  = ""
    var speciality:String  = ""
    var name:String = ""
    
    func formDisplayText() -> String {
        return self.firstname + " " + self.surname
    }
    
    func formValue() -> AnyObject {
        return self.id
    }
    
}