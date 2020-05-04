//
//  drivesJoinedVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 30/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit
import JGProgressHUD

class cell4:UITableViewCell{
    var drive:Drive3!
    @IBOutlet weak var nameLbl: UILabel!
    var coords:CLLocationCoordinate2D!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBAction func openInMapsPressed(_ sender: Any) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.coords.latitude, longitude: self.coords.longitude)))
        source.name = "You"
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: drive.location.latitude, longitude: drive.location.longitude)))
        destination.name = self.drive.name + "'s drive on " + self.drive.date
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
}


class drivesJoinedVC: UIViewController, UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate{
    @IBOutlet weak var indicatorLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var locationManager = CLLocationManager()
    var coords:CLLocationCoordinate2D!
    var hud = JGProgressHUD.init()
    var drives:[Drive3]=[]
    var drivesCount:Int=0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! cell4
        let i = indexPath.row
        cell.drive = self.drives[i]
        cell.contactLbl.text = cell.drive.number
        var dateActual:Date!
        var dateF = DateFormatter()
        dateF.dateFormat = "E, d MMM yyyy HH:mm:ss"
        dateActual = dateF.date(from: cell.drive.date)
        if(dateActual<Date()){
            cell.isUserInteractionEnabled = false
            cell.dateLbl.text = "Drive complete!"
        }else{
            cell.dateLbl.text = cell.drive.date
        }
        cell.nameLbl.text = cell.drive.name
        cell.dateLbl.text = cell.drive.date
        cell.coords = self.coords
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    override func viewDidLoad() {
        print("drivesJoinedVC")
        super.viewDidLoad()
        self.title = "Planting Hub"
        self.hideKeyboardWhenTappedAround()
        setUpLocation()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func fetchData(){
        print("fetchData() called to thread")
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        let ref = Database.database().reference().child("user-node").child(splitString(str: globalUser.email, delimiter: ".")).child("drives-joined")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let val = snapshot.value as? [String:AnyObject] ?? nil
            if(val==nil){
                hud.dismiss()
                showAlert(msg: "You haven't joined any drives yet.")
                self.indicatorLbl.text = "Looks like you haven't joined any drives yet."
                self.indicatorLbl.textColor = UIColor.systemRed
                self.tableView.isHidden = true
            }else{
                self.drivesCount = val!.count
                for elem in val!{
                    let number = elem.value["ph-number"] as! String
                    let lat = elem.value["location-lat"] as! Double
                    let lon = elem.value["location-lon"] as! Double
                    let user_name = elem.value["organiser-name"] as! String
                    let time = elem.value["time"] as! String
                    let loc = CLLocationCoordinate2DMake(lat, lon)
                    let thisDrive = Drive3(date: time, location: loc, number: String(number), name: user_name)
                    print(thisDrive.name)
                    self.drives.append(thisDrive)
                    self.tableView.reloadData()
                }
                hud.dismiss()
            }
        })
        
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
        coords = location.coordinate
        print(coords.longitude)
        locationManager.stopUpdatingLocation()
        hud.dismiss()
        fetchData()
    }


}
