//
//  ListaMajstoriTableViewController.swift
//  
//
//  Created by Bojana Kuzeva on 1/8/21.
//

import UIKit
import Parse

class ListaMajstoriTableViewController: UITableViewController {
    
    var tipMajstor : String = ""
    var opisDefekt: String = ""
    var lokacijaKorisnik: String = ""
    var koordinati: CLLocationCoordinate2D? = nil
    var lon : Double = 0
    var lat : Double = 0
    
    var majstoriEmail = [String]()
    var majstoriPhone = [String]()
    var majstoriName = [String]()
    var korisnikId = [String]()
    
    var objectIds = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTabel()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return majstoriEmail.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portfolio", for: indexPath)

        let query = PFQuery(className: "Baranje")
        query.whereKey("majstorId", equalTo: objectIds[indexPath.row])
        query.getFirstObjectInBackground { (object, error)in
            if let err = error{
                print(err.localizedDescription)
            }else{
                if let baranje = object {
                    let status = baranje["status"] as! String
                    let korisnikId = baranje["korisnikId"] as! String
                    if korisnikId == PFUser.current()?.objectId{
                        if status == "activno"{
                            cell.textLabel?.textColor = UIColor.yellow
                            cell.detailTextLabel?.textColor = UIColor.yellow
                        }else if status == "ponuda"{
                            cell.textLabel?.textColor = UIColor.red
                            cell.detailTextLabel?.textColor = UIColor.red
                        }else if status == "zakazano"{
                            cell.textLabel?.textColor = UIColor.blue
                            cell.detailTextLabel?.textColor = UIColor.blue
                        }else if status == "zavrseno"{
                            cell.textLabel?.textColor = UIColor.green
                            cell.detailTextLabel?.textColor = UIColor.green
                        }
                    }else{
                        cell.textLabel?.textColor = UIColor.black
                        cell.detailTextLabel?.textColor = UIColor.black
                    }
                }
            }
        }
        
        cell.textLabel?.text = majstoriName[indexPath.row]
        cell.detailTextLabel?.text = "lokacija"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "portfolio"{
            if let index = tableView.indexPathForSelectedRow?.row{
                let portfolio = segue.destination as! PortfolioTableViewController
                portfolio.objectId = objectIds[index]
                portfolio.opisDefekt = opisDefekt
                portfolio.lokacijaKorisnik = lokacijaKorisnik
                portfolio.lat = lat
                portfolio.lon = lon
            }
            
        }
    }
    
    func updateTabel(){
        self.majstoriEmail.removeAll()
        self.majstoriName.removeAll()
        self.majstoriPhone.removeAll()
        self.objectIds.removeAll()
        
        let query = PFUser.query()
        query?.whereKey("type", equalTo: tipMajstor)
        query?.findObjectsInBackground(block: { (users, error) in
            if error != nil{
                print(error?.localizedDescription ?? "")
            }else if let users = users {
                for object in users{
                    if let user = object as? PFUser{
                        if let username = user.username {
                            if let objectId = user.objectId{
                                self.majstoriEmail.append(username)
                                self.majstoriPhone.append(user["phone"] as! String)
                                self.majstoriName.append(user["name"] as! String)
                                self.objectIds.append(objectId)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        })
        
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
