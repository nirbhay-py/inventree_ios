//
//  mapVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 21/02/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import JGProgressHUD
import Firebase
import Alamofire
import SwiftyJSON


class mapVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    
    var treesCount = 0;
    let locationManager = CLLocationManager()
    var coords:CLLocationCoordinate2D!
    let hud = JGProgressHUD.init()
    var data:JSON!
    let c02:Double = 1.15749
    let stormwater:Double = 2.47053
    let ap:Double = 52.41663
    let energy:Double = 49.26375
    let avoided:Double = 6.32553
    var co2res = 0.0
    var apres = 0.0
    var energyres = 0.0
    var avoidedres = 0.0
    var stormwaterres = 0.0
    var total = 0.0

    
    let aqiHUd = JGProgressHUD.init()
    let key:String = "f022a338-cfee-4723-a329-f111260f10f4"
    let camera = GMSCameraPosition.camera(withLatitude: 60, longitude:60, zoom: 16.0)
    lazy var mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    override func viewDidLoad() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        super.viewDidLoad()
        self.title = "Map"
        self.hideKeyboardWhenTappedAround()
        setUpLocation()
        self.view = mapView
        do {
             mapView.mapStyle = try GMSMapStyle(jsonString: mapStyle)
        } catch {
             NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapView.isMyLocationEnabled = true
        
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
        refreshMap()
    }
    func refreshMap(){
        print(coords.latitude,coords.longitude)
        let cam = GMSCameraPosition.camera(withLatitude: coords.latitude, longitude:coords.longitude, zoom: 16.0)
        mapView.camera = cam
        populateMap()
    }
        func populateMap(){
        let ref = Database.database().reference().child("trees-node")
        _ = ref.observe(DataEventType.value, with: { (snapshot) in
            let reports = snapshot.value as! [String:AnyObject]
            let markerImg = UIImage(named: "tree-1")
            self.treesCount = reports.count
            print(self.treesCount)
            for report in reports{
                let lat = report.value["location-lat"] as! Double
                let lon = report.value["location-lon"] as! Double
                let name = report.value["user-given-name"] as! String
                let species = report.value["species"] as! String
                let height = report.value["height"] as! String
                let age = report.value["age"] as! String
                let diameter = report.value["diameter"] as! String
                let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let marker = GMSMarker(position: position)
                marker.title = "Tree"
                marker.icon = markerImg
                var snippetStr = "Uploaded by: \(name)"
                if(height != ""){
                    snippetStr += "\nHeight(m): \(height)"
                }
                if(age != ""){
                    snippetStr += "\nAge(years): \(age)"
                }
                if(diameter != ""){
                    snippetStr += "\nDiameter(m): \(diameter)"
                }
                if(species != ""){
                    snippetStr += "\nSpecies: \(species)"
                }
                marker.snippet = snippetStr
                marker.map = self.mapView
            }
        })
        let issue_ref = Database.database().reference().child("issue-node")
        _ = issue_ref.observe(DataEventType.value, with: { (snapshot) in
            let reports = snapshot.value as! [String:AnyObject]
            let warningImg = UIImage(named: "warningImg")
            let resolvedImg = UIImage(named:"resolved")
            for report in reports{
                let lat = report.value["location-lat"] as! Double
                let lon = report.value["location-lon"] as! Double
                let email = report.value["user-email"] as! String
                let name = report.value["user-given-name"] as! String
                let desc = report.value["issue-type"] as! String
                let upvotes = report.value["issue-upvotes"] as! Int
                let resolved = report.value["issue-resolved"] as! Bool
                let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let marker = GMSMarker(position: position)
                marker.title = "Issue"
                var str = ""
                if(desc=="Other"){
                     str  = report.value["issue-details"] as! String ?? "Other"
                }else{
                     str  = desc
                }
                marker.icon = warningImg
                str += "\nUploaded by:" + String(name)
                str += "\nUpvotes:" + String(upvotes)
                marker.snippet = str
                marker.map = self.mapView
            }
        })
            let drive_ref = Database.database().reference().child("drives-node")
            _ = drive_ref.observe(DataEventType.value, with: { (snapshot) in
                let reports = snapshot.value as! [String:AnyObject]
                let img = UIImage(named: "drive-1")
                for report in reports{
                    let lat = report.value["location-lat"] as! Double
                    let lon = report.value["location-lon"] as! Double
                    let time = report.value["time"] as! String ?? "Not specified"
                    let attendees = report.value["attendees"] as! String
                    let name = report.value["user-name"] as! String
                    let needed = report.value["volunteers-req"] as! String
                    let phone = report.value["phone-no"] as! String
                    let goal = report.value["tree-goal"] as! String
                    let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let marker = GMSMarker(position: position)
                    marker.icon = img
                    marker.title = "Planting drive"
                    var str = "Organised by: " + String(name)
                    str += "\nPhone: " + phone
                    str += "\nAttending: " + String(attendees)
                    str += "\nVolunteers needed: " + String(needed)
                    str += " Goal: " + goal + " trees"
                    str += " Time: " + time
                    marker.snippet = str
                    marker.map = self.mapView
                }
        })
        let eps_ref = Database.database().reference().child("eps-node")
        _ = eps_ref.observe(DataEventType.value, with: { (snapshot) in
            let reports = snapshot.value as! [String:AnyObject]
            let markerImg = UIImage(named: "empty-1")
            for report in reports{
                let lat = report.value["location-lat"] as! Double
                let lon = report.value["location-lon"] as! Double
                let name = report.value["user-given-name"] as! String
                let approx_area = report.value["approx-area"] as! Double
                let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let marker = GMSMarker(position: position)
                marker.title = "Empty planting site"
                marker.icon = markerImg
                marker.snippet = "Uploaded by: \(name)\nApproximate area: \(approx_area.round(to: 2)) square mt."
                marker.map = self.mapView
            }
            
        })

        fetchAQI()
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.snippet as Any)
        return true
    }
    func fetchAQI(){
        aqiHUd.show(in: self.view)
        var finalURL:String = "https://api.airvisual.com/v2/nearest_city?lat="+String(coords.latitude)+"&lon="+String(coords.longitude)
        finalURL += ("&key="+key)
        print(finalURL)
        AF.request(finalURL).response { response in
            if(response.value==nil){
                showAlert(msg: "We could not fetch AQI data at this time.")
                self.aqiHUd.dismiss()
            }else{
                self.data = JSON(response.value as! Any)
                self.displayAQI()
                
            }
        }
    }
    func displayAQI(){
        let aqi = self.data["data"]["current"]["pollution"]["aqius"].stringValue
        let int_aqi = Int(aqi) ?? 0
        let mainColor = getColor(aqi: int_aqi)
        let city = self.data["data"]["city"].stringValue
        print(aqi,city)
       let v = UIButton(frame: //CGRect(x:self.view.frame.width-120,y:self.view.frame.height-190,width:100,height: 80))
        CGRect(x:70 * UIScreen.main.bounds.width/100,y:78 * UIScreen.main.bounds.height/100,width:100,height: 80))
        v.addTarget(self, action: #selector(self.toAqi), for: .touchUpInside)
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 15
        v.layer.borderWidth = 2
        v.layer.borderColor = mainColor.cgColor
       let aqiLbl = UILabel(frame: CGRect(x:0,y:0,width:90,height:40))
       aqiLbl.center = CGPoint(x:v.frame.width/2, y:v.frame.height/2-10)
       aqiLbl.font = aqiLbl.font.withSize(40)
       aqiLbl.textAlignment = .center
       aqiLbl.textColor = mainColor
       aqiLbl.text = aqi
       v.addSubview(aqiLbl)
       let catLbl = UILabel(frame: CGRect(x:0,y:0,width:200,height:20))
       catLbl.center = CGPoint(x:v.frame.width/2, y:v.frame.height/2+15)
       catLbl.font = catLbl.font.withSize(15)
       catLbl.textAlignment = .center
       catLbl.textColor = mainColor
       catLbl.text = "AQI"
       v.addSubview(catLbl)
       self.mapView.addSubview(v)
       aqiHUd.dismiss()
        showBenefits()
    }
    @objc func toAqi(sender: UIButton!) {
        print("AQI BUTTON PRESSED")
        self.performSegue(withIdentifier: "toAqi", sender: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func getColor(aqi:Int) -> UIColor{
        if(aqi<=50){
            return UIColor.systemGreen
        }else if(aqi<=100){
            return UIColor.systemYellow
        }else if(aqi<=150){
            return UIColor.systemOrange
        }else if(aqi<=200){
            return UIColor.systemRed
        }else if(aqi<=300){
            return UIColor.systemPurple
        }
        else{
            return UIColor.black
        }
    }
    func showBenefits(){
         co2res = c02 * Double(self.treesCount)
         apres = ap * Double(self.treesCount)
         energyres = energy * Double(self.treesCount)
         avoidedres = avoided  * Double(self.treesCount)
         stormwaterres = stormwater * Double(self.treesCount)
       
        var total = co2res + apres + energyres + avoidedres + stormwaterres
        total = total.round(to: 2)
        total *= 65
        let mainView = UIButton(frame:(CGRect(x: 20, y: 13 * UIScreen.main.bounds.height/100, width: self.view.frame.width-40, height: 60)))
        mainView.backgroundColor = UIColor.white
        mainView.layer.cornerRadius = 15
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = UIColor.systemGreen.cgColor
        mainView.addTarget(self, action: #selector(self.showBenefitsDetails), for: .touchUpInside)
        var benLbl = UILabel(frame: CGRect(x: 0, y: 0, width: mainView.frame.width, height: 40))
        benLbl.center = CGPoint(x:mainView.frame.width/2, y:mainView.frame.height/2)
        benLbl.text = "Learn about ecosystem benefits."
        benLbl.textAlignment = .center
        benLbl.adjustsFontSizeToFitWidth = true
        benLbl.textColor = UIColor.systemGreen
        mainView.addSubview(benLbl)
        
        self.mapView.addSubview(mainView)
    }
    @objc func showBenefitsDetails(sender: UIButton!){
        print("showBenefitsPressed()")
        self.performSegue(withIdentifier: "toBen", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="toBen"){
            let destVC = segue.destination as! viewBenVC
            destVC.treesCount = self.treesCount
        }
    }
}

