//
//  ViewController.swift
//  GeoLocationSample1
//
//  Created by Chris Scheid on 1/26/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var permissionGranted: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location manager setup
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }

    // Callback from location permission authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            permissionGranted = true
        }
    }
    
    // Callback for location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
            
            var output = "Latitude: \(location.coordinate.latitude)\n"
            output = "\(output)Longitude: \(location.coordinate.longitude)\n"
            output = "\(output)Altitude: \(location.altitude)\n"
            output = "\(output)Speed: \(location.speed)\n"
            output = "\(output)SpeedAccuracy: \(location.speedAccuracy)\n"
            output = "\(output)Course: \(location.course)\n"
            output = "\(output)courseAccuracy: \(location.courseAccuracy)\n"
            
            outputLabel.text = output
        }
    }
    
    // Create the alert
    func showAlert(_ message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Checks device location capabilities
    func checkCapabilities() {
        var output = "";
        if (CLLocationManager.significantLocationChangeMonitoringAvailable()) {
            output = "- Significant Location Change Monitoring Available"
        }
        
        if (CLLocationManager.headingAvailable()) {
            output = "\(output)\n- Heading Available"
        }
        
        if (CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)) {
            output = "\(output)\n- Monitoring Available"
        }
        
        if (CLLocationManager.isRangingAvailable()) {
            output = "\(output)\n- Ranging Available"
        }
        
        if (CLLocationManager.locationServicesEnabled()) {
            output = "\(output)\n- Location services enabled"
        }
        
        outputLabel.text = output
    }
    

    @IBAction func requestPermission(_ sender: Any) {
        locationManager?.requestAlwaysAuthorization()
    }
    
    @IBAction func requestCapabilities(_ sender: Any) {
        checkCapabilities()
    }
    
    @IBAction func startTracking(_ sender: Any) {
        if (!permissionGranted) {
            showAlert("Location permission not granted. Select 'Request Permission' first.", title: "Error")
        }
        else {
            locationManager?.startUpdatingLocation()
        }
    }
    
    @IBAction func stopTracking(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
    }
    
    @IBOutlet weak var outputLabel: UILabel!
}

