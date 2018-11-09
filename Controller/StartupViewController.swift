//
//  StartupViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 08/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController {
    
    @IBOutlet weak var displayGif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayGif.loadGif(name: "tictacgif")
    }
}
