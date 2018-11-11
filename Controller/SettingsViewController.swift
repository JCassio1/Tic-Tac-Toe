//
//  SettingsViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 09/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var soundOn: Bool = true
    
    
    //Persisting user sound setting
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBOutlet weak var switchState: UISwitch!
    
    @IBAction func soundButton(_ sender: UISwitch) {
        
        if sender.isOn == true {
            soundOn = true
            self.defaults.set(self.soundOn, forKey: "soundOption")
            print("Sound turned \(soundOn)")
        }
        
        else{
            soundOn = false
            self.defaults.set(self.soundOn, forKey: "soundOption") 
            print("Sound turned \(soundOn)")
        }
    }
    
    //First check userDeafaults for button position
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        switchState?.isOn =  UserDefaults.standard.bool(forKey: "soundOption")
    }
}
