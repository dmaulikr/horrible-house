//
//  House.swift
//  horrible house
//
//  Created by TerryTorres on 2/10/16.
//  Copyright © 2016 Terry Torres. All rights reserved.
//

import UIKit

class House {
    struct RoomType {
        static let noRoom = 0
        static let normal = 1
        static let foyer = 2
        static let stairsDownToBasement = 3
        static let stairsUpToFirst = 4
    }
    
    
    enum Direction: String {
        case North, South, East, West
    }
    
    
    // MARK: Properties
    var width = 0
    var height = 0
    var depth = 0
    
    // Array for all rooms in the Rooms.plist
    var rooms: [Room] = []
    // Array for all events in the Rooms.plist
    var events: [Event] = []
    
    // MARK: Characters
    var player = Character(name: "Player", position: (0,0,0))
    var npcs:[Character] = []
    
    // MARK: Navigation
    var layout = [[[Int]]]()
    var map = [[[Room]]]()
    
    var currentFloor = [[Room]]()
    
    
    // MARK: Room Templates
    
    var noRoom = Room()
    var foyer = Room()
    var stairsDownToBasement = Room()
    var stairsUpToFirst = Room()
    
    // The room that is being presented for exploration.
    // This will be set by the game controllers.
    var currentRoom = Room()
    // The event that is being presented for interaction.
    // This will be set by the game controllers.
    var currentEvent = Event()
    
    
    init(layout:[[[Int]]]) {
        self.layout = layout.reverse()
        
        // Reverse each floor's layout so that north and south make sense
        var i = 0
        for _ in self.layout {
            self.layout[i] = self.layout[i].reverse()
            i++
        }
        self.setNecessaryRooms()
        self.loadEvents()
        self.loadRooms()
        self.drawMap()
    }
    
    // MARK: Setup Functions
    
    func loadRooms() {
        let path = NSBundle.mainBundle().pathForResource("Rooms", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!) as! Dictionary<String,AnyObject>
        
        for (_, value) in dict {
            let room = Room(withDictionary: value as! Dictionary<String,AnyObject>)
            self.rooms += [room]
        }
    }
    
    func loadEvents() {
        let path = NSBundle.mainBundle().pathForResource("Events", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!) as! Dictionary<String,AnyObject>
        
        for (_, value) in dict {
            let event = Event(withDictionary: value as! Dictionary<String,AnyObject>)
            self.events += [event]
        }
    }
    
    func setNecessaryRooms() {
        // Initialize from NecessaryRooms.plist
        let path = NSBundle.mainBundle().pathForResource("NecessaryRooms", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!) as! Dictionary<String,AnyObject>
        
        for (_,value) in dict {
            let room = Room(withDictionary: value as! Dictionary<String,AnyObject>)
            if room.name == "Foyer" { self.foyer = room }
            if room.name == "No Room" { self.noRoom = room }
            if room.name == "Basement Stairs" { self.stairsDownToBasement = room }
            if room.name == "Basement Landing" { self.stairsUpToFirst = room }
        }

    }
    
    // Pre-fill the floor with noRooms to make it easier to change the rooms later.
    func prepopulatedFloor(withDimensions width: Int, height: Int, depth: Int) -> [[Room]] {
        print("Prepopulating map...\r")
        var floor = [[Room]]()
        
            for( var y = 0; y < height; y++ ) {
                var row = [Room]()
                for( var x = 0; x < width; x++ ) {
                    row.append(self.noRoom)
                } // end of x for loop
                floor.append(row)
            } // end of y for loop
        
        return floor
    }
    
    
    func drawMap() {
        print("Drawing map of house...\r")
        
        // Ideally, all of the rows should be the same count. We'll see.
        let width = self.layout[0][0].count
        let height = self.layout[0].count
        let depth = self.layout.count
        
        self.width = width
        self.height = height
        self.depth = depth
        
        print("width is \(width)")
        print("height is \(height)")
        print("depth is \(depth)")
        
        var floor = prepopulatedFloor(withDimensions: width, height: height, depth: depth)
        
        var roomIndex = 0
        
        for var z = 0; z < depth; z++ {
            for( var y = 0; y < height; y++ ) {
                for( var x = 0; x < width; x++ ) {
                    print("\(x) \(y) \(z)")
                    // Draw the room
                    switch ( self.layout[z][y][x] ) {
                    case RoomType.foyer:
                        self.foyer.position = (x:x, y:y, z:z)
                        floor[y][x] = self.foyer
                        print("\(self.foyer.name) is at position \(self.foyer.position)")
                    case RoomType.stairsDownToBasement:
                        self.stairsDownToBasement.position = (x:x, y:y, z:z)
                        floor[y][x] = self.stairsDownToBasement
                        print("\(self.stairsDownToBasement.name) is at position \(self.stairsDownToBasement.position)")
                    case RoomType.stairsUpToFirst:
                        self.stairsUpToFirst.position = (x:x, y:y, z:z)
                        floor[y][x] = self.stairsUpToFirst
                        print("\(self.stairsUpToFirst.name) is at position \(self.stairsUpToFirst.position)")
                    case RoomType.noRoom:
                        floor[y][x] = self.noRoom
                    default:
                        self.rooms[roomIndex].position = (x:x, y:y, z:z)
                        let room = self.rooms[roomIndex]
                        floor[y][x] = room
                        print("\(room.name) is at position \(room.position)")
                        roomIndex++
                    }
                    floor[y][x].position = (x:x, y:y, z:z)
                    print("End of x for loop.\r")
                } // end of x for loop
                if roomIndex > self.rooms.count {
                    print("roomIndex is \(roomIndex)")
                    // break
                }
                print("End of y for loop.\r")
            } // end of y for loop
            self.map += [floor]
            floor = prepopulatedFloor(withDimensions: width, height: height, depth: depth)
        } // end of z for loop
        
        
    }
    
    
    // MARK: Game Functions
    
    func roomForName(name: String) -> Room? {
        var room = self.noRoom
        for r in self.rooms {
            if r.name == name {
                room = r
            }
        }
        return room
    }
    
    func eventForName(name: String) -> Event? {
        var event = Event()
        for e in self.events {
            if e.name == name {
                event = e
            }
        }
        return event
    }
    
    
    // Get a room in the house for a set of x and y coordinates.
    func roomForPosition(position:(x: Int, y: Int, z: Int)) -> Room? {
        var room = self.noRoom
        if ( position.z >= 0 && position.z < self.layout.count) {
            let floor = self.layout[position.z]
            if ( position.y >= 0 && position.y < floor.count ) {
                let row = floor[position.y]
                if ( position.x >= 0 && position.x < row.count ) {
                    room = self.map[position.z][position.y][position.x]
                }
            }
        }
        
        return room
    }
    
    // Get the x, y position for a room in the house based on its name.
    func positionForRoom(room: Room) -> (x: Int, y: Int, z:Int)? {
        var position = (x: 0, y: 0, z:0)
        for r: Room in self.rooms {
            if r.name == room.name {
                position = r.position
            }
        }
        return position
    }
    
    // Checks if room exists at position
    // Used to maintain the bounds of the house, so the player does not end up in a wall or outside.
    func doesRoomExistAtPosition(position:(x: Int, y: Int, z:Int)) -> Bool {
        let room = roomForPosition(position)
        if ( room!.name == "No Room" || position.y < 0 || position.x < 0 || position.x >= self.width || position.y >= self.height ) {
            return false
        } else {
            return true
        }
    }
    
    // Get get a room in a direction adjacent to the player
    // Used to find out what the room is before entering it.
    func roomInDirection(direction:Direction) -> Room? {
        var potentialPosition = (x: self.player.position.x, y: self.player.position.y, z: self.player.position.z)
        switch direction {
        case .North:
            potentialPosition.y += 1
        case .South:
            potentialPosition.y -= 1
        case .East:
            potentialPosition.x += 1
        case .West:
            potentialPosition.x -= 1
        }
        
        // This makes sure that the new position is within the layout of the house
        // If it's not, the player's position stays as it is,
        // and the player's current room is returned.
        if ( doesRoomExistAtPosition(potentialPosition) == false ) {
            potentialPosition = self.player.position
        }
        let potentialRoom = roomForPosition(potentialPosition)
        
        return potentialRoom
    }
    
    // Find out what direction a room is in, based on the player's position.
    // Currently used to output directions the player can move in,
    // which in turns is vital for actually moving the player in that direction.
    func directionForRoom(room:Room) -> Direction {
        var d = Direction.North
        if room.position.x < self.player.position.x {
            d = Direction.West
        } else if room.position.x > self.player.position.x {
            d = Direction.East
        } else if room.position.y < self.player.position.y {
            d = Direction.South
        } else if room.position.y > self.player.position.y {
            d = Direction.North
        }
        return d
    }
    
    // Checks for rooms around house.playerPosition
    // Needed to output the number of directions the player can actually move in,
    // which is necessary for navigation and the tableview display itself.
    func getRoomsAroundPlayer() -> [Room] {
        var roomsAroundPlayer = [Room]()
        let roomPositionToNorth = (self.player.position.x, self.player.position.y+1, self.player.position.z)
        let roomPositionToWest = (self.player.position.x-1, self.player.position.y, self.player.position.z)
        let roomPositionToSouth = (self.player.position.x, self.player.position.y-1, self.player.position.z)
        let roomPositionToEast = (self.player.position.x+1, self.player.position.y, self.player.position.z)
        if ( doesRoomExistAtPosition(roomPositionToNorth) ) {
            roomsAroundPlayer.append(roomForPosition(roomPositionToNorth)!)
        }
        if ( doesRoomExistAtPosition(roomPositionToWest) ) {
            roomsAroundPlayer.append(roomForPosition(roomPositionToWest)!)
        }
        if ( doesRoomExistAtPosition(roomPositionToSouth) ) {
            roomsAroundPlayer.append(roomForPosition(roomPositionToSouth)!)
        }
        if ( doesRoomExistAtPosition(roomPositionToEast) ) {
            roomsAroundPlayer.append(roomForPosition(roomPositionToEast)!)
        }
        
        return roomsAroundPlayer
    }
    
    func moveCharacter(withName name:String, toRoom room:Room) {
        room.timesEntered++
        if name == "player" {
            self.player.position = room.position
            self.currentRoom = room
        } else {
            for var i = 0; i < self.npcs.count; i++ {
                if self.npcs[i].name == name {
                    self.npcs[i].position = room.position
                }
            }
        }
        
    }
    
}