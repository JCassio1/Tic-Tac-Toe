//
//  sharingPlayerStatsViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 11/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class sharingPlayerStatsViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var gamePlayersInfo:[dataTransfer]!
    
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    
    
    @IBOutlet weak var otherPlayerName: UILabel!
    @IBOutlet weak var OtherPlayerHighestScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConnectivity()
    }
    
    func setupConnectivity(){
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    func shareRequest(){
        let todoItem = gamePlayersInfo.capacity
            //sendPlayerStat(todoItem)
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
    
    
    
    @IBAction func shareButton(_ sender: Any) {
        
        //Actions sheet displays a list of options vertically (popup)
        
         let actionSheet = UIAlertController(title: "Stats Sharing", message: "Do you wish to share your stats or see from others?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Share My Stats", style: .default, handler: { (action:UIAlertAction) in
            
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "See From Others", style: .default, handler: { (action:UIAlertAction) in
            let mcBrowser = MCBrowserViewController(serviceType: "ba-td", session: self.mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    // MARK: - MC Delegate Functions
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        //Checking state of connection
        switch state {
        case MCSessionState.connected:
            print("Connected to: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting to: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let playerInfo = try JSONDecoder().decode(dataTransfer.self, from: data)
            DataManager.save(playerInfo, with: playerInfo.playerIdentifier.uuidString)
            
            DispatchQueue.main.async {
                self.gamePlayersInfo.append(playerInfo)
                
//                let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
//
//                self.tableView.insertRows(at: [indexPath], with: .automatic)
                
                
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
