//
//  LoginViewController.swift
//  On The Map
//
//  Created by Taiowa Waner on 4/24/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.activityIndicator.alpha = 0.0
        self.navigationItem.title = "On The Map"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if self.passwordTextField.text != "" || self.userNameTextField.text != "" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        self.displayActivityView(true)
        if OTMNetworkClient.isConnectedToNetwork() {
            if !self.userNameTextField.text.isEmpty && !self.passwordTextField.text.isEmpty {
                OTMClient.sharedInstance().postCreateSession(userNameTextField.text, password: passwordTextField.text, completionHandler: { (result, error) -> Void in
                    if let error = error {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.displayActivityView(false)
                            self.displayAlert("Invalid Login", error: "Invalid ID or Password")
                        })
                    } else {
                        self.displayActivityView(false)
                        var tabController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                        self.presentViewController(tabController, animated: true, completion: nil)
                    }
                })
            } else {
                self.displayActivityView(false)
                self.displayAlert("Login Error", error: "Please enter a username and password")
            }
        } else {
            self.displayActivityView(false)
            self.checkForNetwork()
        }
    }
    
    @IBAction func fbLoginButtonTapped(sender: UIButton) {
        
    }
    
    // MARK: - Helpers
    
    ///
    /// Displays an UIAlertController.
    /// :param: title of Alert
    /// :param: error message of alert
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkForNetwork() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if !OTMNetworkClient.isConnectedToNetwork() {
                println("NO COnenction")
                self.displayAlert("Error", error: "No internet connection is available.")
            }
        })
    }
    
    ///
    /// Displays or hides an activity indicator.
    ///
    /// :param: on Turns activity indicator on or off.
    func displayActivityView(on: Bool) {
        if on {
            self.activityIndicator.startAnimating()
            self.activityIndicator.alpha = 1.0
        } else {
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }
    }
}
