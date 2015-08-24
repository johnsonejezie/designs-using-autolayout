//
//  Task.swift
//  MediBand
//
//  Created by Kehinde Shittu on 8/4/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AFNetworking

class Task{

    var patient_id:String = ""
    var care_activity_id:String = ""
    var specialist_id:String = ""
    var care_activity_type_id:String = ""
    var care_activity_category_id:String = ""
    var selected_staff_ids:[String] = [];
    var medical_facility:String = ""
    var created:String = ""
    var modified:String = ""
    var id:String = ""
    var resolution:String = ""
    var attending_professionals:[Staff] = []
}