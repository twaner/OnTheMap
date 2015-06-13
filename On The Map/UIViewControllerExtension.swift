//
//  UIViewControllerExtension.swift
//  On The Map
//
//  Created by Taiowa Waner on 6/12/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit

extension UIViewController {
    
    ///
    /// Displays or hides an activity indicator.
    ///
    /// :param: on Turns activity indicator on or off.
    func displayActivityViewIndicator(on: Bool, activityIndicator: UIActivityIndicatorView) {
        if on {
            activityIndicator.startAnimating()
            activityIndicator.alpha = 1.0
        } else {
            activityIndicator.alpha = 0.0
            activityIndicator.stopAnimating()
        }
    }
    
    ///
    /// Displays an UIAlertController
    ///
    /// :param: title of Alert
    /// :param: message message of alert
    /// :param: action title for the action button.
    func displayUIAlertController(title:String, message:String, action: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
