
import Foundation
import CoreLocation

class Drive2{
    var num_attendees:String!
    var goal:String!
    var date:String!
    var attendees:[Attendee]!
    var location:CLLocationCoordinate2D!
    init(num_attendess:String,goal:String,date:String,attendees:[Attendee],location:CLLocationCoordinate2D) {
        self.num_attendees = num_attendess
        self.goal = goal
        self.date = date
        self.attendees = attendees
        self.location = location
    }
}
