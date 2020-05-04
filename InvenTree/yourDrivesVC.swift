//
//  yourDrivesVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 27/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import CoreLocation
import MapKit
var globalDrive:Drive2!

class tableCell2: UITableViewCell
{
    var drive:Drive2!
    @IBOutlet weak var attendeesLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
//    @IBOutlet weak var attendeesLbl: UILabel!
    @IBOutlet weak var goalLbl: UILabel!
    
    @IBAction func seeMore(_ sender: Any) {
        globalDrive = self.drive
    }

    @IBAction func openLoc(_ sender: Any) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: drive.location.latitude, longitude: drive.location.longitude)))
        source.name = "You"
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: drive.location.latitude, longitude: drive.location.longitude)))
        destination.name = "Your drive on " + self.drive.date
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
}

class yourDrivesVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var drives:[Drive2]=[]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorLbl: UILabel!
    
    var driveCount:Int = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driveCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell2
        let i = indexPath.row
        cell.dateLbl.text = drives[i].date
        cell.drive = drives[i]
        if(cell.drive.date != "Not specified"){
            var dateActual:Date!
            let dateF = DateFormatter()
            dateF.dateFormat = "E, d MMM yyyy HH:mm:ss"
            dateActual = dateF.date(from: cell.drive.date)
            if(dateActual<Date()){
                cell.isUserInteractionEnabled = false
                cell.dateLbl.text = "Drive complete!"
            }else{
                cell.dateLbl.text = cell.drive.date
            }
        }
        
        cell.attendeesLbl.text = drives[i].num_attendees
        cell.goalLbl.text = drives[i].goal + " trees"
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Planting Hub"
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        
    }
    func fetchData(){
        print("fetchData called to thread.")
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        let ref = Database.database().reference().child("user-node").child(splitString(str: globalUser.email, delimiter: ".")).child("drives-organised")
        var attendees_list : [Attendee] = []
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let val = snapshot.value as? [String:AnyObject] ?? nil
            if (val==nil){
                hud.dismiss()
                showAlert(msg: "You haven't organised any drives yet")
                self.indicatorLbl.text = "You haven't organised any drives with us yet."
                self.indicatorLbl.textColor = UIColor.systemRed
                self.tableView.isHidden = true
            }else{
                self.driveCount = val!.count
                print("User has organised \(self.driveCount) drives")
                var cnt = 1
                for drive in val!{
                    print("drive #\(cnt)")
                    let list = drive.value["attendees-list"] as? [String:AnyObject] ?? nil
                    if(list==nil){
                        print("no extra attendees")
                    }else{
                        for val in list!{
                            let name = val.value["user-name"] as! String
                            let email = val.value["user-email"] as! String
                            let url = val.value["photo-url"] as! String
                            let trees_cnt = val.value["trees-planted"] as? Int ?? 0
                            let trees_str = String(trees_cnt)
                            let t:Attendee = Attendee(name: name, email: email, trees_planted: trees_str, photoUrl: url)
                            attendees_list.append(t)
                        }
                    }
                    cnt += 1
                    let time = drive.value["time"] as? String ?? "Not specified"
                    let goal = drive.value["tree-goal"] as! String ?? "Not specified"
                    let attendees = drive.value["attendees"] as! String ?? "Not specified"
                    let lat = drive.value["location-lat"] as! Double
                    let lon = drive.value["location-lon"] as! Double
                    let pos = CLLocationCoordinate2DMake(lat, lon)
                    let thisDrive = Drive2(num_attendess: attendees, goal: goal, date: time, attendees: attendees_list,location:pos)
                    self.drives.append(thisDrive)
                    self.tableView.reloadData()
                }
                hud.dismiss()
            }
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}
