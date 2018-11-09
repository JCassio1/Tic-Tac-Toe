//
//  NamesViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 07/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit

class NamesViewController: UIViewController {

    var playerOne = ""
    var playerTwo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerOneField.delegate = self as? UITextFieldDelegate
        playerOneField.delegate = self as? UITextFieldDelegate

    }
    
    
    @IBOutlet weak var playerOneField: UITextField!
    
  
    @IBOutlet weak var PlayerTwoField: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerOneField.resignFirstResponder()
        PlayerTwoField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        self.playerOne = playerOneField.text ?? "Player One"
        self.playerTwo = PlayerTwoField.text ?? "Player two"
        
        performSegue(withIdentifier: "name", sender: self)
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "name" else {return} //identify button being pressed
        let vc = segue.destination as! ViewController
        vc.playerOneName = self.playerOne
        vc.playerTwoName = self.playerTwo
    }
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


