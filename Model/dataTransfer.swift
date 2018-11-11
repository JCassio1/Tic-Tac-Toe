//
//  dataTransfer.swift
//  Tic Tac Toe
//
//  Created by MR.Robot 💀 on 11/11/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import Foundation
import CloudKit

struct dataTransfer : Codable {

    var nameOfPlayer:String
    var maxScore:Int
    var playerIdentifier:UUID


func saveItem() {
    DataManager.save(self, with: "\(playerIdentifier.uuidString)")
}

func deleteItem() {
    DataManager.delete(playerIdentifier.uuidString)
}
}
