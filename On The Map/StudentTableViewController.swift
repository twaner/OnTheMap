//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by Taiowa Waner on 4/24/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
        
    // MARK: - Props
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "On The Map"
        self.hidesBottomBarWhenPushed = false
        
        let addPinButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action:
            Selector("addPin"))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: Selector("populate"))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: Selector("logout"))
        self.navigationItem.rightBarButtonItem = addPinButton
        self.navigationItem.rightBarButtonItems?.append(refreshButton)
        self.navigationItem.leftBarButtonItem? = cancelButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMClient.sharedInstance().students.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let student = OTMClient.sharedInstance().students[indexPath.row]
        cell.textLabel?.text = student.firstName! + " " + student.lastName!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = OTMClient.sharedInstance().students[indexPath.row]
        if let mediaURL = student.mediaURL {
            UIApplication.sharedApplication().openURL(NSURL(string: mediaURL)!)
        } else {
            self.displayAlert("No link", error: "No link was found for student, please try another.")
        }
    }
    
    // MARK: - Helpers
    
    ///
    /// Adds a pin to the Student List
    ///
    func addPin() {
        if OTMClient.sharedInstance().studentInList {
            var alert = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite it?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Overwrite", style: .Default, handler: { (action) -> Void in
                self.performSegueWithIdentifier("showAddSegue", sender: self)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.performSegueWithIdentifier("showAddSegue", sender: self)
        }
        
    }
    
    ///
    /// Logs the user out; deletes current session object; and returns to the login screen.
    ///
    func logout(){
        OTMClient.sharedInstance().logout()
        performSegueWithIdentifier("loginUnwindSegue", sender: self)
    }
    
    ///
    /// Populates the OTMStudent data source for the view by getting student locations from Parse
    func populate() {
        OTMClient.sharedInstance().getStudentLocations { (success, result, error) -> Void in
            if success {
                if let students = result {
                    OTMClient.sharedInstance().students = students
                    dispatch_async(dispatch_get_main_queue()) { self.tableView.reloadData()
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.displayAlert("Error", error: "Could not download data")
                })
            }
        }
    }
    
    ///
    ///Displays an UIAlertController
    ///
    ///:param: title of Alert
    ///:param: error message of alert
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}
