//
//  Tree.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 21/02/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import Foundation
import CoreLocation

class Tree{
    var species:String!
    var location:CLLocationCoordinate2D!
    var height:String!
    var user:GlobalUser!
    init(species:String,location:CLLocationCoordinate2D,height:String,user:GlobalUser) {
        self.species = species
        self.location = location
        self.height = height
        self.user = user
    }
}
