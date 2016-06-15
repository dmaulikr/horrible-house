//
//  RuleBased.swift
//  horrible house
//
//  Created by TerryTorres on 3/22/16.
//  Copyright © 2016 Terry Torres. All rights reserved.
//

import Foundation
import UIKit

protocol RuleBased : class {
    var rules : [Rule] { get set }
}

extension RuleBased {
    func setRulesForArray(array:[String]) {
        for ruleName in array {
            let rule = Rule(name: ruleName)
            self.rules += [rule]
        }
    }
    
    
    func isFollowingTheRules() -> Bool {
        var rulesFollowed = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let house = appDelegate.house
        
        for rule in rules {
            switch ( rule.type) {
                
            case Rule.RuleType.hasItem:
                rulesFollowed = false
                if let _ = house.player.items.indexOf({$0.name == rule.name}) {
                    print("RULEBASED – player does NOT have \(rule.name)")
                    rulesFollowed = true
                }
                
            case Rule.RuleType.nopeHasItem:
                rulesFollowed = true
                if let _ = house.player.items.indexOf({$0.name == rule.name}) {
                    print("RULEBASED – player DOES have \(rule.name)")
                    rulesFollowed = false
                }
                
            case Rule.RuleType.metCharacter:
                break
            case Rule.RuleType.nopeMetCharacter:
                break
            case Rule.RuleType.enteredRoom:
                var i = 0; for room in house.rooms {
                    if room.timesEntered > 0 { i += 1 }
                }; if i == 0 { rulesFollowed = false }
            case Rule.RuleType.nopeEnteredRoom:
                var i = 0; for room in house.rooms {
                    if room.timesEntered == 0 { i += 1 }
                }; if i == 0 { rulesFollowed = false }
            case Rule.RuleType.completedEvent:
                if let index = house.events.indexOf({$0.name == rule.name}) {
                    if house.events[index].completed == false {
                        rulesFollowed = false
                    }
                }
                break
            case Rule.RuleType.nopeCompletedEvent:
                if let index = house.events.indexOf({$0.name == rule.name}) {
                    if house.events[index].completed == true {
                        rulesFollowed = false
                    }
                }
                break
            case Rule.RuleType.inRoomWithCharacter:
                print("RULEBASED – RuleType:  inRoomWithCharacter")
                if let index = house.currentRoom.characters.indexOf({$0.name == rule.name}) {
                    let character = house.currentRoom.characters[index]
                    if character.hidden == true {
                        rulesFollowed = false
                    }
                } else {
                    print("RULEBASED – player is NOT in room with \(rule.name)")
                    rulesFollowed = false
                }
                break
            case Rule.RuleType.nopeInRoomWithCharacter:
                print("RULEBASED – RuleType:  nopeInRoomWithCharacter")
                if let _ = house.currentRoom.characters.indexOf({$0.name == rule.name}) {
                    print("RULEBASED – player IS in room with \(rule.name)")
                    rulesFollowed = false
                }
                break
            default:
                break;
            }
        }
        
        return rulesFollowed
    }
    
}