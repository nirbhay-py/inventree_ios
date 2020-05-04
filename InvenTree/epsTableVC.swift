//
//  epsTableVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 24/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import JGProgressHUD

class epsCell:UITableViewCell{
    @IBOutlet weak var distLbl: UILabel!
    var cell_eps:eps!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var areaLbl: UILabel!
    @IBAction func markRemovedPressed(_ sender: Any) {
        
            let hud = JGProgressHUD.init()
            hud.show(in: self.contentView)
            let ref = Database.database().reference().child("eps-node").child(self.cell_eps.key)
            let updates = ["removalReq":true]
            ref.updateChildValues(updates) { error, ref in
                if(error == nil)
                {
                    hud.dismiss()
                    showSuccess(msg: "Requested with success.")
                }else{
                    hud.dismiss()
                    showAlert(msg: "Please check your connection. You may have connectivity problems.")
                     print(error)
                }
               
            }
        }
}
    
    
    

class eps{
    var area:Double
    var name:String
    var loc:CLLocationCoordinate2D
    var url:String
    var key:String
    var dist:Double
    init(area:Double,name:String,loc:CLLocationCoordinate2D,url:String,key:String,dist:Double) {
        self.area = area
        self.name = name
        self.loc = loc
        self.url = url
        self.dist = dist
        self.key = key
    }
}

class epsTableVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    @IBOutlet weak var indicatorLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
     var locationManager = CLLocationManager()
       var coords:CLLocationCoordinate2D!
       var hud = JGProgressHUD.init()
       var eps_arr:[eps]=[]
       var eps_count:Int=0
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return eps_count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "epsCell", for: indexPath) as! epsCell
            let i = indexPath.row
            cell.cell_eps = self.eps_arr[i]
            cell.name.text = cell.cell_eps.name
        cell.areaLbl.text = "\(cell.cell_eps.area.round(to: 2)) sq. mt."
        cell.areaLbl.adjustsFontSizeToFitWidth = true
        cell.img.load(url: URL(string: cell.cell_eps.url)!)
        cell.distLbl.text = "\(cell.cell_eps.dist.round(to: 2)) km away from you."
           return cell
        
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 200
       }

       override func viewDidLoad() {
           print("drivesJoinedVC")
           super.viewDidLoad()
           self.title = "Add"
           self.hideKeyboardWhenTappedAround()
           setUpLocation()
           tableView.delegate = self
           tableView.dataSource = self
           
           
       }
       
       func fetchData(){
           print("fetchData() called to thread")
           let hud = JGProgressHUD.init()
           hud.show(in: self.view)
           let ref = Database.database().reference().child("eps-node")
           ref.observeSingleEvent(of: .value, with: {(snapshot) in
               let val = snapshot.value as? [String:AnyObject] ?? nil
               if(val==nil){
                   hud.dismiss()
                   showAlert(msg: "There are no more empty planting sites in our database.")
                   self.indicatorLbl.text = "There are no more empty planting sites in our database."
                   self.indicatorLbl.textColor = UIColor.systemRed
                   self.tableView.isHidden = true
               }else{
                   self.eps_count = val!.count
                   for elem in val!{
                       let area = elem.value["approx-area"] as! Double
                       let lat = elem.value["location-lat"] as! Double
                       let lon = elem.value["location-lon"] as! Double
                       let user_name = elem.value["user-given-name"] as! String
                    let url = elem.value["photo-url"] as! String
                    let key = elem.key
                       let loc = CLLocationCoordinate2DMake(lat, lon)
                    let distance = self.distance(lat1: self.coords.latitude, lon1: self.coords.longitude, lat2:loc.latitude, lon2: loc.longitude, unit: "K")
                    let thisDrive = eps(area: area, name: user_name, loc: loc,url: url,key:key,dist: distance)
                       self.eps_arr.append(thisDrive)
                       self.tableView.reloadData()
                    self.sortIssues()
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
    func sortIssues(){
        print("sortIssues() called to thread.")
        self.eps_arr.sort(by: { $0.dist < $1.dist })
        self.tableView.reloadData()
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

}
