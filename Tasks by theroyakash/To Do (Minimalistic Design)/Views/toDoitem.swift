//
//  toDoitem.swift
//  To Do (Minimalistic Design)
//
//  Created by Roy Akash on 10/12/18.
//  Copyright © 2018 The Roy Akash Software, Company. All rights reserved.
//

import Foundation
struct toDoItem : Codable {
    var title:String
    var completed:Bool
    var createdAt:Date
    var itemIdentifier:UUID
    
    
    func saveItem(){
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    func deleteItem(){
        DataManager.delete(itemIdentifier.uuidString)
    }
    
    mutating func markAsCompleted(){
        self.completed = true
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
}
