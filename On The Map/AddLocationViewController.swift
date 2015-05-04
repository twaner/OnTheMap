//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Taiowa Waner on 4/26/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Props
    
    var location: CLLocation? = nil
    var locationPlacemark: MKPlacemark? = nil
    var overWrite = false
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        self.displayActivityView(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MapKit
    
    func getCoordinates(address: String?) {
        self.displayActivityView(true)
        var geoCoder: CLGeocoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let error = error {
                println("getCoordinates error \(error)")
                self.displayActivityView(false)
            } else {
                if (placemarks != nil && placemarks.count > 0) {
                    let result = placemarks[0] as! CLPlacemark
                    let placemark = MKPlacemark(placemark: result)
                    self.locationPlacemark = placemark
                    var lat = placemark.location.coordinate.latitude
                    var long = placemark.location.coordinate.longitude
                    println("getCoordinates placemark \(lat)   \(long)")
                    
                    if self.overWrite {
                        self.updateRecord()
                    } else {
                        self.newRecord()
                    }
                } else {
                    println("Issue with placemark")
                    // TODO: Warning failed to post placemark
                    self.displayActivityView(false)
                }
            }
        })
    }
    
    func newRecord() {
        OTMClient.sharedInstance().postStudentLocation(OTMClient.sharedInstance().currentUser!, placemark: self.locationPlacemark!, completionHandler: { (sucess, result, error) -> Void in
            if let error = error {
                println("newRecord error \(error)")
                // TODO: Warning failed to post locations
                self.displayActivityView(false)
            } else {
                println("getCoordinates result \(result)")
                // TODO: Posted location
                self.displayActivityView(false)
            }
        })
    }
    
    func updateRecord() {
        OTMClient.sharedInstance().putStudentLocation(OTMClient.sharedInstance().currentUser!, placemark: self.locationPlacemark!) { (sucess, result, error) -> Void in
            if let error = error {
                println("updateRecord error \(error)")
                // TODO: Warning failed to post locations
                self.displayActivityView(false)
            } else {
                println("getCoordinates result \(result)")
                // TODO: Posted location
                self.displayActivityView(false)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
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

    
    // MARK: - IBActions
    
    @IBAction func findButtonTapped(sender: UIButton) {
        // TODO: activity view indicator
        self.getCoordinates(self.textField.text)
        var location: MKPlacemark? = self.locationPlacemark
//        OTMClient.sharedInstance().postStudentLocation(self.currentUser!, placemark: location!, completionHandler: { (result, error) -> Void in
//            if let error = error {
//                println("findButtonTapped \(error)")
//            } else {
//                println("findButtonTapped \resut)")
//            }
//        })
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
