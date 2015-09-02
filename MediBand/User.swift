//
//  User.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/1/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class User {
    var firstName: String = ""
    var surname: String = ""
    var email: String = ""
    var medical_facility: String
     = ""
    var role: String = ""
    var memberid: String = ""
    var speciality: String = ""
    var id : String = ""
    var general_practitioner_id: String = ""
    var image:AnyObject = ""
    var created: String = ""
    var modified: String = ""
    var is_password_set:Bool = true
    var isAdmin:Bool = false
}
