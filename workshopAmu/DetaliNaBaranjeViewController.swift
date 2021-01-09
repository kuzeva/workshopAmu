//
//  DetaliNaBaranjeViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit
import Parse

class DetaliNaBaranjeViewController: UIViewController {

    @IBOutlet weak var datumBaranje: UILabel!
    @IBOutlet weak var tipMajstor: UILabel!
    @IBOutlet weak var opisDefekt: UILabel!
    @IBOutlet weak var imePrezimeMajstor: UILabel!
    @IBOutlet weak var emailMajstor: UILabel!
    @IBOutlet weak var telefonMajstor: UILabel!
    @IBOutlet weak var statusBaranje: UILabel!
    @IBOutlet weak var datumZakazanaRabota: UILabel!
    @IBOutlet weak var otkaziButton: UIButton!
    @IBOutlet weak var datumPonuda: UILabel!
    @IBOutlet weak var cenaPonuda: UILabel!
    @IBOutlet weak var prifatiPonudaBtn: UIButton!
    @IBOutlet weak var odbijPonudaBtn: UIButton!
    @IBOutlet weak var slikaZavrsenaRabota: UIImageView!
    
    var baranjeId: String = ""
    var lokacijaKorisnik: String = ""
    var datum: String = ""
    var opis: String = ""
    var majstorId: String = ""
    var status: String = ""
    var cenaNaPonuda: String = ""
    var datumNaPonuda: String = ""
    var datumZakazana: String = ""
    var datumZavrsuvanje: String = ""
    var lat : Double = 0
    var lon : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBaranje()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func otkaziClicked(_ sender: Any) {
        let query = PFQuery(className: "Baranje")
        query.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let baranje = object {
                    baranje.deleteInBackground()
                }
            }
        }
    }
    
    @IBAction func prifatiPonudaClicked(_ sender: Any) {
        let query = PFQuery(className: "Baranje")
        query.getObjectInBackground(withId: baranjeId) {(object,error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let baranje = object {
                    baranje["status"] = "zakazano"
                    baranje.saveInBackground()
                }
            }
        }
        let queryRabota = PFQuery(className: "Rabota")
        queryRabota.whereKey("baranjeId", equalTo: baranjeId)
        queryRabota.getFirstObjectInBackground { (object,error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let rabota = object {
                    rabota["status"] = "zakazano"
                    rabota.saveInBackground()
                }
            }
        }
    }
    
    @IBAction func odbijPonudaClicked(_ sender: Any) {
        let query = PFQuery(className: "Baranje")
        query.getObjectInBackground(withId: baranjeId) { (object,error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let baranje = object {
                    baranje.deleteInBackground()
                }
            }
        }
        let queryRabota = PFQuery(className: "Rabota")
        queryRabota.whereKey("baranjeId", equalTo: baranjeId)
        queryRabota.getFirstObjectInBackground { (object,error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let rabota = object {
                    rabota.deleteInBackground()
                }
            }
        }
    }
    
    
    func getBaranje(){
        let query = PFQuery(className: "Baranje")
        query.whereKey("objectId", equalTo: baranjeId)
        query.getFirstObjectInBackground { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else if let baranje = object {
                self.datum = (baranje["datum"] as? String)!
                print(baranje["datum"] as! String)
                self.opis = (baranje["opis"] as? String)!
                print(baranje["opis"] as! String)
                self.majstorId = (baranje["majstorId"] as? String)!
                print(baranje["majstorId"] as! String)
                self.status = (baranje["status"] as? String)!
                print(baranje["status"] as! String)
                
                let queryMajstor = PFUser.query()
                queryMajstor?.getObjectInBackground(withId: self.majstorId, block: { (object,error) in
                    if let err = error {
                        print(err.localizedDescription)
                    }else{
                     if let majstor = object as? PFUser {
                        self.tipMajstor.text = majstor["type"] as? String
                        self.imePrezimeMajstor.text = majstor["name"] as? String
                        self.emailMajstor.text = majstor.username?.components(separatedBy: "_")[0]
                        self.telefonMajstor.text = majstor["phone"] as? String
                        self.datumZakazanaRabota.isHidden = true
                        self.otkaziButton.isHidden = true
                        self.prifatiPonudaBtn.isHidden = true
                        self.odbijPonudaBtn.isHidden = true
                        self.slikaZavrsenaRabota.isHidden = true
                        
                        if self.status == "aktivno"{
                            self.statusBaranje.text = "Status: \(self.status)"
                            self.datumZakazanaRabota.text = self.datum
                            self.otkaziButton.isHidden = false
                        }else if self.status == "ponuda"{
                            self.statusBaranje.text = "Status: \(self.status)"
                            self.cenaPonuda.isHidden = false
                            self.cenaPonuda.text = self.cenaNaPonuda
                            self.datumPonuda.isHidden = false
                            self.datumPonuda.text = self.datumNaPonuda
                            self.prifatiPonudaBtn.isHidden = false
                            self.odbijPonudaBtn.isHidden = false
                        }else if self.status == "zakazana"{
                            self.statusBaranje.text = "Status \(self.status)"
                            self.datumZakazanaRabota.isHidden = false
                            self.datumZakazanaRabota.text = "Zakazana rabota na \(self.datumZakazana)"
                        }else if self.status == "zavrsena"{
                            self.statusBaranje.text = "Status: \(self.status)"
                            self.slikaZavrsenaRabota.isHidden = false
                            self.datumZakazanaRabota.isHidden = false
                            self.datumZakazanaRabota.text = "Zavrsena rabota na \(self.datumZavrsuvanje)"
                        }
                        
                        let queryRabota = PFQuery(className: "Rabota")
                        queryRabota.whereKey("baranjeId", equalTo: self.baranjeId)
                        queryRabota.getFirstObjectInBackground(block: {(object,error) in
                            if let err = error{
                                print(err.localizedDescription)
                            }else if let rabota = object{
                                if let cena = rabota["cena"] as? String{
                                    if let datumPonuda = rabota["datumPonuda"] as? String {
                                        if let datumZavrs = rabota["datumZavrsuvanje"] as? String {
                                            self.cenaNaPonuda = cena
                                            self.datumNaPonuda = datumPonuda
                                            self.datumZavrsuvanje = datumZavrs
                                        }
                                    }
                                }
                                self.datumBaranje.text = "Pobarano na: \(self.datum)"
                                self.opisDefekt.text = self.opis
                            }else{
                                print("nema zapis")
                            }
                        })
                    }
                }
                })
            }
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
