//
//  SettingsViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 09/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var soundOn: String = "On"
    
    
    //Persisting user sound setting
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBAction func soundButton(_ sender: UISwitch) {
        
        if sender.isOn == true {
            soundOn = "On"
            self.defaults.set(self.soundOn, forKey: "soundOption")
            print("Sound turned \(soundOn)")
        }
        
        else{
            soundOn = "Off"
            self.defaults.set(self.soundOn, forKey: "soundOption") 
            print("Sound turned \(soundOn)")
        }
    }
}
