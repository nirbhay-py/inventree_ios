//
//  hostDriveVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 24/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import GoogleMaps
import JGProgressHUD
class hostDriveVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    @IBOutlet weak var viewForMap: GMSMapView!
    let locationManager=CLLocationManager()
    var dt:Date!
    @IBOutlet weak var phoneTf: UITextField!
    
    let hud = JGProgressHUD.init()
    var coord:CLLocationCoordinate2D!
    var strDate:String!
    @IBOutlet weak var volunteersTf: UITextField!
    @IBOutlet weak var treesTf: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Planting Hub"
        self.hideKeyboardWhenTappedAround()
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(false, animated: animated)
    }
//    func initMap(){
//        print(self.coord as Any)
//        print("initMap called to thread.")
//        let hud = JGProgressHUD.init()
//        hud.show(in: self.view)
//        let cam = GMSCameraPosition.camera(withTarget: coord, zoom: 16)
//        let mapView = GMSMapView.map(withFrame: self.viewForMap.frame, camera: cam)
//        let marker = GMSMarker(position: coord)
//        viewForMap.layer.cornerRadius = 15
//        marker.title = "Drive Location"
//        marker.isDraggable = true
//        marker.map = mapView
//        mapView.delegate = self
//        mapView.isMyLocationEnabled = true
//        do {
//             mapView.mapStyle = try GMSMapStyle(jsonString: mapStyle)
//        } catch {
//             NSLog("One or more of the map styles failed to load. \(error)")
//        }
//        self.view.addSubview(mapView)
//        hud.dismiss()
//    }
//    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
//        self.coord = marker.position
//        print("Marker moved to \(coord as Any)")
//    }
    @IBAction func datePicked(_ sender: Any) {
        let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
          
        self.dt = datePicker.date
           strDate = dateFormatter.string(from: datePicker.date)
        
    }
    @IBAction func submit(_ sender: Any) {
        let hud = JGProgressHUD.init()
       
    if(treesTf.text==""||volunteersTf.text==""||phoneTf.text==""){
            showAlert(msg: "You can't leave fields blank.")
    }else if(phoneTf.text?.count != 10){
            showAlert(msg: "Please enter a 10 digit phone number.")
    }else if(strDate==nil){
            showAlert(msg: "You can't leave the time and date empty.")
    }else if(dt<Date()){
        showAlert(msg: "You don't have a time machine, do you? Try again.")
    }
    else{
        self.performSegue(withIdentifier: "proceedx", sender: self)

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! hostDrive2VC
        destVC.strDate = self.strDate
        destVC.goal = self.treesTf.text
        destVC.voln = self.volunteersTf.text
        destVC.phone  = self.phoneTf.text
    }
}
