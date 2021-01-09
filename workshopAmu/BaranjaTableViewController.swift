//
//  BaranjaTableViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit
import Parse

class BaranjaTableViewController: UITableViewController {

    var baranjaMajstorIds = [String]()
    var baranjaDatum = [String]()
    var baranjaStatus = [String]()
    var objectIds = [String]()
    var lokacijaKorisnik = [String]()
    var koordinati : CLLocationCoordinate2D? = nil
    var lon : Double = 0
    var lat : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTable()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return baranjaMajstorIds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baranjeKorisnikCell", for: indexPath)
        let query = PFUser.query()
        query?.getObjectInBackground(withId: baranjaMajstorIds[indexPath.row], block: {(object, error) in
            if let err = error {
                print("cell")
                print(err.localizedDescription)
            }else{
                if let majstor = object{
                    cell.textLabel!.text = majstor["name"] as? String
                }
            }
        })
        
        cell.detailTextLabel?.text = baranjaDatum[indexPath.row]
        let status = baranjaStatus[indexPath.row]
        if status == "aktivno"{
            cell.textLabel?.backgroundColor = UIColor.yellow
            cell.detailTextLabel?.textColor = UIColor.yellow
        }else if status == "ponuda"{
            cell.textLabel?.backgroundColor = UIColor.red
            cell.detailTextLabel?.textColor = UIColor.red
        }else if status == "zakazana"{
            cell.textLabel?.backgroundColor = UIColor.blue
            cell.detailTextLabel?.textColor = UIColor.blue
        }else if status == "zavrseno"{
            cell.textLabel?.backgroundColor = UIColor.green
            cell.detailTextLabel?.textColor = UIColor.green
        }
         //Configure the cell...
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detaliBaranje"{
            if let index = tableView.indexPathForSelectedRow?.row{
                let baranje = segue.destination as! DetaliNaBaranjeViewController
                baranje.baranjeId = objectIds[index]
                baranje.lon = lon
                baranje.lat = lat
                
            }
        }
    }
 
    func updateTable(){
        self.baranjaMajstorIds.removeAll()
        self.baranjaDatum.removeAll()
        self.baranjaStatus.removeAll()
        self.objectIds.removeAll()
        
        let query = PFQuery(className: "Baranje")
        query.whereKey("korisnikId", equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground{ (objects, error) in
            if let err = error{
                print("updateTable")
                print(err.localizedDescription)
            }else{
                if let baranja = objects {
                    for baranje in baranja{
                        self.baranjaMajstorIds.append(baranje["majstorId"] as! String)
                        self.baranjaDatum.append(baranje["datum"] as! String)
                        self.baranjaStatus.append(baranje["status"] as! String)
                        self.objectIds.append(baranje.objectId!)
                        
                        self.tableView.reloadData()
                        
                    }
                }
            }
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
