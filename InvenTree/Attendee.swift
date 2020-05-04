//
//  Attendee.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 27/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import Foundation

class Attendee {
    var name:String!
    var email:String!
    var trees_planted:String!
    var photoUrl:String!
    init(name:String,email:String,trees_planted:String,photoUrl:String) {
        self.name = name
        self.email = email
        self.trees_planted = trees_planted
        self.photoUrl = photoUrl
    }
}
