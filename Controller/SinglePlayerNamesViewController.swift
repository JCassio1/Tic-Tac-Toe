//
//  SinglePlayerNamesViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 11/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit

class SinglePlayerNamesViewController: UIViewController {

    
    @IBOutlet weak var playerNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerNameTextField.delegate = self as? UITextFieldDelegate
    }
    
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        playerNameTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "singlePlayer" else {return} //identify button being pressed
        let vci = segue.destination as! singleGameViewController
        vci.nameOfPlayer = self.playerNameTextField.text ?? ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerNameTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
}
