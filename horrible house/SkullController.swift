//
//  SkullController.swift
//  horrible house
//
//  Created by TerryTorres on 5/2/16.
//  Copyright © 2016 Terry Torres. All rights reserved.
//

import Foundation
import UIKit


// The skull has Ideas, which are basically Details but with more sass.

class Idea {
    var detail = Detail()
    var isHighPriority = false
    
    init(withDictionary: Dictionary<String, AnyObject>) {
        for (key, value) in withDictionary {
            if key == "detail" { self.detail = Detail(withDictionary: value as! Dictionary<String, AnyObject>) }
            if key == "isHighPriority" { self.isHighPriority = true }
        }
    }
}

class SkullController: UIViewController {
    
    var house : House = (UIApplication.sharedApplication().delegate as! AppDelegate).house
    var skull : Skull = (UIApplication.sharedApplication().delegate as! AppDelegate).house.skull
    @IBOutlet var ideaLabel: UILabel!
    
    override func viewDidLoad() {
        
        
    }
    
    func addTestItems() {
        // let itemA = Item()
        // itemA.name = "Bandage"
        // self.house.player.items += [itemA]
    }
    
    
    @IBAction func displayIdea(sender: AnyObject) {
        if self.skull.ideasToSayAloud.count > 0 {
            let index = self.skull.ideasToSayAloud.count - 1
            self.ideaLabel.text = self.skull.ideasToSayAloud[index].detail.explanation
            
            print("removing from ideasToSayAloud: \(self.skull.ideasToSayAloud[index].detail.explanation)")
            
            self.skull.ideasToSayAloud.removeAtIndex(index)
        } else {
            self.ideaLabel.text = ""
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.house = (UIApplication.sharedApplication().delegate as! AppDelegate).house
        self.skull = (UIApplication.sharedApplication().delegate as! AppDelegate).house.skull
        

    }
    
    override func viewWillDisappear(animated: Bool) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).house = self.house
        (UIApplication.sharedApplication().delegate as! AppDelegate).house.skull = self.skull
    }

}
