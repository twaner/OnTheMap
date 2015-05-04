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
    
    // MARK: - Props
//    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.alpha = 0.0
        self.navigationItem.title = "On The Map"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var beginning: UITextPosition = textField.beginningOfDocument
        var start: UITextPosition =  textField.positionFromPosition(beginning, inDirection: .Right, offset: range.location)!
        var end: UITextPosition = textField.positionFromPosition(start, offset: range.length)!
        var textRange: UITextRange = textField.textRangeFromPosition(start, toPosition: end)!
        
        textField.replaceRange(textRange, withText: string.uppercaseString)
        return false
    }
    
    // MARK: - Actions

    @IBAction func loginButtonTapped(sender: UIButton) {
        self.displayActivityView(true)
        if !self.userNameTextField.text.isEmpty && !self.passwordTextField.text.isEmpty {
            OTMClient.sharedInstance().postCreateSession(userNameTextField.text, password: passwordTextField.text, completionHandler: { (result, error) -> Void in
                if let error = error {
                    // Alert something went wrong
                    println("loginButtonTapped:ERROR \(error)")
                    self.displayActivityView(false)
                    // Display alert - deal w/ keyboard issue
//                    self.displayAlert("Invalid Login", error: "Invalid ID or Password")
                } else {
//                    println("RESULT \(result)")
                    println(" loginButtonTapped: \(OTMClient.sharedInstance().userID)  \(OTMClient.sharedInstance().sessionID)")
                    self.displayActivityView(false)
                    var tabController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                    self.presentViewController(tabController, animated: true, completion: nil)
                }
            })
//            self.displayAlert("Invalid Login", error: "Invalid ID or Password")
        } else {
            // u/n or pw is blank stop indicator and display alert
            self.displayActivityView(false)
            self.displayAlert("Login Error", error: "Please enter a username and password")
        }
    }
    
    @IBAction func fbLoginButtonTapped(sender: UIButton) {
        // TODO
    }
    
    // MARK: - Helpers
    
    ///
    /// Displays an UIAlertController
    ///:param: title of Alert
    ///:param: error message of alert
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
