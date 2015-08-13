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

    var patient_id:Int!;
    var care_activity_id:Int!;
    var speciality_id:Int!;
    var care_activity_type_id:Int!;
    var care_activity_category_id:Int!;
    var selected_staff_ids:[String] = [];
    var medical_facility_id:Int;
    var operationManger = AFHTTPRequestOperationManager()
    

    init!(
    patient_id:Int!,
    care_activity_id:Int!,
    speciality_id:Int!,
    care_activity_type_id:Int!,
    care_activity_category_id:Int!,
    selected_staff_ids:[String],
    medical_facility_id:Int!
        ){
            self.patient_id = patient_id;
            self.care_activity_id = care_activity_id;
            self.speciality_id =  speciality_id
            self.care_activity_type_id = care_activity_type_id
            self.care_activity_category_id = care_activity_category_id
            self.selected_staff_ids = selected_staff_ids
            self.medical_facility_id = medical_facility_id
    }

}