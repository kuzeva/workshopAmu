//
//  RabotiTableViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit
import Parse

class RabotiTableViewController: UITableViewController {

    var rabotiKorisnikIds = [String]()
    var rabotiDatum = [String]()
    var rabotiStatus = [String]()
    var objectIds = [String]()
    var baranjeIds = [String]()
    
    
    
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
        return rabotiKorisnikIds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rabotaCell", for: indexPath)

        let query = PFUser.query()
        query?.getObjectInBackground(withId: rabotiKorisnikIds[indexPath.row], block: { (object,error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let korisnik = object {
                    cell.textLabel?.text = korisnik["name"] as? String
                }
            }
        })
        
        cell.detailTextLabel?.text = rabotiDatum[indexPath.row]
        
        let status = rabotiStatus[indexPath.row]
        if status == "zakazano"{
            cell.backgroundColor = UIColor.red
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.white
        }else if status == "zavrsena"{
            cell.backgroundColor = UIColor.green
        }
        

        return cell
    }
 
    func updateTable(){
        self.rabotiKorisnikIds.removeAll()
        self.rabotiDatum.removeAll()
        self.rabotiStatus.removeAll()
        self.objectIds.removeAll()
        
        let query = PFQuery(className: "Rabota")
        query.whereKey("majstorId", equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground { (objects, error) in
            if let err = error {
                print(err.localizedDescription)
            }else {
                if let raboti = objects {
                    for rabota in raboti {
                        self.rabotiKorisnikIds.append(rabota["korisnikId"] as! String)
                        self.rabotiDatum.append(rabota["datumPonuda"] as! String)
                        self.rabotiStatus.append(rabota["status"] as! String)
                        self.baranjeIds.append(rabota["baranjeId"] as! String)
                        self.objectIds.append(rabota.objectId!)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rabotaDetali"{
            if let index = tableView.indexPathForSelectedRow?.row {
                let rabota = segue.destination as! RabotaDetaliViewController
                rabota.rabotaId = objectIds[index]
                rabota.baranjeId = baranjeIds[index]
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
