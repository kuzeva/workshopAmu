//
//  KorisnikViewController.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit

class KorisnikViewController: UIViewController {

    
    @IBOutlet var mapa: UIView!
    
    @IBOutlet weak var opisTextField: UITextField!
    
    var tipMajstor : String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func majstorChoosed(_ sender: UIButton) {
        tipMajstor = sender.titleLabel!.text!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listaMajstori" {
            let listaMajstori = segue.destination as! ListaMajstoriTableViewController
            listaMajstori.tipMajstor = tipMajstor
        }
    }
    
    @IBAction func odjava(_ sender: Any) {
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
