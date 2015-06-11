//
//  OTMClient.swift
//  On The Map
//
//  Created by Taiowa Waner on 4/23/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import Foundation
import UIKit

class OTMClient: NSObject {
    
    var session: NSURLSession
    
    
    // MARK: - Auth values
    var sessionID: String? = nil
    var userID: String? = nil
    var currentUser: OTMStudent? = nil
    var studentInList: Bool = false
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - POST
    
    ///
    /// Sends a POST request to Udacity.
    ///
    ///:param: method The method to run
    ///:param: parameters The parameters for the method.
    ///:param: jsonBody JSON body of request.
    ///:param: completionHandler Method's completion handler.
    func postUdacityMethodTask(method: String, parameters: [String: AnyObject]?, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        var methodID = method
        var urlString = OTMClient.Constants.udacityURL + methodID
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = HTTPMethod.POST
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var jsonError: NSError? = nil
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonError)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if let error = error {
                OTMClient.errorForData(data, response: response, error: error)
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    ///
    /// Sends a POST request to Parse.
    ///
    ///:param: method The method to run
    ///:param: parameters The parameters for the method.
    ///:param: jsonBody JSON body of request.
    ///:param: completionHandler Method's completion handler.
    func postParseMethodTask(method: String, parameters: [String: AnyObject]?, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {

        var mutableParameters = parameters
        var methodID = method
        var request: NSMutableURLRequest
        var urlString = OTMClient.Constants.parseURL + method
        let url = NSURL(string: urlString)
        request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = HTTPMethod.POST
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var jsonError: NSError? = nil
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonError)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if let error = error {
                OTMClient.errorForData(data, response: response, error: error)
            } else {
                OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    // MARK: - PUT
    func putParaseMethod(method: String, parameters: [String: AnyObject]?, jsonBody: [String: AnyObject],completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        var mutableParameters = parameters
        let urlString = Constants.parseURL + method + OTMClient.sharedInstance().currentUser!.objectId!
        let url = NSURL(string: urlString)
        var jsonError: NSError? = nil
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = HTTPMethod.PUT
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonError)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, downloadError) in
            if let error = downloadError {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: newError)
            } else {
                OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    // MARK: - GET
    
    ///
    /// Sends a GET request to the Parse API.
    ///
    /// :param: method Method to use.
    /// :param: parameters Parameters of method.
    /// :param: completionHandler Completion Handler for the method.
    /// :returns: NSURLSessionDataTask task
    func parseGetHelper(method: String, parameters: [String: AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        let urlString = Constants.parseURL + method + OTMClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)

        let request = NSMutableURLRequest(URL: url!)
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, downloadError) in
            if let error = downloadError {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: newError)
            } else {
                OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    ///
    /// Sends a GET request to Udacity
    ///
    /// :param: method The method to run
    /// :param: id User's Id.
    /// :param: parameters The parameters for the method.
    /// :param: completionHandler Method's completion handler.
    func udacityGetHelper(method: String, parameters: [String: AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.udacityURL + method
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, downloadError) in
            if let error = downloadError {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: error)
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }

    // MARK: - Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error */
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
            
            if let errorMessage = parsedResult[OTMClient.JSONResponseKeys.StatusMessage] as? String {
                
                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                
                return NSError(domain: "OTM Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error
    }
    
    ///
    /// Checks device for network connectivity
    /// :param: controller UIViewController to invoke actions.
    func checkForNetwork(controller: UIViewController) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if !OTMNetworkClient.isConnectedToNetwork() {
                self.displayAlert("Error", error: "No internet connection is available.", controller: controller)
            }
        })
    }
    
    ///
    /// Displays an UIAlertController.
    /// :param: title of Alert
    /// :param: error message of alert
    /// :param: controller UIViewController to present alert.
    func displayAlert(title:String, error:String, controller: UIViewController) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            controller.dismissViewControllerAnimated(true, completion: nil)
        }))
        controller.presentViewController(alert, animated: true, completion: nil)
    }

    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
}