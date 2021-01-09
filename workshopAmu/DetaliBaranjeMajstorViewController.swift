//
//  DetaliBaranjeMajstorViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit
import MapKit
import Parse

class DetaliBaranjeMajstorViewController: UIViewController {

    @IBOutlet weak var datumBaranjeLabel: UILabel!
    
    @IBOutlet weak var opisLabel: UILabel!
    
    @IBOutlet weak var korisnikLabel: UILabel!
    
    @IBOutlet weak var telefonKorisnikLabel: UILabel!
    
    @IBOutlet weak var emailKorisnikLabel: UILabel!
    
    @IBOutlet weak var mapa: MKMapView!
    
    @IBOutlet weak var cenaTextFild: UITextField!
    
    @IBOutlet weak var datumTextField: UITextField!
    
    var baranjeId: String = ""
    var korisnikId: String = ""
    var datum: String = ""
    var opis: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "Baranje")
        query.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else if let baranje = object {
                self.datum = baranje["datum"] as! String
                self.datumBaranjeLabel.text = "Pobarano ne: \(baranje["datum"] as! String)"
                self.opis = baranje["opisDefekt"] as! String
                self.opisLabel.text = baranje["opisDefekt"] as? String
                self.korisnikId = baranje["korisnikId"] as! String
                self.datumBaranjeLabel.text = self.datum
                self.opisLabel.text = self.opis
                
                let queryMajstor = PFUser.query()
                queryMajstor?.getObjectInBackground(withId: self.korisnikId, block: { (object,error) in
                    if let err = error{
                        print(err.localizedDescription)
                    }else {
                        if let korisnik = object as? PFUser {
                            self.korisnikLabel.text = "Korisnik \(String(describing: korisnik["name"] as? String))"
                            self.emailKorisnikLabel.text = korisnik.email
                            self.telefonKorisnikLabel.text = korisnik["phone"] as? String
                            
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func ispratiPonuda(_ sender: Any) {
        let queryBaranje = PFQuery(className: "Baranje")
        queryBaranje.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error{
                print(err.localizedDescription)
            }else if let baranje = object {
                baranje["status"] = "ponuda"
                baranje["datumPonuda"] = self.datumTextField.text
                baranje["cenaPonuda"] = self.cenaTextFild.text
                baranje.saveInBackground()
                print("ponudata e ispratena")
                
                let rabota = PFQuery(className: "Rabota")
                rabota.whereKey("baranjeId", equalTo: self.baranjeId)
                rabota.getFirstObjectInBackground(block: { (object, error) in
                    if let err = error{
                        print(err.localizedDescription)
                    }else if let rabota = object {
                        rabota["majstorId"] = PFUser.current()?.objectId
                        rabota["korisnikId"] = self.korisnikId
                        rabota["baranjeId"] = self.baranjeId
                        rabota["datumPonuda"] = self.datumTextField.text
                        rabota["cenaPonuda"] = self.cenaTextFild.text
                        rabota["status"] = "ponuda"
                        rabota.saveInBackground()
                    }
                })
                self.cenaTextFild.text = ""
                self.datumTextField.text = ""
            }
        }
    }
    
    @IBAction func odbijBaranje(_ sender: Any) {
        let query = PFQuery(className: "Baranje")
        query.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error{
                print(err.localizedDescription)
            }else if let baraanje = object {
                baraanje.deleteInBackground()
            }
            
            let rabota = PFQuery(className: "Rabota")
            rabota.whereKey("baranjeId", equalTo: self.baranjeId)
            rabota.getFirstObjectInBackground(block: { (object, error) in
                if let err = error {
                    print(err.localizedDescription)
                }else if let rabota = object {
                    rabota.deleteInBackground()
                }
            })
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
