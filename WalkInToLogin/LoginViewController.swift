//
//  LoginViewController.swift
//  WalkInToLogin
//
//  Created by Thanh Tung Vu on 12/10/15.
//  Copyright © 2015 Sushant Choudhary. All rights reserved.
//

import Foundation

class LoginViewController: UITableViewController {
    private var users = testUsers
    
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
        let selected = SharedUserManager.currentUser.id == user.id
        cell.accessoryType = selected ? .Checkmark : .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SharedUserManager.currentUser = users[indexPath.row]
        SharedPubNubManager.instantiatePubNub(true)
        tableView.reloadData()
    }
}
