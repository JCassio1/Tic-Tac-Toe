//
//  QRCodeDataViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 13/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit

class QRCodeDataViewController: UIViewController {
    
    var displayName: String = ""
    var displayScore: String = ""
    var displayDevice: String = ""
    
    
    @IBOutlet weak var rankingPosition: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var scorePosition: UILabel!
    @IBOutlet weak var receivedFrom: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQRData()
    }
    
    
    
    func loadQRData(){
        self.displayName = UserDefaults.standard.string(forKey: "PlayerNameScanned")!
        self.displayScore = UserDefaults.standard.string(forKey: "PlayerScoreScanned")!
        self.displayDevice = UserDefaults.standard.string(forKey: "DeviceNameScanned")!
        
        print("Data from user defaults. Name: \(self.displayName), score: \(self.displayScore), device: \(self.displayDevice)")
        
        self.rankingPosition.text = "1"
        self.playerName.text = self.displayName
        self.scorePosition.text = self.displayScore
        self.receivedFrom.text = "Sent from \(self.displayDevice)"
        
    }

}
