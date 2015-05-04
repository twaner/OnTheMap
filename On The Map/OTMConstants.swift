//
//  OTMConstants.swift
//  On The Map
//
//  Created by Taiowa Waner on 4/23/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import Foundation

extension OTMClient {
    
    // MARK: - Constants
    struct Constants {
        // MARK: - API Keys
        
        static let FaceBookApiKey = "365362206864879"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: - URLs
        
        static let udacityURL = "https://www.udacity.com/api/"
        static let parseURL = "https://api.parse.com/1/classes/"
        
    }
    
    struct Target {
    
        static let Udacity = "Udacity"
        static let Parse = "Parse"
    }
    
    // MARK: - Methods
    
    struct Methods {
    
        // MARK: - Udacity
        static let Session = "session"
        static let UserData = "users/{id}"
        
        // MARK: - Parse
        static let StudentLocations = "StudentLocation/"
        static let StudentLocationId = "StudentLocation/{id}"
    }
    
    struct HTTPMethod {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
    }
    
    // MARK: - URL Keys
    
    struct URLKeys {
        
        static let UserID = "id"
        static let Limit = "limit"
    }
    
    // MARK: - Parameter Keys
    
    struct ParameterKeys {
        
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let UserID = "user_id"
        static let Limit = "limit"
    }
    
    // MARK: - JSON Body Keys
    
    struct JSONBodyKeys {
        // Udacity Keys
        static let Udacity = "udacity"
        static let Email = "email"
        static let Password = "password"
        static let UserID = "user_ID"
        static let UserName = "username"
        
        // Parse POST Student Location
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let uniqueKey = "uniqueKey"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        // Udacity
        static let ID = "id"
        static let StatusMessage = "status_message"
        static let registered = "resgistered"
        static let Account = "account"
        static let key = "key"
        static let SessionID = "session_id"
        static let expiration = "expiration"
        static let Session = "session"
        static let Results = "results"
        static let User = "user"
        
        // Udacity Get Student Data
        static let ExternalAccounts = "external_accounts"
        static let APK = "affiliate_program_key"
        static let Linkedin = "linkedin"
        static let GitHub = "github"
        static let Last_Name = "last_name"
        static let First_Name = "first_name"
        static let SocialData = "social_data"
        static let SocialURL = "social_url"
        
        // Parse GET Students
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let UpdatedAt = "updatedAt"
        static let UniqueKey = "uniqueKey"
        
        // Parse POST Student Location
        static let ObjectId = "objectId"
    }
}