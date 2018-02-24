//
//  ViewController.swift
//  HackValley
//
//  Created by Gary Hicks on 2018-02-24.
//  Copyright © 2018 Gary Hicks. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

struct MyVars {
    static var lat = [CLLocationDegrees]()
    static var long = [CLLocationDegrees]()
    static var names = [String]()
    static var status = [Bool]()
    static var selected = 0
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.showsUserLocation = true
        
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        //print(latitude)
        //print(longitude)
        
        let latDelta: CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
        
        for count in 0..<(MyVars.names.count) {
            let latdif = (latitude-MyVars.lat[count])*(latitude-MyVars.lat[count])
            let longdif = (longitude-MyVars.long[count])*(longitude-MyVars.long[count])
            
            if (latdif + longdif).squareRoot() < 10 && MyVars.status[count] == true {
                self.displayAlert(title: "Flash Sale!", message: MyVars.names[count])
                MyVars.status[count] = false
            }
            
        }
        
        for count in 0..<(MyVars.names.count) {
            
            let annotation = MKPointAnnotation()
            let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: MyVars.lat[count], longitude: MyVars.long[count])
            annotation.coordinate = newCoordinate
            annotation.title = MyVars.names[count]
            self.map.addAnnotation(annotation)
        }
    }

}

