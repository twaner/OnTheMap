//
//  OTMStudent.swift
//  On The Map
//
//  Created by Taiowa Waner on 4/23/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import Foundation

struct OTMStudent {
    var objectId: String? = nil
    var uniqueKey: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var latitude: Float? = nil
    var longitude: Float? = nil
    var createdAt: NSDate? = nil
    var updatedAt: NSDate? = nil
    
    init(dictionary: [String: AnyObject]) {
        self.objectId = dictionary[OTMClient.JSONResponseKeys.ObjectId] as? String
        self.uniqueKey = dictionary[OTMClient.JSONResponseKeys.UniqueKey] as? String
        self.firstName = dictionary[OTMClient.JSONResponseKeys.FirstName] as? String
        self.lastName = dictionary[OTMClient.JSONResponseKeys.LastName] as? String
        self.mapString = dictionary[OTMClient.JSONResponseKeys.MapString] as? String
        self.mediaURL = dictionary[OTMClient.JSONResponseKeys.MediaURL] as? String
        self.latitude = dictionary[OTMClient.JSONResponseKeys.Latitude] as? Float
        self.longitude = dictionary[OTMClient.JSONResponseKeys.Longitude] as? Float
        self.createdAt = dictionary[OTMClient.JSONResponseKeys.CreatedAt] as? NSDate
        self.updatedAt = dictionary[OTMClient.JSONResponseKeys.UpdatedAt] as? NSDate
    }
    
    init() {
    }
    
    static func studentFromResults(results: [[String:AnyObject]]) -> [OTMStudent] {
        var students = [OTMStudent]()
        for result in results {
            students.append(OTMStudent(dictionary: result))
        }
        println("studentFromResults COUNT \(students.count)")
        return students
    }
}