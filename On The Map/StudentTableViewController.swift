//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by Taiowa Waner on 4/24/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var refreshTapped: UIBarButtonItem!
    @IBOutlet weak var postToMapTapped: UIBarButtonItem!
    
    // MARK: - Props
    
    var students: [OTMStudent] = [OTMStudent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "On The Map"
        self.hidesBottomBarWhenPushed = false
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: Selector("logout"))
        self.navigationItem.rightBarButtonItems?.append(cancelButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        OTMClient.sharedInstance().getPublicUserData(OTMClient.sharedInstance().userID!, completionHandler: { (success, response, error) -> Void in
            if let error = error {
                self.displayAlert("Error", error: "Could not load user's data.")
            } else {
                
            }
        })
        self.populate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        return self.students.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let student = students[indexPath.row]
        cell.textLabel?.text = student.firstName! + " " + student.lastName!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = students[indexPath.row]
        if let mediaURL = student.mediaURL {
            UIApplication.sharedApplication().openURL(NSURL(string: mediaURL)!)
        } else {
            self.displayAlert("No link", error: "No link was found for student, please try another.")
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func postToMapTapped(sender: UIBarButtonItem) {
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
    
    @IBAction func refreshTapped(sender: UIBarButtonItem) {
        self.populate()
    }
    
    // MARK: - Helpers
    
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
                    self.students = students
                    dispatch_async(dispatch_get_main_queue()) { self.tableView.reloadData()
                    }
                }
            } else {
                self.displayAlert("Error", error: "Could not download data")
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
