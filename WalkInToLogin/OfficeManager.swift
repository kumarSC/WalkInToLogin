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
        // For Demo. Default to watch all room
    }
    
    func unwatchRoom(id: RoomID) {
        // For Demo. Default to watch all room
    }
    
    func enterRoom(id: RoomID) {
        let message = [
            "presenceEvent": "join",
            "userID": SharedUserManager.currentUser.id
        ]
        SharedPubNubManager.sendMessage(message, channel: Room.channelIDFromRoomID(id), presenceEvent: .Join)
    }
    
    func exitRoom(id: RoomID) {
        let message = [
            "presenceEvent": "leave",
            "userID": SharedUserManager.currentUser.id
        ]
        SharedPubNubManager.sendMessage(message, channel: Room.channelIDFromRoomID(id), presenceEvent: .Leave)
    }
    
    func rooms() -> [Room] {
        return office.rooms
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
    
    func users(completion: ([User]) -> Void) {
//        return testUsers;
        
        SharedPubNubManager.userIDsInChannel(Room.channelIDFromRoomID(id)) {
            userIDs in
            let users = userIDs.flatMap { (id) -> User? in
                SharedUserManager.userWithID(id)
            }
            completion(users)
        }
    }
    
    // MARK: - Helpers
    static func channelIDFromRoomID(id: RoomID) -> String {
        // TODO: do this
        return  "com.atlassian.walkintologin_\(id)"
    }
}