//
//  sharingPlayerStatsViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 11/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import RealmSwift

class sharingPlayerStatsViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var gamePlayersInfo:[dataTransfer]!
    var player: Results<scoreboardDataModel>!
    
    let realm = try! Realm()
    
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    
    var hosting: Bool!
    
    var messageToBeSent: String!
    var messageReceived: String!
    
    
    @IBOutlet weak var otherPlayerRanking: UILabel!
    @IBOutlet weak var otherPlayerName: UILabel!
    @IBOutlet weak var otherPlayerScore: UILabel!
    @IBOutlet weak var connectedDevice: UILabel!
    
    
    @IBOutlet weak var theStartButton: UIButton!
    @IBOutlet weak var theShareButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConnectivity()
        hosting = false
        mcSession.disconnect()
        theShareButton.isHidden = true
    }
    
    func setupConnectivity(){
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    
    func sendPlayerStat(_ thePlayerStats: dataTransfer){
        
        if (mcSession.connectedPeers.count > 0) {
            if let playerData = DataManager.loadData(thePlayerStats.playerIdentifier.uuidString){
                do{
                    try mcSession.send(playerData, toPeers: mcSession.connectedPeers, with: .reliable)
                }
                
                catch{
                fatalError("Could not send player stats")
                }
            }
            
            else{
                print("Not connected to another device ")
            }
        }
    }

    
    @IBAction func startButton(_ sender: Any) {
        
        //Actions sheet displays a list of options vertically (popup)
        
        if mcSession.connectedPeers.count == 0 && hosting == false{
         let actionSheet = UIAlertController(title: "Stats Sharing", message: "Do you wish to host or join a sharing session?", preferredStyle: .actionSheet)
        
        // MARK: Hosting Session
        actionSheet.addAction(UIAlertAction(title: "Host sharing session", style: .default, handler: { (action:UIAlertAction) in
            
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "my-tictac", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
            self.hosting = true
            self.theStartButton.setTitle("Stop Hosting", for: .normal)
            self.theShareButton.isHidden = false
        }))
        
        // MARK: JOINING Session
        actionSheet.addAction(UIAlertAction(title: "Join sharing session", style: .default, handler: { (action:UIAlertAction) in
            let mcBrowser = MCBrowserViewController(serviceType: "my-tictac", session: self.mcSession)
            mcBrowser.delegate = self
            self.theStartButton.setTitle("Disconnect", for: .normal)
            self.theShareButton.isHidden = false
            self.present(mcBrowser, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        }
        
        else if mcSession.connectedPeers.count == 0 && hosting == true
        {
            print("Came into waiting for peers to join!")
            let waitActionSheet = UIAlertController(title: "Waiting...", message: "Waiting for other devices to connect", preferredStyle: .actionSheet)
            
            waitActionSheet.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: { (action) in
                self.mcSession.disconnect()
                self.hosting = false
                self.theStartButton.setTitle("Start", for: .normal)
                self.theShareButton.isHidden = true
                self.connectedDevice.text = ""
            }))
            
            waitActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(waitActionSheet, animated: true, completion: nil)
        }
        
        else if mcSession.connectedPeers.count > 0 && hosting == true{
            
            print("Came into more than 1 peer connected!")
            
            let disconnectActionSheet = UIAlertController(title: "Are you sure you want to disconnect?", message: nil, preferredStyle: .actionSheet)
            
            disconnectActionSheet.addAction(UIAlertAction(title: "Disconnect", style: .cancel, handler: { (action:UIAlertAction) in
                self.mcSession.disconnect()
                self.theStartButton.setTitle("Start", for: .normal)
                self.theShareButton.isHidden = true
                self.hosting = false
                self.connectedDevice.text = ""
            }))
            
            disconnectActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(disconnectActionSheet, animated: true, completion: nil)
        }
        
        else{
            print("Came into else!")
            
            self.mcSession.disconnect()
            self.theStartButton.setTitle("Start", for: .normal)
            self.theShareButton.isHidden = true
            self.connectedDevice.text = ""
        }
        
    }
    
    
    // MARK: Send data method
    @IBAction func sharePressed(_ sender: Any) {
        
        messageToBeSent = "\(retrieveHighestPlayer(whichData:"name")):\(retrieveHighestPlayer(whichData:"score"))"
        
        let message = messageToBeSent.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        do{
            try self.mcSession.send(message!, toPeers: self.mcSession.connectedPeers, with: .reliable)
        }
        
        catch{
            print("Error sending message")
        }
        
    }
    
    
    func retrieveHighestPlayer(whichData: String) -> String{
        player = realm.objects(scoreboardDataModel.self).sorted(byKeyPath: "scores", ascending: false)
        
        var retrievedData: String = ""
        
        if let thePlayer = player?[0]{
            
            if whichData == "name"{
                 retrievedData = thePlayer.name
            }
            
            else{
                let intoString = String(thePlayer.scores)
                retrievedData = intoString
            }
        }
        
        return retrievedData
    }
    
    
    
    // MARK: - MC Delegate Functions
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        //Checking state of connection
        switch state {
        case MCSessionState.connected:
            print("Connected to: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.connectedDevice.text = "Connected to: \(peerID.displayName)"
            }
            
        case MCSessionState.connecting:
            print("Connecting to: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
//            let playerInfo = try JSONDecoder().decode(dataTransfer.self, from: data)
//            DataManager.save(playerInfo, with: playerInfo.playerIdentifier.uuidString)
//
//            DispatchQueue.main.async {
//                self.gamePlayersInfo.append(playerInfo)
//            }
            
            DispatchQueue.main.async {
                
                self.messageReceived = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
                let splits = self.messageReceived.components(separatedBy: ":")
                self.otherPlayerRanking.text = "1"
                self.otherPlayerName.text = splits[0]
                self.otherPlayerScore.text = splits[1]
            }
            
        }
        catch {
                fatalError("Unable to process the received data")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }

}
