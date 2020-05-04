//
//  Issue.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 05/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import Foundation
import CoreLocation

class Issue{
    var upvotes:Int!
    var location:CLLocationCoordinate2D!
    var type:String!
    var url:String!
    var user_name:String!
    var key:String!
    var dist:Double!
    var email:String!
    init(upvotes:Int,location:CLLocationCoordinate2D,type:String,url:String,user_name:String,dist:Double,key:String,email:String) {
        self.upvotes = upvotes
        self.location = location
        self.type = type
        self.dist = dist
        self.user_name = user_name
        self.url = url
        self.key = key
        self.email = email
    }
}
