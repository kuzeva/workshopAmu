//
//  ViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButtom: UIButton!
    
    @IBOutlet weak var majstorLabel: UILabel!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet var korisnikLabel: UIView!
    @IBOutlet weak var imeTextField: UITextField!
    
    @IBOutlet weak var telefonTextField: UITextField!
    
    
    @IBOutlet weak var dzidarButton: UIButton!
    
    @IBOutlet weak var limarButton: UIButton!
    
    @IBOutlet weak var bravarButton: UIButton!
    
    @IBOutlet weak var molerButton: UIButton!
    @IBOutlet var mehanicarButton: UIView!
    @IBOutlet weak var elekticarButton: UIButton!
    @IBOutlet weak var stolarButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tipMajstorPicked(_ sender: UIButton) {
    }
    
    @IBAction func topPressed(_ sender: Any) {
    }
    
    @IBAction func bottomPressed(_ sender: Any) {
    }
}

