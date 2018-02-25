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
    
    var product = [String]()
    var price = [String]()
    var unit = [String]()
    
    var line = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(MyVars.special)
        
        if let url = URL(string: "http://local-flash-sale.test/api/stores/1/sales") {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error as Any)
                    
                }
                else{
                    if let urlContent = data {
                        
                        do{
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            //print(jsonResult)
                            
                            if let sales = jsonResult["sales"] as? NSMutableArray {
                                var i = 0
                                for count in sales {
                                    if let item = count as? NSDictionary {
                                    
                                        self.product.append((item["product_name"] as? String)!)
                                        self.price.append((item["sale_price"] as? String)!)
                                        self.unit.append((item["unit"] as? String)!)
                                        
                                        self.line += "\(self.product[i]) \n \(self.price[i]) \(self.unit[i]) \n \n"
                                        i+=1
                                        
                                    }
                                        
                                }
                                
                                
                                DispatchQueue.main.async { // Correct
                                    self.list.text = self.line
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
