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
    @IBOutlet weak var list: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var product = [String]()
    var price = [Float]()
    var unit = [String]()
    
    var line = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //print(MyVars.special)
        
        let temp = Int(MyVars.special)
        
        if temp == 3 {
            imageView.image = UIImage(named: "Food Basics.png")
        }
        else if temp == 2 {
            imageView.image = UIImage(named: "Longos.png")
        }
        else if temp == 1 {
            imageView.image = UIImage(named: "Sobeys.png")
        }
        else if temp == 5 {
            imageView.image = UIImage(named: "Metro.png")
        }
        else{
            imageView.image = UIImage(named: "No frills.png")
        }
        
        //print(temp)
        
        if let url = URL(string: "http://local-flash-sale.test/api/stores/\(temp)/products") {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error as Any)
                    
                }
                else{
                    if let urlContent = data {
                        
                        do{
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            //print(jsonResult)
                            
                            if let products = jsonResult["products"] as? NSMutableArray {
                                var i = 0
                                for count in products {
                                    if let item = count as? NSDictionary {
                                    
                                        self.product.append((item["name"] as? String)!)
                                        self.price.append((item["price"] as? Float)!)
                                        self.unit.append((item["unit"] as? String)!)
                                        
                                        self.line += "\(self.product[i]) - \(self.price[i]) \(self.unit[i]) \n \n"
                                        i+=1
                                        //print(i)
                                        
                                    }
                                        
                                }
                                
                                //print(self.product)
                                
                                DispatchQueue.main.async { // Correct
                                    self.list.text = self.line
                                    self.list.sizeToFit()
                                    //print(self.product)
                                }
                                
                            }
                            
                            
                        }catch{
                            print("Json Error")
                        }
                        
                    }
                }
                
            }
            task.resume()
        }
        
        
        //
        
        let coordinate: CLLocation = CLLocation(latitude: MyVars.lat[MyVars.selected], longitude: MyVars.long[MyVars.selected])
        
        CLGeocoder().reverseGeocodeLocation(coordinate) { (placemarks, error) in
            if error != nil {
                print(error as Any)
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
                    //print(coordinate)
                    
                }
            }
        }
    }
    
    @IBAction func go(_ sender: Any) {
        
        let coordinate: CLLocation = CLLocation(latitude: MyVars.lat[MyVars.selected], longitude: MyVars.long[MyVars.selected])
        
        CLGeocoder().reverseGeocodeLocation(coordinate) { (placemarks, error) in
            
            if error != nil {
                print(error as Any)
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
