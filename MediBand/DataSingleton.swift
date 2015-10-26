//
//  DataSingleton.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/9/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class DataSingleton {
    
    var medical_facility:String = ""
    var user:User!
    var patients:[Patient] = []
    var selectedPatient:Patient!
    var allStaffs = [Staff]()
    var selectedStaff:Staff!
    var tasks = [Task]()
    var patientHistory = [Task]()
    var staffHistory = [Task]()
    var isCheckingNewPatientID:Bool = true
    var staffTask = [Task]()
    var patientTask = [Task]()
    var patientID:String = ""
    var selectedIDs = [String]()
    var isEditingProfile = false
    var specialistFilterString = ""
    var outbox = [[String: Any]]()
    var outboxFileArray:NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
    var theme:UIColor?
    var taskCurrentPage:Int = 1
    var taskTotalPage:Int = 1
    var patientsCurrentPage:Int = 1
    var patientsTotalPage:Int = 1
    var caseNotesTotalPage:Int = 1
    var caseNotesCurrentPage :Int = 1
}

let sharedDataSingleton = DataSingleton()


