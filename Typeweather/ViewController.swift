//
//  ViewController.swift
//  Typeweather
//
//  Created by Jure Žove on 14. 09. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    let defaultTextAnimationDuration:NSTimeInterval = 1
    var locationStatus : NSString = "Not Started"
    
    lazy var locationManager:CLLocationManager = {
        var manager:CLLocationManager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateWeather"), name: UIApplicationDidBecomeActiveNotification, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func displayWeather() {
        animateTextChange(self.mainLabel, closure: { () -> () in
            self.mainLabel.attributedText = Prettyfier.boldify("The weather is great! It's exactly the same as yesterday.", words: NSArray(array: ["the same"]))
        })
        
        animateTextChange(self.temperatureLabel, closure: { () -> () in
            self.temperatureLabel.text = Prettyfier.temperatureText(80)
        })
    }
    
    func animateTextChange(view: UILabel, closure:()->()) {
        UIView.transitionWithView(view, duration: defaultTextAnimationDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            closure()
        }, completion: nil)
    }
    
    // Location retrieval
    
    func updateWeather() {
        self.mainLabel.text = NSLocalizedString("Please standby, I'm currently collecting weather data.", comment: "")
        self.temperatureLabel.text = ""
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Location manager delegate
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("\(error)")
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.stopUpdatingLocation()
        println("\(locations)")
        displayWeather()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }

        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            self.mainLabel.text = locationStatus;
        }
    }
}

