//
//  Room.swift
//  horrible house
//
//  Created by TerryTorres on 2/10/16.
//  Copyright © 2016 Terry Torres. All rights reserved.
//

import UIKit

class Room: DictionaryBased, ItemBased, ActionPacked, Detailed, Inhabitable {
    
    var name = ""
    var explanation = ""
    var details: [Detail] = []
    var actions: [Action] = []
    var position = (x: 0, y: 0, z: 0)
    var timesEntered = 0
    var characters: [Character] = []
    var items: [Item] = []
    var placementGuidelines: Dictionary<String, AnyObject>?
    var isInHouse = false
    
    required init(withDictionary: Dictionary<String, AnyObject>) {
        for (key, value) in withDictionary {
            if key == "name" { self.name = value as! String }
            if key == "explanation" { self.explanation = value as! String }
            if key == "details" { self.setDetailsForArrayOfDictionaries(value as! [Dictionary<String, AnyObject>]) }
            if key == "actions" { self.setActionsForArrayOfDictionaries(value as! [Dictionary<String, AnyObject>]) }
            if key == "items" { self.setItemsForDictionary(value as! [Dictionary<String, AnyObject>]) }
            if key == "characters" { self.setCharactersForDictionary(value as! [Dictionary<String, AnyObject>]) }
            if key == "placementGuidelines" {
                self.placementGuidelines = value as? Dictionary<String, AnyObject>
            }
        }
    }
    
    init() {
        
    }

}
