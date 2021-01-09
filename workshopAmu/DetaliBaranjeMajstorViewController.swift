//
//  DetaliBaranjeMajstorViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit
import MapKit

class DetaliBaranjeMajstorViewController: UIViewController {

    @IBOutlet weak var datumBaranjeLabel: UILabel!
    
    @IBOutlet weak var opisLabel: UILabel!
    
    @IBOutlet weak var korisnikLabel: UILabel!
    
    @IBOutlet weak var telefonKorisnikLabel: UILabel!
    
    @IBOutlet weak var emailKorisnikLabel: UILabel!
    
    @IBOutlet weak var mapa: MKMapView!
    
    @IBOutlet weak var cenaTextFild: UITextField!
    
    @IBOutlet weak var datumTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ispratiPonuda(_ sender: Any) {
    }
    
    @IBAction func odbijBaranje(_ sender: Any) {
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
