//
//  hostDrive2VC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 30/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import JGProgressHUD

class hostDrive2VC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    var strDate:String!
    var voln:String!
    var goal:String!
    var phone:String!
    
    var locationManager = CLLocationManager()
    var coord:CLLocationCoordinate2D!
    var hud = JGProgressHUD.init()
    
    @IBOutlet weak var viewForMap: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Planting Hub"
        print(strDate,voln,goal,phone)
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
           initMap()
       }
       
    func initMap(){
        print(self.coord as Any)
        print("initMap called to thread.")
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        let cam = GMSCameraPosition.camera(withTarget: coord, zoom: 16)
        let mapView = GMSMapView.map(withFrame: self.viewForMap.frame, camera: cam)
        let marker = GMSMarker(position: coord)
        viewForMap.layer.cornerRadius = 15
        mapView.layer.cornerRadius = 15
        marker.title = "Tree location"
        marker.isDraggable = true
        marker.map = mapView
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        do {
             mapView.mapStyle = try GMSMapStyle(jsonString: mapStyle)
        } catch {
             NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.view.addSubview(mapView)
        hud.dismiss()
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        self.coord = marker.position
        print("Marker moved to \(coord as Any)")
    }

    @IBAction func submit(_ sender: Any) {
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        let user_ref = Database.database().reference().child("user-node").child(splitString(str: globalUser.email, delimiter: ".")).child("drives-organised").childByAutoId()
        let drive_ref = Database.database().reference().child("drives-node").childByAutoId()
        let driveDic:[String:Any]=[
                       "user-name":globalUser.name,
                       "user-email":globalUser.email,
                       "phone-no":phone,
                       "volunteers-req":voln,
                       "tree-goal":goal,
                       "location-lat":coord.latitude,
                       "location-lon":coord.longitude,
                       "time":strDate as Any,
                       "attendees":"1",
                       "drive-node-key":drive_ref.key as Any,
                       "user-node-key":user_ref.key as Any
            ]
        user_ref.setValue(driveDic) { (error, ref) -> Void in
            if(error != nil){
                showAlert(msg: "An error occured. \(error?.localizedDescription)")
                hud.dismiss()
            }else{
                drive_ref.setValue(driveDic) { (error,ref) -> Void in
                    if(error != nil){
                        showAlert(msg: "An error occured. \(error?.localizedDescription)")
                        hud.dismiss()
                    }else{
                        showSuccess(msg: "Your drive has been uploaded with success.")
                        hud.dismiss()
                        }
                    }
            }
        }
    }
}
