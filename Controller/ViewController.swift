//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 06/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var soundSetting = ""
    
    var playerOneName = ""
    var playerTwoName = ""
    var playerPlaying = 1 //current active player
    var gameStatus = [0,0,0,0,0,0,0,0,0]
    let winningPossibilities = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    var activeGame = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if playerOneName.isEmpty == false {
            gameTopLabel.text = "\(playerOneName) playing!"
        }
            
        else{
            gameTopLabel.text = "Player 1 playing!"
        }
    }
    
    
    //Check if user set sound On or Off
    func checkSound() -> String {
        let sound = UserDefaults.standard.string(forKey: "soundOption")
        
        return sound!
    }
    
    
    @IBOutlet weak var gameTopLabel: UILabel!
    
    // X and O Button in table
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        soundSetting = checkSound()
        
        if soundSetting == "On"{
        playSound()
            
            print("Play() Sound setting is \(soundSetting)")
        }
        
        else {
            print("Sound setting is \(soundSetting)")
        }
        
        if (gameStatus[sender.tag-1] == 0 && activeGame == true) {
            
            gameStatus[sender.tag-1] = playerPlaying
            
            if (playerPlaying == 1){
                sender.setImage(UIImage(named: "cross"), for: UIControl.State())
                playerPlaying = 2
                if playerTwoName.isEmpty == false {
                    gameTopLabel.text = "\(playerTwoName) playing!"
                }
                    
                else{
                    gameTopLabel.text = "Player 2 playing"
                }
            }
                
            else{
                sender.setImage(UIImage(named: "circle"), for: UIControl.State())
                playerPlaying = 1
                if playerOneName.isEmpty == false {
                    gameTopLabel.text = "\(playerOneName) playing!"
                }
                    
                else{
                    gameTopLabel.text = "Player 1  playing"
                }
            }
            
        }
        
        for possibilities in winningPossibilities
        {
            
            if (gameStatus[possibilities[0]] != 0 && gameStatus[possibilities[0]] == gameStatus[possibilities[1]] && gameStatus[possibilities[1]] == gameStatus[possibilities[2]])
            {
                activeGame = false
                
                if gameStatus[possibilities[0]] == 1
                {
                    if playerOneName.isEmpty == false {
                        gameTopLabel.text = "\(playerOneName) won!"
                    }
                    
                    else{
                        gameTopLabel.text = "Player 1 won!"
                    }
                }
                
                else{
                    if playerTwoName.isEmpty == false {
                        gameTopLabel.text = "\(playerTwoName) won!"
                    }
                        
                    else{
                        gameTopLabel.text = "Player 2 won!"
                    }
                }
                
                
                restart.isHidden = false
                gameTopLabel.isHidden = false
                
            }
            
        }
        
        activeGame = false
        
        for i in gameStatus{
            if i == 0{
                activeGame = true
                break
            }
        }
        
        if activeGame == false
        {
            gameTopLabel.text = "Oops.. Draw!"
            gameTopLabel.isHidden = false
            restart.isHidden = false
        }
    }
    
    
    @IBOutlet weak var restart: UIButton! //Restart outlet (Code to UI)
    
    @IBAction func restartGame(_ sender: Any) { //Restart action (UI to code)
        
        gameStatus = [0,0,0,0,0,0,0,0,0]
        activeGame = true
        playerPlaying = 1
        
        if playerOneName.isEmpty == false {
        gameTopLabel.text = "\(playerOneName) playing!"
        }
        
        else{
            gameTopLabel.text = "Player 1 playing!"
        }
        
        for i in 1...9{ //reset game
            let buttonPressed = view.viewWithTag(i) as! UIButton
            buttonPressed.setImage(nil, for: UIControl.State())
        }
    }
    
    func playSound(){
        
        let soundURL = Bundle.main.url(forResource: "screenTap", withExtension: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
            
        catch{
            print(error)
        }
        
        audioPlayer.play()
    }
}

