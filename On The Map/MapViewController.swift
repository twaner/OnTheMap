//
//  MapViewController.swift
//  On The Map
//
//  Created by Taiowa Waner on 4/24/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Props
    
    var students: [OTMStudent] = [OTMStudent]()
    var currentStudent: OTMStudent = OTMStudent()
    var mapAnnotations: [MKPointAnnotation] = [MKPointAnnotation]()
    var getUdacityUser: NSDictionary?
    var currentUserOnMap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.navigationItem.title = "On The Map"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: Selector("logout"))
        self.navigationItem.rightBarButtonItems?.append(cancelButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBarHidden = false
        self.populate()
        
        if !self.currentUserOnMap {
            OTMClient.sharedInstance().getPublicUserData(OTMClient.sharedInstance().userID!, completionHandler: { (success, response, error) -> Void in
                if let error = error {
                    println("if !self.currentUserOnMap \(error)")
                    self.displayAlert("Error", message: "Could not retrieve information for current user", action: "OK")
                } else {
                    self.createStudentFromPublicData(response! as! NSDictionary)
                }
            })
        }
    }
    
    ///
    ///Creates a Student object from a dictionary.
    ///:param: dictionary Dictionary that contains student information.
    func createStudentFromPublicData(dictionary: NSDictionary) {
        
        if OTMClient.sharedInstance().currentUser == nil {
            OTMClient.sharedInstance().currentUser = OTMStudent()
        }
    
        OTMClient.sharedInstance().currentUser!.uniqueKey = OTMClient.sharedInstance().userID!
        OTMClient.sharedInstance().currentUser!.firstName = dictionary.valueForKey(OTMClient.JSONResponseKeys.First_Name) as? String
        OTMClient.sharedInstance().currentUser!.lastName = dictionary.valueForKey(OTMClient.JSONResponseKeys.Last_Name) as? String
        var medialUrl = dictionary.valueForKey(OTMClient.JSONResponseKeys.ExternalAccounts) as? [[String: AnyObject]]
        
        for q in medialUrl! {
            var account = q[OTMClient.JSONResponseKeys.SocialData] as? [String: AnyObject]
            OTMClient.sharedInstance().currentUser!.mediaURL = (q[OTMClient.JSONResponseKeys.SocialData] as! NSDictionary).valueForKey(OTMClient.JSONResponseKeys.SocialURL) as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let annotation = annotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = self.mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if let url = view.annotation.subtitle {
            UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
        } else {
            self.displayAlert("Error", message: "Could not find a URL to launch", action: "OK")
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func actionTapped(sender: UIBarButtonItem) {
        if self.currentUserOnMap {
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
    /// Populates the data for the view. This method will call the Get Student Locations API to get locations and will add them to the view.
    func populate() {
        OTMClient.sharedInstance().getStudentLocations { (success, result, error) -> Void in
            if success {
                if let students = result {
                    self.students = students
                    for q in self.students {
                        if q.uniqueKey == OTMClient.sharedInstance().userID! {
                            OTMClient.sharedInstance().currentUser = q
                            self.currentUserOnMap = true
                            OTMClient.sharedInstance().studentInList = true
                        }
                        let location = CLLocationCoordinate2D(latitude: Double(q.latitude!), longitude: Double(q.longitude!))
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = "\(q.firstName!) \(q.lastName!)"
                        if let mediaURL = q.mediaURL {
                            annotation.subtitle = q.mediaURL!
                        } else {
                            annotation.subtitle = "No URL provided"
                        }
                        self.mapView.addAnnotation(annotation)
                        self.mapAnnotations.append(annotation)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.mapView.showAnnotations(self.mapAnnotations, animated: true)
                    }
                }
            } else {
                self.displayAlert("Error", message: "Could not download data", action: "OK")
            }
        }
    }
    
    ///
    /// Displays an UIAlertController
    ///
    /// :param: title of Alert
    /// :param: message message of alert
    /// :param: action title for the action button.
    func displayAlert(title:String, message:String, action: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAddSegue" {
            let nextVC = segue.destinationViewController as! AddLocationViewController
            if self.currentUserOnMap {
                nextVC.overWrite = true
            } else {
                nextVC.overWrite = false
            }
        }
    }
}
