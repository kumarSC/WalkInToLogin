//
//  UsersListViewController.swift
//  WalkInToLogin
//
//  Created by Thanh Tung Vu on 12/10/15.
//  Copyright © 2015 Sushant Choudhary. All rights reserved.
//

import Foundation

class UsersListViewController: UITableViewController {
    var roomID: RoomID!
    private var room: Room!
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        room = SharedOfficeManager.room(roomID)
        room.users() { [weak self] (theUsers) -> Void in
            self?.users = theUsers
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
}