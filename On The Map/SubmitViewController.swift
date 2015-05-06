//
//  SubmitViewController.swift
//  On The Map
//
//  Created by Taiowa Waner on 5/4/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit
import MapKit

class SubmitViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Props
    
    var placemark: MKPlacemark?
    var student = OTMStudent()
    var overWrite = false
    var validURL = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.linkTextField.delegate = self
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.updateMap()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    ///
    /// TextField delegate method that will check if the text entered into the textbox is a valid URL. Sets the validURL variable in block.
    func textFieldDidEndEditing(textField: UITextField) {
        let type: NSTextCheckingType = .Link
        var error: NSError?
        let detection = NSDataDetector(types: NSTextCheckingType.Link.rawValue, error: &error)
        detection?.enumerateMatchesInString(textField.text, options: nil, range: NSMakeRange(0, (textField.text as NSString).length), usingBlock: { (result, flags, _) -> Void in
            if result != nil {
                self.validURL = true
            }
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.goToMapView()
    }
    
    ///
    ///Checks if the URL submitted is valid and updates the current user's media url.
    ///:param: sender Button on UI
    @IBAction func submitButtonTapped(sender: UIButton) {
        if self.validURL {
            OTMClient.sharedInstance().currentUser?.mediaURL = self.linkTextField.text
            if self.overWrite {
                self.updateRecord()
            } else {
                self.newRecord()
            }
        } else {
            let url = self.linkTextField.text
            self.displayAlert("Incorrect URL", error: "\(url) is not a valid URL. Please enter a correct one.")
        }
    }
    
    // MARK: - Helpers
    
    ///
    ///Displays an UIAlertController
    ///:param: title of Alert
    ///:param: error message of alert
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    ///
    /// Updates map with the new annotation of the location for Student.
    func updateMap() {
        let latitude = placemark?.coordinate.latitude
        let longitude = placemark?.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: Double(latitude!), longitude: Double(longitude!))
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations([annotation], animated: true)
     }
    
    ///
    /// Returns to the previous Tab Bar Controller on the main queue to ensure map view can be loaded during a block.
    func goToMapView() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    ///
    /// Uses the POST Student Location API to add a new Student location.
    func newRecord() {
        OTMClient.sharedInstance().postStudentLocation(OTMClient.sharedInstance().currentUser!, placemark: self.placemark!, completionHandler: { (sucess, result, error) -> Void in
            if let error = error {
                self.displayAlert("Error", error: "Could not post location. Please try again.")
            } else {
                self.goToMapView()
            }
        })
    }
    
    ///
    /// Uses the PUT Student Location API to update an existing student's location.
    func updateRecord() {
        OTMClient.sharedInstance().putStudentLocation(OTMClient.sharedInstance().currentUser!, placemark: self.placemark!) { (sucess, result, error) -> Void in
            if let error = error {
               self.displayAlert("Error", error: "Could not post location. Please try again.")
            } else {
                self.goToMapView()
            }
        }
    }
}

extension String {
    func isValidURL() -> Bool {
        let pattern = "((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let pattern2 = "((http|https)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlRegex = NSRegularExpression(pattern: pattern2, options: .CaseInsensitive, error: nil)
        let matches = urlRegex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self)))
        return urlRegex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
    }
}
