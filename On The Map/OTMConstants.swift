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
        
        static let udacityURL = "https://www.udacity.com/api"
        static let parseURL = "https://api.parse.com/1/classes"
        
    }
    
    // MARK: - Methods
    
    struct Methods {
    
        // MARK: - Udacity
        static let Session = "session"
        static let UserData = "users/{id}"
        
        // MARK: - Parse
    }
    
    // MARK: - URL Keys
    
    struct URLKeys {
        
        static let UserID = "id"
    }
    
    // MARK: - Parameter Keys
    
    struct ParameterKeys {
        
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
    }
    
    // MARK: - JSON Body Keys
    
    struct JSONBodyKeys {
        
        static let Email = "email"
        static let Password = "password"
        static let UserID = "user_ID"
    }
    
    // MARK: - JSON Response Keys
    // TODO
    
    
    
}