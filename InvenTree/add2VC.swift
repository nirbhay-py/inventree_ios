//
//  add2VC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 10/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase
import CoreLocation
import GoogleMaps

class add2VC: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{
    var imgData:Data!
    var diameter:String!
    var age:String!
    var species:String!
    var height:String!
    let hud = JGProgressHUD.init()
    let locationManager = CLLocationManager()
    @IBOutlet weak var viewForMap: GMSMapView!
    
    var coord:CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add"
        setUpLocation()
        // Do any additional setup after loading the view.
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
        if(self.imgData==nil){
            showAlert(msg: "You can't proceed without selecting an image.")
        }else{
            localHud.show(in: self.view)
            var downloadUrl:URL!
            let storage = Storage.storage()
            let ref = Database.database().reference().child("trees-node").childByAutoId()
            let st_ref = storage.reference().child("tree-imgs").child(ref.key!)
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
                                   let treeDic:[String:Any]=[
                                    "species":self.species as Any,
                                    "height":self.height as Any,
                                       "user-email":globalUser.email as Any,
                                       "location-lat":self.coord.latitude as Any,
                                       "location-lon":self.coord.longitude as Any,
                                       "user-given-name":globalUser.givenName as Any,
                                       "age":self.age as Any,
                                       "diameter":self.diameter as Any,
                                       "photo-url":downloadUrl.absoluteString
                                   ];
                                   ref.setValue(treeDic) { (error, ref) -> Void in
                                       if(error == nil){
                                           globalUser.treesPlanted += 1
                                           let user_ref = Database.database().reference().child("user-node").child(splitString(str: globalUser.email, delimiter: "."))
                                        user_ref.observeSingleEvent(of: .value, with: {(snapshot) in
                                            let value = snapshot.value as! NSDictionary
                                            var count = value["trees-planted"] as! Int
                                            count += 1
                                            let updates : [String:Int] = ["trees-planted":count]
                                            user_ref.updateChildValues(updates)
                                        })
                                           showSuccess(msg: "This tree has been uploaded! By clicking submit now, you will be adding another tree.")
                                        globalUser.treesPlanted += 1
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
                               }
                               }
                           }
                       }
            
    }
    }
}
