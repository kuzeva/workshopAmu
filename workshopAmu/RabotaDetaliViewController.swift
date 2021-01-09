//
//  RabotaDetaliViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit
import Parse
import MapKit

extension UIImage{
    enum JPEGQuality: CGFloat{
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    func jpeg(_ jpegQuality:JPEGQuality) -> Data?{
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

class RabotaDetaliViewController: UIViewController {

    var rabotaId: String = ""
    var baranjeId: String = ""
    var korisnikId: String = ""
    var koordinati: CLLocationCoordinate2D? = nil
    var lon: Double = 0
    var lat: Double = 0
    
    @IBOutlet weak var datumRabota: UILabel!
    @IBOutlet weak var statusRabota: UILabel!
    @IBOutlet weak var korisnikImePrezime: UILabel!
    @IBOutlet weak var emailKorisnik: UILabel!
    @IBOutlet weak var telefonKorisnik: UILabel!
    @IBOutlet weak var adresaDefekt: UILabel!
    @IBOutlet weak var datumZavrsuvanje: UITextField!
    @IBOutlet weak var slikaZavrsenaRabota: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className: "Rabota")
        query.whereKey("baranjeId", equalTo: baranjeId)
        query.getFirstObjectInBackground { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                    if let rabota = object{
                        if let datumRabota = rabota["datumPonuda"] as? String{
                            if let status = rabota["status"] as? String{
                                if let adresa = rabota["korisnikLokacija"] {
                                    if let korisnikId = rabota["korisnikId"] as? String{
                                        if let lat = rabota["lat"] as? Double{
                                            if let lon = rabota["long"] as? Double{
                                                self.datumRabota.text = "Datum na rabotenje: \(datumRabota)"
                                                self.statusRabota.text = "Status: \(status)"
                                                self.adresaDefekt.text = "Lokacija \(adresa)"
                                                self.korisnikId = korisnikId
                                                self.lat = lat
                                                self.lon = lon
                                                print(lat, lon)
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        let korisnik = PFUser.query()
                        korisnik?.getObjectInBackground(withId: self.korisnikId, block: { (object, error) in
                            if let err = error {
                                print(err.localizedDescription)
                            }else{
                                if let korisnik = object as? PFUser{
                                    self.korisnikImePrezime.text = korisnik["name"] as? String
                                    self.emailKorisnik.text = korisnik.email
                                }
                            }
                        })
                    }
                }
        }
    }
    
    func imagePicker(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            slikaZavrsenaRabota.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func izberiSlikaKliknato(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func zavrsiRabotaKliknato(_ sender: Any) {
        if let image = slikaZavrsenaRabota.image {
            let query = PFQuery(className: "Rabota")
            query.getObjectInBackground(withId: rabotaId) { (object, error) in
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    if let rabota = object {
                        rabota["datumZavrsuvanje"] = self.datumZavrsuvanje.text
                        rabota["status"] = "zavrseno"
                        rabota["majstorId"] = PFUser.current()?.objectId
                        if let imagedata = image.jpeg(.medium){
                            let imageFile = PFFileObject(name: "image.jpg", data: imagedata)
                            rabota["imageFile"] = imageFile
                            self.datumZavrsuvanje.text = ""
                            self.slikaZavrsenaRabota.image = nil
                            rabota.saveInBackground()
                            
                        }
                    }
                }
            }
        }
        let queryBaranje = PFQuery(className: "Baranje")
        queryBaranje.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let baranje  =  object {
                    baranje["status"] = "zavrseno"
                    baranje.saveInBackground()
                }
            }
        }
    }
}
