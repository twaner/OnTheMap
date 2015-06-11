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
                            OTMClient.sharedInstance().displayAlert("Invalid Login", error: "Please check ID or Password", controller: self)
                        })
                    } else {
                        self.displayActivityView(false)
                        var tabController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.presentViewController(tabController, animated: true, completion: nil)
                        })
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.displayActivityView(false)
                    var errorString = "Please enter a "
                    if self.userNameTextField.text.isEmpty && self.passwordTextField.text.isEmpty {
                        errorString += "username and password"
                    } else if self.userNameTextField.text.isEmpty {
                        errorString += "username"
                    } else {
                        errorString += "password"
                    }
                    OTMClient.sharedInstance().displayAlert("Login Error", error: errorString, controller: self)
                })
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.displayActivityView(false)
                OTMClient.sharedInstance().checkForNetwork(self)
            })
        }
    }
    
    @IBAction func fbLoginButtonTapped(sender: UIButton) {
        
    }
    
    // MARK: - Helpers
    
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
