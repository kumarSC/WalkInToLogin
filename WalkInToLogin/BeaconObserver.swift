//
//  BeaconObserver.swift
//  WalkInToLogin
//
//  Created by Sushant Choudhary on 12/10/15.
//  Copyright © 2015 Sushant Choudhary. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth


let SharedBeaconObserver = Observer()

class Observer: NSObject, CLLocationManagerDelegate {

    var beaconRegion: CLBeaconRegion!
    var locationManager: CLLocationManager!
    var isSearchingForBeacons = false
    var lastFoundBeacon: CLBeacon! = CLBeacon()
    var lastProximity: CLProximity! = CLProximity.Unknown


    override init() {

        locationManager = CLLocationManager()
        let available = CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion)
        print("available: \(available)")
        let status = CLLocationManager.authorizationStatus()
        print("status: \(status.rawValue)")

        let uuid = NSUUID(UUIDString: "0CF052C2-97CA-407C-84F8-B62AAC4E9020")
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "com.atlassian.walkintologin")

        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true

        super.init()

        locationManager.delegate = self
    }

    func switchSpotting() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startUpdatingLocation()
    }


    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("start monitoring ")
        locationManager.requestStateForRegion(region)
    }

    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == CLRegionState.Inside {
            locationManager.startRangingBeaconsInRegion(beaconRegion)
        }
        else {
            locationManager.stopRangingBeaconsInRegion(beaconRegion)

        }
    }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if isSubscribed {
//            SharedOfficeManager.enterRoom(21)
//        }
        enterRoom()
        print("Beacon in range")
    }

    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if isSubscribed {
//            SharedOfficeManager.exitRoom(21)
//        }
        exitRoom()
        print("No beacons in range")
    }


    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
    }


    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print(error)
    }


    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        print(error)
    }
    
    func enterRoom() {
        if inARoom == false {
            inARoom = true
            SharedOfficeManager.enterRoom(21)
        }
    }
    
    func exitRoom() {
        if inARoom == true {
            inARoom = false
            SharedOfficeManager.exitRoom(21)
        }
    }

    var inARoom = false
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {

        let foundBeacons = beacons
            if foundBeacons.count > 0 {
                let closestBeacon = foundBeacons[0]
                    if closestBeacon != lastFoundBeacon || lastProximity != closestBeacon.proximity  {
                        lastFoundBeacon = closestBeacon
                        lastProximity = closestBeacon.proximity

                        var proximityMessage: String!
                        switch lastFoundBeacon.proximity {
                        case CLProximity.Immediate:
                            proximityMessage = "Very close"
                            if isSubscribed {
                                enterRoom()
                            }

                        case CLProximity.Near:
                            proximityMessage = "Near"

                        case CLProximity.Far:
                            proximityMessage = "Far"
                            exitRoom()

                        default:
                            proximityMessage = "Where's the beacon?"

                        }

                        print("proximityMessage: \(proximityMessage)")
                    }
//                }
            }
        }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Do nothing here
    }

}