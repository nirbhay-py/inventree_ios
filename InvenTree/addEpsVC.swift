//
//  addEpsVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 23/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import CoreLocation
import JGProgressHUD
import Firebase
import GoogleMaps

class addEpsVC: UIViewController, CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,GMSMapViewDelegate{
    
    @IBOutlet weak var thumbnail: UIImageView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var areaTf: UITextField!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var welcomeLbl: UILabel!
    let hud = JGProgressHUD.init()
    
    @IBOutlet weak var viewForMap: GMSMapView!
    
    var imgData:Data!
    var coord:CLLocationCoordinate2D!
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        self.viewForMap.layer.cornerRadius = 15
        super.viewDidLoad()
        self.title = "Add"

        welcomeLbl.text = "Hi, "+globalUser.givenName+". Follow the instructions below to add an empty planting site to the InvenTree Map."
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
        print(coord)
        let coordinate:CLLocationCoordinate2D = location.coordinate
        locationManager.stopUpdatingLocation()
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate, completionHandler:{(resp,error)  in
            self.hud.dismiss()
            if(error != nil || resp==nil ){
                showAlert(msg: "You may have connectivity issues :"+error!.localizedDescription)
            }else{
                print(resp?.results()?.first as Any)
                self.initMap()
            }
        })
       
    }
    
    func initMap(){
        print(self.coord)
        print("initMap called to thread.")
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        let cam = GMSCameraPosition.camera(withTarget: coord, zoom: 16)
        let mapView = GMSMapView.map(withFrame: self.viewForMap.frame, camera: cam)
        mapView.isMyLocationEnabled = true
        mapView.layer.cornerRadius = 15
        let marker = GMSMarker(position: coord)
        viewForMap.layer.cornerRadius = 15
        marker.title = "Empty planting site location"
        marker.isDraggable = true
        marker.map = mapView
        mapView.delegate = self
        do {
             mapView.mapStyle = try GMSMapStyle(jsonString: mapStyle)
        } catch {
             NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.view.addSubview(mapView)
        hud.dismiss()
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        coord = marker.position
        print("Marker moved to \(coord as Any)")
    }
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            var img = pickedImage.jpeg(.low)
            self.imgData = img
            print(pickedImage.size)
            thumbnail.image = pickedImage
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
    }

    
    @IBAction func submitBtnClicked(_ sender: Any) {
        let localHud = JGProgressHUD.init()
        if(areaTf.text==""){
            showAlert(msg: "You can't leave this field blank.")
        }else if(self.imgData==nil){
            showAlert(msg: "You must upload an image.")
        }else{
            localHud.show(in: self.view)
            var downloadUrl:URL!
            let storage = Storage.storage()
            let ref = Database.database().reference().child("eps-node").childByAutoId()
            let st_ref = storage.reference().child("eps-imgs").child(ref.key!)
            _ = st_ref.putData(self.imgData, metadata: nil) { (metadata, error) in
                           if(error != nil){
                               showAlert(msg: error!.localizedDescription)
                               localHud.dismiss()
                               self.resetFields()
                           }else{
                              st_ref.downloadURL { (url, error) in
                                if(error != nil){
                                    showAlert(msg: error!.localizedDescription)
                                    localHud.dismiss()
                                   self.resetFields()
                                }else if(url != nil){
                                   print("URL fetched with success.\n")
                                   downloadUrl = url!
                                   let epsDic:[String:Any]=[
                                       "user-email":globalUser.email as Any,
                                       "location-lat":self.coord.latitude as Any,
                                       "location-lon":self.coord.longitude as Any,
                                       "user-given-name":globalUser.givenName as Any,
                                       "approx-area":self.areaTf.text?.floatValue,
                                       "photo-url":downloadUrl.absoluteString
                                   ];
                                   ref.setValue(epsDic) { (error, ref) -> Void in
                                       if(error == nil){
                                            showSuccess(msg: "This empty planting site has been uploaded! By clicking submit now, you will be adding another empty planting site.")
                                            localHud.dismiss()
                                       }
                                       else{
                                           localHud.dismiss()
                                           showAlert(msg: error!.localizedDescription)
                                           self.resetFields()
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
    func resetFields(){
        self.areaTf.text = ""
        self.imgData = nil
    }
    
    
  

}
