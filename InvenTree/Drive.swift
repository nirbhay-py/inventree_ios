//
//  Drive.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 26/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import Foundation
import CoreLocation

class Drive{
    var name:String!
    var location:CLLocationCoordinate2D!
    var attendees:String!
    var needed:String!
    var phone:String!
    var distance:Float!
    var goal:String!
    var date:String!
    var userKey:String!
    var driveKey:String!
    var email:String!
    var dateActual:Date!
    init(name:String,location:CLLocationCoordinate2D,attendees:String,needed:String, phone:String!,  distance:Float,date:String,goal:String,userKey:String,driveKey:String,email:String) {
        self.name = name
        self.location = location
        self.attendees = attendees
        self.needed = needed
        self.phone = phone
        self.distance = distance
        self.date = date
        self.goal = goal
        self.userKey = userKey
        self.driveKey = driveKey
        self.email = email
    }
}
