//
//  TestBeaconViewController.swift
//  WalkInToLogin
//
//  Created by Thanh Tung Vu on 12/10/15.
//  Copyright © 2015 Sushant Choudhary. All rights reserved.
//

import Foundation

class TestBeaconViewController: UITableViewController {
    
    let rooms = SharedOfficeManager.rooms()
    
    // MARK: - Datasource & Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let room = rooms[indexPath.row]
        cell.textLabel?.text = room.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let walkIn = indexPath.section == 0
        let room = rooms[indexPath.row]
        if walkIn {
            SharedOfficeManager.enterRoom(room.id)
        } else {
            SharedOfficeManager.exitRoom(room.id)
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Walk In"
        default:
            return "Walk Out"
        }
    }

}