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


class Observer: NSObject, CLLocationManagerDelegate {

    var beaconRegion: CLBeaconRegion!
    var locationManager: CLLocationManager!
    var isSearchingForBeacons = false
    var lastFoundBeacon: CLBeacon! = CLBeacon()
    var lastProximity: CLProximity! = CLProximity.Unknown


    override init() {

        locationManager = CLLocationManager()


        let uuid = NSUUID(UUIDString: "0CF052C2-97CA-407C-84F8-B62AAC4E9020")
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "com.atlassian.walkintologin")

        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true

        super.init()

        locationManager.delegate = self
    }

    func switchSpotting(sender: AnyObject) {
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
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
        print("Beacon in range")
    }

    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
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

    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {

    }


    
    
}