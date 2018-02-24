//
//  TableViewController.swift
//  HackValley
//
//  Created by Gary Hicks on 2018-02-24.
//  Copyright © 2018 Gary Hicks. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "http://local-flash-sale.test/api/stores/1") {

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error as Any)
                }
                else{
                    if let urlContent = data {
                        
                        do{
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            print(jsonResult)
                            //print(jsonResult["store"])
                            
                            if let store = jsonResult["store"] as? NSDictionary {
                                MyVars.names.append((store["name"] as? String)!)
                                print(MyVars.names)
                                MyVars.lat.append((store["latitude"] as! NSString).doubleValue)
                                MyVars.long.append((store["longitude"] as! NSString).doubleValue)
                                MyVars.status.append(true)
                                
                                DispatchQueue.main.async { // Correct
                                    self.tableView.reloadData()
                                }
                        
                            }
                    
                        }catch{
                            print("JSON Process Error")
                        }
                        
                    }
                }
                
            }
            task.resume()
        }
        /*else{
            self.label.text = "Oops! We can't seem to find the weather there :("
            self.textField.text = ""
        }*/
        
        /*MyVars.lat.append(43.7866575)
        MyVars.long.append(-79.1896812)
        MyVars.names.append("famlets")
        MyVars.status.append(true)*/
        
        if firstTime == true {
            performSegue(withIdentifier: "toMap", sender: nil)
            firstTime = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MyVars.names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.text = "\(MyVars.names[indexPath.row])"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyVars.selected = indexPath.row
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
