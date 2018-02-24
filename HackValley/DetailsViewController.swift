//
//  DetailsViewController.swift
//  HackValley
//
//  Created by Gary Hicks on 2018-02-24.
//  Copyright © 2018 Gary Hicks. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate: CLLocation = CLLocation(latitude: MyVars.lat[MyVars.selected], longitude: MyVars.long[MyVars.selected])
        
        CLGeocoder().reverseGeocodeLocation(coordinate) { (placemarks, error) in
            if error != nil {
                print(error)
            }
            else{
                
                if let placemark = placemarks?[0] {
                    
                    var address = ""
                    
                    if placemark.subThoroughfare != nil {
                        address += placemark.subThoroughfare! + " "
                    }
                    
                    if placemark.thoroughfare != nil {
                        address += placemark.thoroughfare! + "\n"
                    }
                    
                    self.label.text = "Address: \(address)"
                    print(coordinate)
                    
                }
            }
        }
    }
    
    @IBAction func go(_ sender: Any) {
        
        let coordinate: CLLocation = CLLocation(latitude: MyVars.lat[MyVars.selected], longitude: MyVars.long[MyVars.selected])
        
        CLGeocoder().reverseGeocodeLocation(coordinate) { (placemarks, error) in
            
            if error != nil {
                print(error)
            }
            else{
                if let placemark = placemarks?[0] {
                    let place = MKPlacemark(placemark: placemark)
                    let mapItem = MKMapItem(placemark: place)
                    mapItem.name = MyVars.names[MyVars.selected]
                    let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: options)
                }
            }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
