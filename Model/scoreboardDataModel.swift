//
//  scoreboardDataModel.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 09/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import Foundation
import RealmSwift

class scoreboardDataModel: Object{
    
    @objc dynamic var rank: Int = 0
    @objc dynamic var name : String = ""
    @objc dynamic var scores: Int = 0
}
