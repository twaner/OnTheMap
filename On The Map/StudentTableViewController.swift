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
//    var currentUser: OTMStudent?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "On The Map"
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        OTMClient.sharedInstance().getPublicUserData(OTMClient.sharedInstance().userID!, completionHandler: { (success, response, error) -> Void in
            if let error = error {
                println("ERROR")
            } else {
                println("NOT ERROR")
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
        println(student.uniqueKey)
        
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
        
    }
    
    @IBAction func refreshTapped(sender: UIBarButtonItem) {
        self.populate()
    }
    
    // MARK: - Helpers
    
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
