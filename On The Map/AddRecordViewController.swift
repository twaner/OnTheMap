//
//  AddRecordViewController.swift
//  On The Map
//
//  Created by Taiowa Waner on 5/5/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit
import MapKit

class AddRecordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    
    // MARK: - Props
    
    var location: CLLocation? = nil
    var locationPlacemark: MKPlacemark? = nil
    var overWrite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.locationTextField.delegate = self
//        self.linkTextField.delegate = self
        self.displayActivityView(false)
        self.hidesBottomBarWhenPushed = false

        // Do any additional setup after loading the view.
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
                    self.locationPlacemark = MKPlacemark(placemark: result)
                    self.displayActivityView(false)
//                    self.performSegueWithIdentifier("SubmitSegue", sender: self)
                } else {
                    println("Issue with placemark")
                    // TODO: Warning failed to post placemark
                    self.displayActivityView(false)
                }
            }
        })
    }
    
    func showContainer(show: Bool) {
        self.studyingLabel.hidden = show
        self.findOnMapButton.hidden = show
        self.containerView.hidden = !show
        self.locationTextField.hidden = !show
        
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
    
    // MARK: - IBActions
    
    
    @IBAction func findOnMapTapped(sender: UIButton) {
        
        self.getCoordinates(self.locationTextField.text)
        var location: MKPlacemark? = self.locationPlacemark
    }

    @IBAction func submitButtonTapped(sender: UIButton) {
    }
}
