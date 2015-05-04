//
//  OTMConvenience.swift
//  On The Map
//
//  Created by Taiowa Waner on 4/23/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension OTMClient {
    
    // MARK: - POST
    
    ///
    ///Logs a user into Udacity and creates a session.
    ///
    ///:param: userName username.
    ///:param: password password.
    ///:param: completionHandler completion handler for method.
    func postCreateSession(userName: String, password: String, completionHandler: (result: String?, error: NSError?) -> Void) {
        let method: String = OTMClient.Methods.Session
        let jsonBody: [String: [String: AnyObject]] = [
            OTMClient.JSONBodyKeys.Udacity:
            [OTMClient.JSONBodyKeys.UserName: userName,
            OTMClient.JSONBodyKeys.Password: password]
        ]
        
        let task = OTMClient.sharedInstance().postUdacityMethodTask(OTMClient.Methods.Session, parameters: nil, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                var error = false
                var compID: String?
                if let results =  result.valueForKey(OTMClient.JSONResponseKeys.Session) as? NSDictionary {
                    if let id = results.valueForKey(OTMClient.JSONResponseKeys.ID) as? String {
                        self.sessionID = id
                        compID = id
                    } else {
                        error = true
                    }
                    if let idResults = result.valueForKey(OTMClient.JSONResponseKeys.Account) as? NSDictionary {
                        if let userID = idResults.valueForKey(OTMClient.JSONResponseKeys.key) as? String {
                            self.userID = userID
                        } else {
                            error = true
                        }
                    } else {
                        completionHandler(result: nil, error: NSError(domain: "postCreateSession parsing Session ID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postCreateSession Session ID (error)"]))
                    }
                    if error {
                     completionHandler(result: nil, error: NSError(domain: "postCreateSession parsing Session ID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postCreateSession Session ID (error)"]))
                    } else {
                        completionHandler(result: compID, error: nil)
                    }
                } else {
                    completionHandler(result: nil, error: NSError(domain: "postCreateSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postCreateSession Final Else"]))
                }
            }
        }
    }
    
    ///
    ///Posts a Student location to Parse.
    ///
    ///:param: student Student to populate json body.
    ///:param: placemark Placemark for location
    ///:param: completionHandler Completion Handler for method
    func postStudentLocation(student: OTMStudent, placemark: MKPlacemark, completionHandler: (sucess: Bool, result: AnyObject?, error: NSError?) -> Void) {
        let method = OTMClient.Methods.StudentLocations
        
        let jsonBody: [String: AnyObject] = [
            JSONResponseKeys.UniqueKey: student.uniqueKey!,
            JSONResponseKeys.FirstName: student.firstName!,
            JSONResponseKeys.LastName: student.lastName!,
            JSONResponseKeys.MapString: "\(placemark.name) \(placemark.administrativeArea)",
            JSONResponseKeys.MediaURL: student.mediaURL!,
            JSONResponseKeys.Latitude: placemark.location.coordinate.latitude,
            JSONResponseKeys.Longitude: placemark.location.coordinate.longitude
        ]
        
        let task = OTMClient.sharedInstance().postParseMethodTask(Methods.StudentLocations, parameters: nil, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                completionHandler(sucess: false, result: nil, error: error)
            } else {
                println("postStudentLocation \(result)")
                if let results = result!.valueForKey(OTMClient.JSONResponseKeys.CreatedAt) as? String {
                    completionHandler(sucess: true, result: result, error: nil)
                }
            }
        }
    }
    
    ///
    ///PUTs a Student location to Parse and updates their data.
    ///
    ///:param: student Student to populate json body.
    ///:param: placemark Placemark for location
    ///:param: completionHandler Completion Handler for method
    func putStudentLocation(student: OTMStudent, placemark: MKPlacemark, completionHandler: (sucess: Bool, result: AnyObject?, error: NSError?) -> Void) {
        
        var parameters: [String: AnyObject] = [JSONBodyKeys.UserID : student.objectId!]
        
        let jsonBody: [String: AnyObject] = [
            JSONResponseKeys.UniqueKey: student.uniqueKey!,
            JSONResponseKeys.FirstName: student.firstName!,
            JSONResponseKeys.LastName: student.lastName!,
            JSONResponseKeys.MapString: "\(placemark.name) \(placemark.administrativeArea)",
            JSONResponseKeys.MediaURL: student.mediaURL!,
            JSONResponseKeys.Latitude: placemark.location.coordinate.latitude,
            JSONResponseKeys.Longitude: placemark.location.coordinate.longitude
        ]
        
        let task = OTMClient.sharedInstance().putParaseMethod(Methods.StudentLocations, parameters: parameters, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                completionHandler(sucess: false, result: nil, error: error)
            } else {
                if let results = result.valueForKey(JSONResponseKeys.UpdatedAt) as? String {
                    println("putStudentLocation \(result)")
                    println(results)
                    completionHandler(sucess: true, result: result, error: nil)
                }
            }
        }
    }
    
    // MARK: - GET
    
    ///
    ///Gets Student Locations from Parse. Hardcoded to return only 100.
    ///
    ///:param: completionHandler that contains a success flag, array of OTMStudent, and an error.
    func getStudentLocations(completionHandler: (success: Bool, result: [OTMStudent]?, error: NSError?)-> Void) {
        var params = [OTMClient.ParameterKeys.Limit: 1000]
        var method: String = Methods.StudentLocations
        
        parseGetHelper(method, parameters: params) { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, result: nil, error: error)
            } else {
                if let results = result!.valueForKey(OTMClient.JSONResponseKeys.Results) as? [[String: AnyObject]] {
                    var students = OTMStudent.studentFromResults(results)
                    completionHandler(success: true, result: students, error: nil)
                } else {
                    completionHandler(success: false, result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    ///
    ///Gets a user's public data from Udacity.
    ///
    ///:param: id User's ID
    ///:param: completionHandler completion handler for method
    func getPublicUserData(id: String, completionHandler: (success: Bool, response: AnyObject?, error: NSError?) -> Void) {
        var parameters = [OTMClient.ParameterKeys.UserID:  id]
        
        var method = OTMClient.subtituteKeyInMethod(Methods.UserData, key: URLKeys.UserID, value: id)
        
        udacityGetHelper(method!, parameters: parameters) { (result, error) -> Void in
            if let error = error {
                println(error)
                completionHandler(success: false, response: nil, error: error)
            } else {
                if let results = result?.valueForKey(JSONResponseKeys.User) as? NSDictionary {
//                    println("func getPublicUserData RESULTS \(results)")
                    var newResults = results as? [String: AnyObject]
                    completionHandler(success: true, response: results, error: nil)
                } else {
//                println("func getPublicUserData 2 \(result!)")
                    var r = result! as! [String:[String: AnyObject]]
                    var newResult = result!.valueForKey(JSONResponseKeys.User) as? [String: AnyObject]
                    completionHandler(success: true, response: newResult, error: nil)
                }
            }
        }
    }
}