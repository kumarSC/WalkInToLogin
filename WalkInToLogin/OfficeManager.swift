//
//  RoomManager.swift
//  WalkinOrLogin
//
//  Created by Vu Tung on 12/10/15.
//  Copyright © 2015 Atlassian. All rights reserved.
//

import Foundation

typealias RoomID = UInt16
typealias OfficeID = UInt16

var SharedOfficeManager = OfficeManager(officeID: 12345)
class OfficeManager {
    private var office: Office!
    init(officeID id: OfficeID) {
        office = Office(id: id)
    }
    
    func watchRoom(id: RoomID) {
        
    }
    
    func unwatchRoom(id: RoomID) {
        
    }
    
    func enterRoom(id: RoomID) {
        SharedPubNubManager.sendMessage("in", channel: ChannelsIDs[0])
    }
    
    func exitRoom(id: RoomID) {
        
    }
    
    func room(id: RoomID) -> Room? {
        return office.room(id)
    }
}

class Office {
    let id: OfficeID
    var rooms = [Room]()
    init(id theID: OfficeID) {
        id = theID
        rooms.appendContentsOf([Room(id: 21, name: "2.1"), Room(id: 22, name: "2.2"), Room(id: 23, name: "2.3"), Room(id: 24, name: "2.4"), Room(id: 25, name: "2.5")])
    }
    func room(id: RoomID) -> Room? {
        for room in rooms {
            if room.id == id {
                return room
            }
        }
        return nil
    }
}

class Room {
    let id: RoomID
    var name: String
    init(id theId: RoomID, name theName: String) {
        id = theId
        name = theName
    }
}