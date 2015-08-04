//
//  Staff.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/1/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit


class Staff {

    
    var medical_facility_id:Int!;
    var speciality_id:Int!;
    var general_practional_id:Int!;
    var member_id:Int!;
    var role_id:Int!;
    var email:String!;
    var surname:String!;
    var firstname:String!;
    var image:AnyObject!;

    
    init!(
     medical_facility_id:Int!,
     speciality_id:Int!,
     general_practional_id:Int!,
     member_id:Int!,
     role_id:Int!,
     email:String!,
     surname:String!,
     firstname:String!,
     image:AnyObject!
        ){
       self.medical_facility_id =     medical_facility_id
       self.speciality_id = speciality_id
       self.general_practional_id = general_practional_id
       self.member_id =  member_id
       self.role_id = role_id
       self.email =  email
       self.surname =  surname
       self.firstname = firstname
       self.image = image
    }
}