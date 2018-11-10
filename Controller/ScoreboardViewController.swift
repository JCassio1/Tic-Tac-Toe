//
//  ScoreboardViewController.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 09/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import RealmSwift


class ScoreboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rankPosition = 0
    
    @IBOutlet weak var rankingTable: UITableView!
    
    let realm = try! Realm()
    
    var players: Results<scoreboardDataModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRankings()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return(scores.count)
        return players?.count ?? 1
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
//        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
//        cell.textLabel?.text = scores[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        if let allPlayers = players?[indexPath.row]{

            
            //Obtain row number for scoreboard
            let playerRank = indexPath.row + 1

            
            cell.textLabel?.text = "\(playerRank)                          \(allPlayers.name)                         \(allPlayers.scores)"
        }

        
        return(cell)
    }
    

    func loadRankings(){
        
        players = realm.objects(scoreboardDataModel.self)

        rankingTable.reloadData()
    }

}
