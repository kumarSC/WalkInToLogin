//
//  ViewController.swift
//  WalkInToLogin
//
//  Created by Sushant Choudhary on 12/10/15.
//  Copyright © 2015 Sushant Choudhary. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

typealias BeaconID = UInt16

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    let majorInt = 9
    var major: UInt16!
    let minorInt = 6
    var minor: UInt16!
    let uuid = NSUUID(UUIDString: "0CF052C2-97CA-407C-84F8-B62AAC4E9020")
    var peripheralManager = CBPeripheralManager()
    var advertisedData = NSDictionary()

    let config = PNConfiguration(forOrigin:"com.atlassian.walkintologin", publishKey: "pub-c-96d69393-2a7b-4cb9-8512-b2f658ff6575", subscribeKey: "sub-c-c235e5ec-9f04-11e5-9a49-02ee2ddab7fe", secretKey:"sec-c-MzBhN2Y5MjYtMTYwZS00ZTRmLTg2NDgtMmYwYzg1YjQ2YWFj")
    var channel = PNChannel()



    override func viewDidLoad() {
        super.viewDidLoad()
        let region = CLBeaconRegion(proximityUUID: self.uuid!, major: self.major , minor: self.minor, identifier: "com.atlassian.walkintologin")
        self.advertisedData = region.peripheralDataWithMeasuredPower(nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)


        PubNub.setDelegate(self)
        PubNub.setConfiguration(self.config)
        PubNub.connect()
        channel = PNChannel.channelWithName("com.atlassian.walkintologin_\(minorInt)_\(majorInt)", shouldObservePresence: true) as PNChannel
        PubNub.subscribeOnChannel(self.channel)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case CBPeripheralManagerState.PoweredOn:
            self.peripheralManager.startAdvertising((self.advertisedData as! [String : AnyObject]))
        case CBPeripheralManagerState.PoweredOff:
            self.peripheralManager.stopAdvertising()
        default:
            print("Bluetooth Status: Unknown")

        }
    }

    func pubnubClient(client: PubNub!, didReceivePresenceEvent event: PNPresenceEvent!) {
        switch event.type.rawValue {
        case PNPresenceEventType.Join.rawValue:
            PubNub.sendMessage("Here we come!", toChannel: event.channel)


}

}

}