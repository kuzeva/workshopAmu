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
    
    @IBOutlet weak var bottomButton: UIButton!
    
    @IBOutlet weak var majstorLabel: UILabel!
    
    
    @IBOutlet weak var userSwitch: UISwitch!
    
    @IBOutlet var korisnikLabel: UIView!
    
    
    @IBOutlet weak var imePrezimeTextField: UITextField!
    
    @IBOutlet weak var telefonTextField: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var dzidarButton: UIButton!
    @IBOutlet weak var limarButton: UIButton!
    @IBOutlet weak var bravarButton: UIButton!
    @IBOutlet weak var molerButton: UIButton!
    @IBOutlet weak var mehanicarButton: UIView!
    @IBOutlet weak var elekticarButton: UIButton!
    @IBOutlet weak var stolarButton: UIButton!
    
    var signUpMode = false
    var tipNaMajstor = ""
    var korisnik = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if !signUpMode {
            imePrezimeTextField.isHidden = true
            telefonTextField.isHidden = true
            userSwitch.isHidden = true
            majstorLabel.isHidden = true
            korisnikLabel.isHidden = true
            tipLabel.isHidden = true
            dzidarButton.isHidden = true
            limarButton.isHidden = true
            bravarButton.isHidden = true
            stolarButton.isHidden = true
            elekticarButton.isHidden = true
            mehanicarButton.isHidden = true
            molerButton.isHidden = true
        
        }
    }

    func displayAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func tipMajstorPicked(_ sender: UIButton) {
        tipNaMajstor = sender.titleLabel!.text!
        sender.setTitleColor(.red, for: .normal)
    }
    
    @IBAction func topPressed(_ sender: Any) {
        
        if emailTextField.text == "" && passwordTextField.text == "" {
            displayAlert(title: "Greska", message: "Vnesi email i password")
        }else {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            view.addSubview(activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signUpMode {
                if userSwitch.isOn{
                    //se registrira obicen korisnik
                    let user = PFUser()
                    user.username = emailTextField.text! + "_korisnik"
                    user.password = passwordTextField.text
                    user.email = emailTextField.text
                    user["name"] = imePrezimeTextField.text
                    user["phone"] = telefonTextField.text
                    
                    user.signUpInBackground { (success, error) in
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        if let error = error{
                            let errorString = error.localizedDescription
                            self.displayAlert(title: "Greska pri Registracija", message: errorString)
                        }else {
                            print("Uspesna Registracija")
                            self.performSegue(withIdentifier: "korisnikSegue", sender: self)
                        }
                    }
                }else {
                    //se registrira majstor
                    let user = PFUser()
                    user.username = emailTextField.text! + "_majstor"
                    user.password = passwordTextField.text
                    user.email = emailTextField.text
                    user["name"] = imePrezimeTextField.text
                    user["phone"] = telefonTextField.text
                    user["type"] = tipNaMajstor
                    
                    user.signUpInBackground { (success, error) in
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        if let error = error{
                            let errorString = error.localizedDescription
                            self.displayAlert(title: "Greska pri Registracija", message: errorString)
                        }else {
                            print("Uspesna Registracija")
                            self.performSegue(withIdentifier: "majstorSegue", sender: self)
                        }
                    }
                }
            }else{
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if let error = error {
                        let errorString = error.localizedDescription
                        self.displayAlert(title: "Greska pri najava", message: errorString)
                    }else{
                        print("Uspesna najava")
                        if user?.username?.components(separatedBy: "_")[1] == "majstor"{
                            self.performSegue(withIdentifier: "majstorSegue", sender: self)
                        }else{
                            self.performSegue(withIdentifier: "korisnikSegue", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func userSwitchChanged(_ sender: UISwitch) {
        if signUpMode {
            if sender.isOn{
                tipLabel.isHidden = true
                dzidarButton.isHidden = true
                limarButton.isHidden = true
                bravarButton.isHidden = true
                stolarButton.isHidden = true
                elekticarButton.isHidden = true
                mehanicarButton.isHidden = true
                molerButton.isHidden = true
            }else{
                imePrezimeTextField.isHidden = false
                telefonTextField.isHidden = false
                userSwitch.isHidden = false
                majstorLabel.isHidden = false
                korisnikLabel.isHidden = false
                tipLabel.isHidden = false
                dzidarButton.isHidden = false
                limarButton.isHidden = false
                bravarButton.isHidden = false
                stolarButton.isHidden = false
                elekticarButton.isHidden = false
                mehanicarButton.isHidden = false
                molerButton.isHidden = false
            }
            
        }
    }
    
    @IBAction func bottomPressed(_ sender: UIButton) {
        
        if signUpMode{ // vo najava
            signUpMode = false
            topButton.setTitle("Najava", for: .normal)
            bottomButton.setTitle("Registracija", for: .normal)
            
            imePrezimeTextField.isHidden = true
            telefonTextField.isHidden = true
            userSwitch.isHidden = true
            majstorLabel.isHidden = true
            korisnikLabel.isHidden = true
            tipLabel.isHidden = true
            dzidarButton.isHidden = true
            limarButton.isHidden = true
            bravarButton.isHidden = true
            stolarButton.isHidden = true
            elekticarButton.isHidden = true
            mehanicarButton.isHidden = true
            molerButton.isHidden = true
        }else{
            signUpMode = true
            topButton.setTitle("Registriraj se", for: .normal)
            bottomButton.setTitle("kon Najava", for: .normal)
            
            imePrezimeTextField.isHidden = false
            telefonTextField.isHidden = false
            userSwitch.isHidden = false
            majstorLabel.isHidden = false
            korisnikLabel.isHidden = false
            tipLabel.isHidden = false
            dzidarButton.isHidden = false
            limarButton.isHidden = false
            bravarButton.isHidden = false
            stolarButton.isHidden = false
            elekticarButton.isHidden = false
            mehanicarButton.isHidden = false
            molerButton.isHidden = false
            
        }
    }

}

