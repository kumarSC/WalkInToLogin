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
    var client: PubNub?
    
    func instantiatePubNub() {
        if client == nil {
            let config = PNConfiguration(publishKey: "pub-c-96d69393-2a7b-4cb9-8512-b2f658ff6575", subscribeKey: "sub-c-c235e5ec-9f04-11e5-9a49-02ee2ddab7fe")
            client = PubNub.clientWithConfiguration(config)
            client!.addListener(self)
            subscribeToAllChannels()
        }
    }

    func enablePushNotification(devicePushToken: NSData) {
        SharedPubNubManager.instantiatePubNub()
        self.client?.pushNotificationEnabledChannelsForDeviceWithPushToken(devicePushToken,
            andCompletion: { (result, status) -> Void in
                
                if status == nil {
                    
                    // Handle downloaded list of channels using: result.data.channels
                    print("push works")
                }
                else {
                    
                    print("push failed")
                    // Handle audition error. Check 'category' property
                    // to find out possible reason because of which request did fail.
                    // Review 'errorData' property (which has PNErrorData data type) of status
                    // object to get additional information about issue.
                    //
                    // Request can be resent using: status.retry()
                }
        })
    }
    
    // Publish
    func sendMessage(message: String, channel: String) {
        let payload = [
            "aps" : [
                "alert" : "Some one entered room \(channel)",
                "badge" : 1,
            ],
        ]
        client?.publish(message, toChannel: channel, mobilePushPayload: payload, compressed: true) { (status) -> Void in
            if !status.error {
                print("published")
            } else {
                status.category
            }
        }
    }
    
    // Subcribe
    func subscribeToAllChannels() {
//        client.subscribeToChannels(ChannelsIDs, withPresence: true, usingTimeToken: 1, clientState: [])
        client?.subscribeToChannels(ChannelsIDs, withPresence: true)
    }
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        
        // Handle new message stored in message.data.message
        if message.data.actualChannel != nil {
            
            // Message has been received on channel group stored in
            // message.data.subscribedChannel
        }
        else {
            
            // Message has been received on channel stored in
            // message.data.subscribedChannel
        }
        
        print("Received message: \(message.data.message) on channel " +
            "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
            "\(message.data.timetoken)")
    }
    
    // New presence event handling.
    func client(client: PubNub!, didReceivePresenceEvent event: PNPresenceEventResult!) {
        
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout,
        // state-change).
        if event.data.actualChannel != nil {
            
            // Presence event has been received on channel group stored in
            // event.data.subscribedChannel
        }
        else {
            
            // Presence event has been received on channel stored in
            // event.data.subscribedChannel
        }
        
        if event.data.presenceEvent != "state-change" {
            
            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) " +
                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
        else {
            
            print("\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) " +
                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) to:\n" +
                "\(event.data.presence.state)");
        }
    }
    
    // Handle subscription status change.
    func client(client: PubNub!, didReceiveStatus status: PNStatus!) {
        
        if status.category == .PNUnexpectedDisconnectCategory {
            
            // This event happens when radio / connectivity is lost
        }
        else if status.category == .PNConnectedCategory {
            
            // Connect event. You can do stuff like publish, and know you'll get it.
            // Or just use the connected event to confirm you are subscribed for
            // UI / internal notifications, etc
            
            // Select last object from list of channels and send message to it.
            let targetChannel = client.channels().last as! String
            client.publish("Hello from the PubNub Swift SDK", toChannel: targetChannel,
                compressed: false, withCompletion: { (status) -> Void in
                    
                    if !status.error {
                        
                        // Message successfully published to specified channel.
                    }
                    else{
                        
                        print("error: \(status.errorData.description)")
                        // Handle message publish error. Check 'category' property
                        // to find out possible reason because of which request did fail.
                        // Review 'errorData' property (which has PNErrorData data type) of status
                        // object to get additional information about issue.
                        //
                        // Request can be resent using: status.retry()
                    }
            })
        }
        else if status.category == .PNReconnectedCategory {
            
            // Happens as part of our regular operation. This event happens when
            // radio / connectivity is lost, then regained.
        }
        else if status.category == .PNDecryptionErrorCategory {
            
            // Handle messsage decryption error. Probably client configured to
            // encrypt messages and on live data feed it received plain text.
        }
    }
}