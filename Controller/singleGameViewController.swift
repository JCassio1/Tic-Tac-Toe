//
//  singleGameViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 14/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import AVFoundation

class singleGameViewController: UIViewController {

    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    
    @IBOutlet weak var whosPlaying: UILabel!
    
    let winningPossibilities = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    
    var playerOneMoves = Set<Int>()
    var playerTwoMoves = Set<Int>()
    var PossibleMoveSpace = Array<Int>()
    var nextMove: Int? = nil
    var playerTurn = 1
    var allSpaces: Set<Int> = [1,2,3,4,5,6,7,8,9]
    
    
    var soundSetting: Bool = true
    var audioPlayer: AVAudioPlayer!
    
    var nameOfPlayer: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }
    

    @IBAction func restartGame(_ sender: Any) {
        newGame()
    }
    
    //Check if user set sound On or Off
    func checkSound() -> Bool {
        let sound: Bool = UserDefaults.standard.bool(forKey: "soundOption") ?? true
        
        return sound
    }
    
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        soundSetting = checkSound()
        
        if soundSetting == true {
            playSound(soundname: "screenTap")
        }
        
        if playerOneMoves.contains(sender.tag) || playerTwoMoves.contains(sender.tag) {
            whosPlaying.text = "Space already played!"
        }
        
        else{
            
            if playerTurn % 2 != 0 {
                
                playerOneMoves.insert(sender.tag)
                sender.setImage(UIImage(named: "cross"), for: UIControl.State())
                whosPlaying.text = "Player 2 turn!"
                
                print("Player 2 gonna play")
                
                if isWinner(player: 1) == 0{
                    
                    let nextMove = playDefense()
                    print("Sent player 2 command to play. Will play at position \(nextMove)")
                    playerTwoMoves.insert(nextMove)
                    
                    let button = self.view.viewWithTag(nextMove) as! UIButton
                    button.setImage(UIImage(named: "circle"), for: UIControl.State())
                    
                    whosPlaying.text = "\(nameOfPlayer)'s turn"
                    
                    isWinner(player: 2)
                }
            }
            
            playerTurn =  playerTurn + 1
            
            if playerTurn > 9 && isWinner(player: 1) < 1 {
                whosPlaying.text = "Oops.. It's a Draw"
                for index in 1...9{
                    let button = self.view.viewWithTag(index) as! UIButton
                    button.isEnabled = false
                }
            }
        }
    }
    
    
    func newGame(){
        
        //clear move list
        playerOneMoves.removeAll()
        playerTwoMoves.removeAll()
        
        for index in 1...9{
            let tile = self.view.viewWithTag(index) as! UIButton
            tile.isEnabled = true
        }
        
        for i in 1...9{ //reset game
            let buttonPressed = view.viewWithTag(i) as! UIButton
            buttonPressed.setImage(nil, for: UIControl.State())
        }
        
        playerTurn = 1
        
    }
    
    
    
    func isWinner(player: Int) -> Int{
        
        var winner = 0
        var moveList = Set<Int>()
        
        
        if player == 1{
            moveList = playerOneMoves
        }
        
        else{
            moveList = playerTwoMoves
        }
        
        for combo in winningPossibilities {
            
            if moveList.contains(combo[0]) && moveList.contains(combo[1]) && moveList.contains(combo[2]) && moveList.count > 2 {
                
                winner = player
                whosPlaying.text = "Player \(nameOfPlayer) has won the game!"
                
                for index in 1...9{
                    let tile = self.view.viewWithTag(index) as! UIButton
                    tile.isEnabled = false
                }
            }
        }
        
        return winner
    }
    
    
    
    
    func playDefense() -> Int{
        
        var possibleLoses = Array<Array<Int>>()
        var possibleWins = Array<Array<Int>>()
        let spacesLeft = allSpaces.subtracting(playerOneMoves.union(playerTwoMoves))
        
        for combo in winningPossibilities{
        
        var count = 0
        
        for play in combo{
            
            if playerOneMoves.contains(play){
                count = count + 1
            }
            
            if playerTwoMoves.contains(play){
                count = count - 1
            }
            
            if count == 2 {
                possibleLoses.append(combo)
                count = 0
            }
            
            if count == -2{
                possibleWins.append(combo)
                count = 0
            }
        }
    }
        
        if possibleWins.count > 0 {
            for combo in possibleWins{
                for space in combo{
                    if !(playerOneMoves.contains(space) || playerTwoMoves.contains(space)){
                        return space
                    }
                }
            }
        }
        
        if possibleLoses.count > 0 {
            
            for combo in possibleLoses{
                
                for space in combo {
                    if !(playerOneMoves.contains(space) || playerTwoMoves.contains(space)){
                        PossibleMoveSpace.append(space)
                    }
                }
            }
        }
        
        
        if PossibleMoveSpace.count > 0{
            
            nextMove = PossibleMoveSpace[Int(arc4random_uniform(UInt32(PossibleMoveSpace.count)))]
            
            let button = self.view.viewWithTag(nextMove!) as! UIButton
            button.setImage(UIImage(named: "circle"), for: UIControl.State())
            
            print("Inside AI Move")
        }

        else
        {
            if allSpaces.subtracting(playerOneMoves.union(playerTwoMoves)).count > 0{
            nextMove = spacesLeft[spacesLeft.index(spacesLeft.startIndex, offsetBy: Int(arc4random_uniform(UInt32(spacesLeft.count))))]
            }
        }
        
        PossibleMoveSpace.removeAll()
        possibleLoses.removeAll()
        possibleWins.removeAll()
        playerTurn = playerTurn + 1
        return nextMove!
    }
    
    
    
    func playSound(soundname: String){
        
        let soundURL = Bundle.main.url(forResource: soundname, withExtension: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
            
        catch{
            print(error)
        }
        
        audioPlayer.play()
    }
    
}
