//
//  PortfolioTableViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit
import Parse

class PortfolioTableViewController: UITableViewController {

    var objectId: String = ""
    var images = [PFFileObject]()
    var dates = [String]()
    var opisDefekt: String = ""
    var lokacijaKorisnik: String = ""
    var lat: Double = 0
    var lon: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "Rabota")
        query.whereKey("majstorId", equalTo: objectId)
        query.findObjectsInBackground { (objects, error) in
            if let raboti = objects {
                for rabota in raboti {
                    if let imageFile = rabota["imageFile"] {
                        if let datumPonuda = rabota["datumPonuda"]{
                            self.images.append(imageFile as! PFFileObject)
                            self.dates.append(datumPonuda as! String)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    
    @IBAction func pobarajGoMajstorot(_ sender: Any) {
        
        let date  = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd//mm//yyyy"
        let dateString = dateFormatter.string(from: date)
        let baranje = PFObject(className: "Baranje")
        
        baranje["korisnikId"] = PFUser.current()?.objectId
        baranje["majstorId"] = objectId
        baranje["opisDefekt"] = opisDefekt
        baranje["datum"] = dateString
        baranje["korisnikLokacija"] = lokacijaKorisnik
        baranje["lat"] = lat
        baranje["lon"] = lon
        baranje["status"] = "activno"
        
        baranje.saveInBackground { (success, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                print(success.description)
                print("Napraveno Baranje")
            }
            
            let rabota = PFObject(className: "Rabota")
            rabota["lat"] = self.lat
            rabota["lon"] = self.lon
            rabota["baranjeId"] = baranje.objectId
            rabota.saveInBackground()
            print("rabotata e zacuvana")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portfolioCell", for: indexPath) as! PortfolioTableViewCell
        if !images.isEmpty{
            images[indexPath.row].getDataInBackground { (data, error) in
                if let imagedata = data {
                    if let img = UIImage(data: imagedata) {
                        cell.zavrsenaRabotaSlika.image = img
                    }
                }
            }
            cell.datumZavrsuvanje.text = dates[indexPath.row]
        }
        
        // Configure the cell...

        return cell
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
