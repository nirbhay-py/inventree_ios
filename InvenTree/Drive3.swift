
import Foundation
import CoreLocation

class Drive3{
    var date:String!
    var location:CLLocationCoordinate2D!
    var number:String!
    var name:String!
    init(date:String,location:CLLocationCoordinate2D,number:String,name:String)
    {
        self.date = date
        self.location = location
        self.number = number
        self.name = name
    }
}

