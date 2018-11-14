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

    var video = AVCaptureVideoPreviewLayer()
    
    var getPlayer: Results<scoreboardDataModel>!
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    
    var playerName: String = ""
    var playerScore: String = ""
    var deviceUUID: String = ""
    var messageToScan: String = ""
    
    var scannedPlayerOne: String = ""
    var scannedPlayerScore: String = ""
    var scannedDeviceName: String = ""
    var receivedData: String = ""
    
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func generateCode(_ sender: Any) {
        
        self.playerName = retrieveDataFromDatabase(dataToRetrieve: "name")
        self.playerScore = retrieveDataFromDatabase(dataToRetrieve: "score")
        self.deviceUUID = UIDevice.current.name
        
        messageToScan = "\(playerName):\(playerScore):\(deviceUUID)"
        
        let data = messageToScan.data(using: .ascii, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let ciImage = filter?.outputImage
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = ciImage?.transformed(by: transform)
        
        let image = UIImage(ciImage: transformImage!)
       qrCodeImage.image = image
    }
    
    
    // MARK: User scans QR Code from own device
    @IBAction func scanCode(_ sender: Any) {
        
        //Creating session
        let session = AVCaptureSession()
        
        //Define capture device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch
        {
            print ("Error capturing image")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        //Thread responsability to process in main queue
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //Only read QR Codes and nothing else
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        //Capturing device display (Full Display)
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        //self.view.bringSubview(toFront: square)
        
        session.startRunning()
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    //object.stringValue is the message within the QR Code [object.stringValue]

                    self.receivedData = object.stringValue ?? "no data received:no data received:no data received"
                    
                    let splits = self.receivedData.components(separatedBy: ":")
                    
                    self.scannedPlayerOne = splits[0]
                    self.scannedPlayerScore = splits[1]
                    self.scannedDeviceName = splits[2]
                    
                    self.defaults.set(self.scannedPlayerOne, forKey: "PlayerNameScanned")
                    self.defaults.set(self.scannedPlayerScore, forKey: "PlayerScoreScanned")
                    self.defaults.set(self.scannedDeviceName, forKey: "DeviceNameScanned")


                    //Add Identifier to storyboard by clicking yellow button on top of view
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qrShowView") as? QRCodeDataViewController
                    {
                        present(vc, animated: true, completion: nil)
                    }
                    
                    
                }
            }
        }
    }
    
    
    func retrieveDataFromDatabase(dataToRetrieve: String) -> String{
        
        getPlayer = realm.objects(scoreboardDataModel.self).sorted(byKeyPath: "scores", ascending: false)
        
        var retrievedData: String = ""
        
        if let thePlayer = getPlayer?[0]{
            
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
