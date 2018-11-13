//
//  QRCodeViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 12/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var player: Results<scoreboardDataModel>!
    let realm = try! Realm()
    
    var playerName: String = ""
    var playerScore: String = ""
    var messageToScan: String = ""
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func generateCode(_ sender: Any) {
        
        playerName = retrievePlayerData(dataToRetrieve: "name")
        playerScore = retrievePlayerData(dataToRetrieve: "score")
        messageToScan = "\(playerName):\(playerScore)"
        
        let data = messageToScan.data(using: .ascii, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let ciImage = filter?.outputImage
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = ciImage?.transformed(by: transform)
        
        let image = UIImage(ciImage: transformImage!)
       qrCodeImage.image = image
    }
    
    
    @IBAction func scanCode(_ sender: Any) {
    }
    
    
    func retrievePlayerData(dataToRetrieve: String) -> String{
        
        player = realm.objects(scoreboardDataModel.self).sorted(byKeyPath: "scores", ascending: false)
        
        var retrievedData: String = ""
        
        if let thePlayer = player?[0]{
            
            if dataToRetrieve == "name"{
                retrievedData = thePlayer.name
            }
                
            else{
                let intoString = String(thePlayer.scores)
                retrievedData = intoString
            }
        }
        
        return retrievedData
    }

}
