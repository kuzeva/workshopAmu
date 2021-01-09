//
//  KorisnikViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//
import UIKit
import MapKit
import Parse



class KorisnikViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapa: MKMapView!
    
    
    @IBOutlet weak var opisTextField: UITextField!
    
    var tipMajstor : String = ""
    var location = ""
    var coordinates: CLLocationCoordinate2D? = nil
    var long : Double = 0
    var lat : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(KorisnikViewController.longpress(gestureReg:)))
        longPress.minimumPressDuration = 1
        mapa.addGestureRecognizer(longPress)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func majstorChoosed(_ sender: UIButton) {
        tipMajstor = sender.titleLabel!.text!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listaMajstori" {
            let listaMajstoriSegue = segue.destination as! ListaMajstoriTableViewController
            listaMajstoriSegue.tipMajstor = tipMajstor
            listaMajstoriSegue.opisDefekt = opisTextField.text!
            listaMajstoriSegue.lokacijaKorisnik = location
            listaMajstoriSegue.lat = lat
            listaMajstoriSegue.lon = long
        }
        
        if segue.identifier == "baranjaKorisnik"{
            let baranja = segue.destination as? BaranjaTableViewController
            baranja!.koordinati = coordinates
            
        }
    }
    
    @IBAction func odjava(_ sender: Any) {
        PFUser.logOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func longpress(gestureReg: UILongPressGestureRecognizer){
        
        if gestureReg.state == UILongPressGestureRecognizer.State.began{
            let touchPoint = gestureReg.location(in: self.mapa)
            let newCoordinates = self.mapa.convert(touchPoint, toCoordinateFrom: self.mapa)
            let newLocation = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
            long = newCoordinates.longitude
            lat = newCoordinates.latitude
            
        
        
        var title = ""
        CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: {(placemarks, error) in
            if error != nil {
                print(error!)
            }else{
                if let placemark = placemarks?[0]{
                    if placemark.subThoroughfare != nil{
                        title += placemark.subThoroughfare! + " "
                    print("sub \(title)")
                }
                    if placemark.thoroughfare != nil {
                        title += placemark.thoroughfare!
                        print("subTho \(title)")
                    }
            }
            
                if title == ""{
                    title = "Added \(NSDate())"
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinates
                annotation.title = self.title
                self.mapa.addAnnotation(annotation)
                
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


