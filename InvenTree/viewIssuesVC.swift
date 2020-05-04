//
//  viewIssuesVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 05/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import CoreLocation
import MapKit

class issueCell:UITableViewCell{
    var issue:Issue!
    var coords:CLLocationCoordinate2D!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var upvotesLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var issueImg: UIImageView!
    @IBAction func upvoteIssue(_ sender: Any) {
        let hud = JGProgressHUD.init()
        let ref = Database.database().reference().child("issue-node").child(self.issue.key)
        self.issue.upvotes+=1
        let updates:[String:Int]=["issue-upvotes":self.issue.upvotes]
        if(globalUser.email==self.issue.email){
            showAlert(msg: "You can't upvote your own issue!")
        }
        else{
            hud.show(in: self.contentView)
            ref.updateChildValues(updates) {(error,ref) -> Void in
                if(error==nil){
                    hud.dismiss()
                    showSuccess(msg: "Upvoted with success!")
                    self.upvotesLbl.text = String(self.issue.upvotes)
                }else{
                    hud.dismiss()
                    showAlert(msg: "Could not upvote. You may have connectivity problems.")
                }
            }
            
        }
    }
    
    @IBAction func toMaps(_ sender: Any) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.coords.latitude, longitude: self.coords.longitude)))
               source.name = "You"
               let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: issue.location.latitude, longitude: issue.location.longitude)))
        destination.name = self.issue.user_name + "'s issue."
               MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
}

class viewIssuesVC: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    var issuesCount:Int = 0
    var issues:[Issue]=[]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issuesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath) as! issueCell
        let i = indexPath.row
        cell.issue = self.issues[i]
        cell.coords = self.coord
        cell.nameLbl.text = cell.issue.user_name
        cell.issueImg.load(url: URL(string: cell.issue.url)!)
        cell.typeLbl.text = cell.issue.type
        cell.upvotesLbl.text = String(cell.issue.upvotes)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    let locationManager=CLLocationManager()
    let hud = JGProgressHUD.init()
    var coord:CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add"
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        setUpLocation()
    }
    func setUpLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        hud.show(in: self.view,animated: true)
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("called")
        let location:CLLocation = locations[0]
        coord = location.coordinate
        locationManager.stopUpdatingLocation()
        hud.dismiss()
        populateTable()
    }
    func populateTable(){
        print("populateTable() called to thread.")
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        let ref = Firebase.Database.database().reference().child("issue-node")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let issues = snapshot.value as! [String:AnyObject]
                self.issuesCount = issues.count
                for issue in issues{
                    let lat = issue.value["location-lat"] as! Double
                    let lon = issue.value["location-lon"] as! Double
                    let p_url = issue.value["photo-url"] as! String
                    let user_name = issue.value["user-given-name"] as! String
                    let upvotes = issue.value["issue-upvotes"] as! Int
                    let type = issue.value["issue-type"] as! String
                    let key = issue.key
                    let l_email = issue.value["user-email"] as! String
                    let loc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    print("url=\(p_url)")
                    let distance = self.distance(lat1: self.coord.latitude, lon1: self.coord.longitude, lat2:loc.latitude, lon2: loc.longitude, unit: "K")
                    let thisIssue = Issue(upvotes: upvotes, location: loc, type: type, url: p_url, user_name: user_name,dist: distance,key:key,email:l_email)
                    thisIssue.url = p_url
                    print("url=\(thisIssue.url as Any)")
                    self.issues.append(thisIssue)
                    self.tableView.reloadData()
                    self.sortIssues()
                }
            hud.dismiss()
            }) { (error) in
                hud.dismiss()
                showAlert(msg: "An error occured -> \(error.localizedDescription)")
                print(error.localizedDescription)
        }

    }
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg:lat2)) + cos(deg2rad(deg:lat1)) * cos(deg2rad(deg:lat2)) * cos(deg2rad(deg:theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist.round(to:2)
    }
    func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }
    func sortIssues(){
        print("sortIssues() called to thread.")
        self.issues.sort(by: { $0.dist < $1.dist })
        self.tableView.reloadData()
    }
}
