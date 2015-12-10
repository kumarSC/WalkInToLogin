//
//  PubNubManager.swift
//  WalkInToLogin
//
//  Created by Vu Tung on 12/10/15.
//  Copyright © 2015 Sushant Choudhary. All rights reserved.
//

import Foundation
import PubNub

let ChannelsIDs: [String] = [
    "com.atlassian.walkintologin_\(2)_\(1)",
    "com.atlassian.walkintologin_\(2)_\(2)"
]

let SharedPubNubManager = PubNubManager()
class PubNubManager: NSObject, PNObjectEventListener {
    var client: PubNub!
    
    func instantiatePubNub() {
        let config = PNConfiguration(publishKey: "pub-c-96d69393-2a7b-4cb9-8512-b2f658ff6575", subscribeKey: "sub-c-c235e5ec-9f04-11e5-9a49-02ee2ddab7fe")
        client = PubNub.clientWithConfiguration(config)
        client.addListener(self)
        subscribeToAllChannels()
    }

    func subscribeToAllChannels() {
        client.subscribeToChannels(ChannelsIDs, withPresence: true)
    }
    
    func sendMessage(message: String, channel: String) {
        client.publish(message, toChannel: channel, compressed: true) { (status) -> Void in
            print("published")
        }
    }
    
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        print("Recieved: \(message)")
    }
    func client(client: PubNub!, didReceivePresenceEvent event: PNPresenceEventResult!) {
        
    }
    func client(client: PubNub!, didReceiveStatus status: PNStatus!) {
        
    }
}