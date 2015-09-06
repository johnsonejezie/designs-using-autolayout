//
//  CaseNoteAPI.swift
//  MediBand
//
//  Created by Johnson Ejezie on 9/5/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class CaseNoteAPI:NSObject, NSURLConnectionDataDelegate {
    
    enum Path {
        case CREATE_CASENOTE
        case GET_CASENOTE
    }
    
    typealias APICallback = ((AnyObject?, NSError?) -> ())
    let responseData = NSMutableData()
    var statusCode:Int = -1
    var callback: APICallback! = nil
    var path: Path! = nil
    var caseNotes = [CaseNote]()
    var isCreatingCaseNote:Bool = false
    var caseNote = CaseNote()
    
    
    func getCaseNotes(staff_id: String, page:String, callback: APICallback) {
        let url = "http://iconglobalnetwork.com/mediband/api/get_casenotes"
        let body = "staff_id=\(staff_id)&page=\(page)"
        makeHTTPPostRequest(Path.GET_CASENOTE, callback: callback, url: url, body: body)
    }
    
    
    func createCaseNote(caseNote: CaseNote, callback: APICallback) {
        isCreatingCaseNote = true
        let url = "http://iconglobalnetwork.com/mediband/api/create_casenote"
        let body = "task_id=\(caseNote.task_id)&details=\(caseNote.details)&staff_id=\(caseNote.staff_id)"
        println(body)
        makeHTTPPostRequest(Path.CREATE_CASENOTE, callback: callback, url: url, body: body)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        let httpResponse = response as! NSHTTPURLResponse
        statusCode = httpResponse.statusCode
        switch (httpResponse.statusCode) {
        case 201, 200, 401:
            self.responseData.length = 0
        default:
            println("ignore")
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.responseData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        var error: NSError?
        var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(self.responseData, options: NSJSONReadingOptions.MutableLeaves, error: &error)
        if (error != nil) {
            callback(nil, error)
            return
        }
        switch(statusCode, self.path!) {
        case (200, Path.GET_CASENOTE):
            callback(self.handleGetCaseNotes(json), nil)
        case (200, Path.CREATE_CASENOTE):
            callback(self.handleCreateCaseNote(json), nil)
        default:
            // Unknown Error
            callback(nil, nil)
        }
    }
    func handleGetCaseNotes(json: AnyObject)-> [CaseNote]? {
        println("this is staff json \(json)")
        if let array:AnyObject = json["data"] {
            for resultDict in array as! [AnyObject] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    self.parseDictionaryToCaseNote(resultDict)
                }
            }
            return caseNotes
        }
        
        return nil
    }
    func handleCreateCaseNote(json: AnyObject)-> CaseNote? {
        println("this is staff json \(json)")
        if let resultDict = json["data"] as? [String: AnyObject] {
            self.parseDictionaryToCaseNote(resultDict)
            return self.caseNote
        }
        return nil
    }
    
    func makeHTTPPostRequest(path: Path, callback: APICallback, url: NSString, body: NSString) {
        self.path = path
        self.callback = callback
        let request = NSMutableURLRequest(URL: NSURL(string: url as String)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let conn = NSURLConnection(request: request, delegate:self)
        if (conn == nil) {
            callback(nil, nil)
        }
    }
    
    func parseDictionaryToCaseNote(resultDict:[String:AnyObject]) {
        let newCaseNote = CaseNote()
        if let id = resultDict["id"] as? String {
            newCaseNote.caseID = id
        }
        if let task_id = resultDict["task_id"] as? String {
            newCaseNote.task_id = task_id
        }
        if let staff_id = resultDict["staff_id"] as? String {
            newCaseNote.staff_id = staff_id
        }
        if let name = resultDict["name"] as? String {
            newCaseNote.name = name
        }
        if let details = resultDict["details"] as? String {
            newCaseNote.details = details
        }
        if let created = resultDict["created"] as? String {
            newCaseNote.created = created
        }
        if isCreatingCaseNote == true {
            self.caseNote = newCaseNote
        }else {
            caseNotes.append(newCaseNote)
        }
    }

}
