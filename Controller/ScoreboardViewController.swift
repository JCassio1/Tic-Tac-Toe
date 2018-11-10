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
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    let scores = ["1                          Joselson                250",
                  "2                          Michael                 350",
                  "3                          Jonathan                350"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(scores.count)
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = scores[indexPath.row]
        
        return(cell)
    }
    


    func loadRankings(){
        
        
        
    }

}
