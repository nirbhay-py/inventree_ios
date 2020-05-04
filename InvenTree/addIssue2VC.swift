//
//  addIssue2VC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 30/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import GoogleMaps
import CoreLocation

class addIssue2VC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    @IBOutlet weak var viewForMap: UIView!
    var imgData:Data!
    var issueDetails:String!
    var issueType:String!
    var hud = JGProgressHUD.init()
    var locationManager = CLLocationManager()
    var coord:CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add"
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
        let localHud = JGProgressHUD.init()
                    localHud.show(in: self.view)
                    var downloadUrl:URL!
                    let storage = Storage.storage()
                    let ref = Database.database().reference().child("issue-node").childByAutoId()
                    let st_ref = storage.reference().child("issue-imgs").child(ref.key!)
                    _ = st_ref.putData(self.imgData, metadata: nil) { (metadata, error) in
                                   if(error != nil){
                                       showAlert(msg: error!.localizedDescription)
                                       localHud.dismiss()
                                   }else{
                                      st_ref.downloadURL { (url, error) in
                                        if(error != nil){
                                            showAlert(msg: error!.localizedDescription)
                                            localHud.dismiss()
                                        }else if(url != nil){
                                           print("URL fetched with success.\n")
                                           downloadUrl = url!
                                           let issueDic:[String:Any]=[
                                               "issue-type":self.issueType as Any,
                                               "issue-details":self.issueDetails ?? "no-details",
                                               "issue-upvotes":1,
                                               "issue-resolved":false as Any,
                                               "user-email":globalUser.email as Any,
                                               "location-lat":self.coord.latitude as Any,
                                               "location-lon":self.coord.longitude as Any,
                                               "user-given-name":globalUser.givenName as Any,
                                               "photo-url":downloadUrl.absoluteString
                                           ];
                                           ref.setValue(issueDic) { (error, ref) -> Void in
                                               if(error == nil){
                                                    showSuccess(msg: "This issue has been uploaded! By clicking submit now, you will be adding another issue.")
                                                    localHud.dismiss()
                                               }
                                               else{
                                                   localHud.dismiss()
                                                   showAlert(msg: error!.localizedDescription)
                                               }
                                           }
                                        }
                                        else{
                                           showAlert(msg: "Check your network, you may have issues.")
                                            localHud.dismiss()
                                       }
                                       }
                                   }
                               }
    }
}
