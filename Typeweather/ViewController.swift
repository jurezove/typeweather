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
    @IBOutlet weak var cityLabel: UILabel!

    let defaultTextAnimationDuration:NSTimeInterval = 1
    var locationStatus : NSString = "Not Started"
    lazy var weatherManager:WeatherManager = WeatherManager()
    
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
    
    func displayWeather(json: Dictionary<String, AnyObject>) {
        animateTextChange(mainLabel, closure: { () -> () in
            self.mainLabel.attributedText = Prettyfier.boldify("The weather is great! It's exactly the same as yesterday.", words: NSArray(array: ["the same"]))
        })
        
        animateTextChange(temperatureLabel, closure: { () -> () in
            NSLog("%@", json)
            let main:AnyObject! = json["main"]
            let temp = Double(main["temp"] as Double)
            var name = json["name"] as NSString
            
            self.cityLabel.text = name
            self.temperatureLabel.text = Prettyfier.temperatureText(temp)
        })
    }
    
    func animateTextChange(view: UILabel, closure:()->()) {
        UIView.transitionWithView(view, duration: defaultTextAnimationDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            closure()
        }, completion: nil)
    }
    
    // Location retrieval
    
    func updateWeather() {
        mainLabel.text = NSLocalizedString("Please standby, I'm currently collecting weather data.", comment: "")
        temperatureLabel.text = ""
        cityLabel.text = ""
        
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
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        println("\(locations)")
        let firstLocation = locations[0] as CLLocation
        weatherManager.currentWeatherFor(firstLocation.coordinate, closure: { (json) -> () in
            self.displayWeather(json as Dictionary<String, AnyObject>)
        })

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
            mainLabel.text = locationStatus;
        }
    }
}

