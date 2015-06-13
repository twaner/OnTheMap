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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameTextField.text = ""
        self.passwordTextField.text = ""
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
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
//        self.displayActivityView(true)
        displayActivityViewIndicator(true, activityIndicator: self.activityIndicator)
        if OTMNetworkClient.isConnectedToNetwork() {
            if !self.userNameTextField.text.isEmpty && !self.passwordTextField.text.isEmpty {
                OTMClient.sharedInstance().postCreateSession(userNameTextField.text, password: passwordTextField.text, completionHandler: { (result, error) -> Void in
                    if let error = error {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            self.displayActivityView(false)
                            self.displayActivityViewIndicator(false, activityIndicator: self.activityIndicator)
                            OTMClient.sharedInstance().displayAlert("Invalid Login", error: "Please check ID or Password", controller: self)
                        })
                    } else {
                        var tabController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.displayActivityViewIndicator(false, activityIndicator: self.activityIndicator)
                            self.presentViewController(tabController, animated: true, completion: nil)
                        })
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.displayActivityViewIndicator(false, activityIndicator: self.activityIndicator)
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
                self.displayActivityViewIndicator(false, activityIndicator: self.activityIndicator)
                OTMClient.sharedInstance().checkForNetwork(self)
            })
        }
        
    }
    
    @IBAction func fbLoginButtonTapped(sender: UIButton) {
        
    }    
}
