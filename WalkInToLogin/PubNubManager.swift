//
//  PubNubManager.swift
//  WalkInToLogin
//
//  Created by Vu Tung on 12/10/15.
//  Copyright © 2015 Sushant Choudhary. All rights reserved.
//

import Foundation
import PubNub

enum PresenceEvent {
    case Join
    case Leave
}

let ChannelsIDs: [String] = [
    "com.atlassian.walkintologin_\(21)",
    "com.atlassian.walkintologin_\(22)"
]

let presentSuffix = "-present"

var isSubscribed = false


let SharedPubNubManager = PubNubManager()
class PubNubManager: NSObject, PNObjectEventListener {
    var client: PubNub?
    
    // MARK: - Configuration
    func instantiatePubNub(refresh: Bool = false) {
        if client != nil && !refresh { return }
        //            let config = PNConfiguration(publishKey: "pub-c-96d69393-2a7b-4cb9-8512-b2f658ff6575", subscribeKey: "sub-c-c235e5ec-9f04-11e5-9a49-02ee2ddab7fe")
        let config = PNConfiguration(publishKey: "pub-c-0e3269fd-9b33-449b-b235-f730a760f206", subscribeKey: "sub-c-efa5f752-2c37-11e3-9343-02ee2ddab7fe")
        client = PubNub.clientWithConfiguration(config)
        config.uuid = SharedUserManager.currentUser.id
        self.client?.copyWithConfiguration(config, completion: { [weak self] (updatedClient) -> Void in
            self?.client = updatedClient
            self?.subscribeToAllChannels()
            self?.client?.addListener(self)
            })
    }

    func instantiateObserver() {
        let config = PNConfiguration(publishKey: "pub-c-96d69393-2a7b-4cb9-8512-b2f658ff6575", subscribeKey: "sub-c-c235e5ec-9f04-11e5-9a49-02ee2ddab7fe")
        client = PubNub.clientWithConfiguration(config)
        client!.addListener(self)
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
    
    // MARK: - Query
    func userIDsInChannel(channel: String, completion: ([String]) -> Void ){
        //TODO: todo query user subcribed to channel
        let presenceChannel = PubNubManager.presenceChannelFrom(channel)
        print("presenceChannel:\(presenceChannel)")
        client?.hereNowWithCompletion({ (result, status) -> Void in
            if status == nil {
                
                // Handle downloaded presence information using:
                //   result.data.channels - dictionary with active channels and presence
                //                          information on each. Each channel will have
                //                          next fields: "uuids" - list of subscribers;
                //                          "occupancy" - number of active subscribers.
                //                          Each uuids entry has next fields:
                //                          "uuid" - identifier and "state" if it has been
                //                          provided.
                //   result.data.totalChannels - total number of active channels.
                //   result.data.totalOccupancy - total number of active subscribers.
                print("totalOccupancy: \(result.data.totalOccupancy)")
            }
            else {
                
                // Handle presence audit error. Check 'category' property
                // to find out possible reason because of which request did fail.
                // Review 'errorData' property (which has PNErrorData data type) of status
                // object to get additional information about issue.
                //
                // Request can be resent using: status.retry()
            }
        })

        client?.hereNowForChannel(presenceChannel, withVerbosity: .UUID, completion: { (result, status) -> Void in
            if status == nil {
                
                // Handle downloaded presence information using:
                if let uuids = result.data.uuids as? [String] {
                    print("here now: \(uuids)")
                    completion(uuids)
                } else {
                    print("Error: uuids is not [String]")
                    completion([String]())
                }
                
                //   result.data.occupancy - total number of active subscribers.
                print("occupancy: \(result.data.occupancy)")
            }
            else {
                
                // Handle presence audit error. Check 'category' property
                // to find out possible reason because of which request did fail.
                // Review 'errorData' property (which has PNErrorData data type) of status
                // object to get additional information about issue.
                //
                // Request can be resent using: status.retry()
            }
        })
    }
    
    // MARK: - Publish
    func sendMessage(message: AnyObject, channel: String, presenceEvent: PresenceEvent) {
        client?.publish(message, toChannel: channel, mobilePushPayload: notificationPayloadToChannel(channel), compressed: true) { (status) -> Void in
            if !status.error {
                print("published")
            } else {
                status.category
            }
        }
        
        let presenceChannel = PubNubManager.presenceChannelFrom(channel)
        switch presenceEvent {
        case .Join:
            client?.subscribeToChannels([presenceChannel], withPresence: false)
        case .Leave:
            client?.unsubscribeFromChannels([presenceChannel], withPresence: false)
        }
    }
    
    func notificationPayloadToChannel(channel: String) -> [String: AnyObject] {
        return [
            "aps" : [
                "alert" : "Some one entered room \(channel)",
                "badge" : 1,
            ],
        ]
    }
    
    // MARK: - Subscribe
    // Subscribe

    func subscribeToAllChannels() {
        client?.subscribeToChannels(ChannelsIDs, withPresence: false)
//        client?.subscribeToChannels(ChannelsIDs, withPresence: false)
    }

    func unSubscribeFromAllChannels() {
        client?.unsubscribeFromChannels(ChannelsIDs, withPresence: true)
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
    
    // MARK: - Event handling.
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
            isSubscribed = false

            // This event happens when radio / connectivity is lost
        }
        else if status.category == .PNConnectedCategory {
            
            isSubscribed = true

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
    
    // MARK: - Helpers
    static func presenceChannelFrom(channel: String) -> String {
        return "\(channel)\(presentSuffix)"
    }
}