//
//  aqiVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 24/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
import JGProgressHUD
import GoogleMaps


class aqiVC: UIViewController,CLLocationManagerDelegate{
    @IBOutlet weak var addressLbl: UILabel!
    var coord:CLLocationCoordinate2D!
    var data:JSON!
    
    @IBOutlet weak var aqiLbl: UILabel!
    @IBOutlet weak var domPolLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var descVal: UILabel!
    
    
    let hud = JGProgressHUD.init()
    let key:String = "f022a338-cfee-4723-a329-f111260f10f4"
    let locationManager=CLLocationManager()
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        self.title = "Map"
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
        let coordinate:CLLocationCoordinate2D = location.coordinate
        locationManager.stopUpdatingLocation()
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate, completionHandler:{(resp,error)  in
            self.hud.dismiss()
            if(error != nil || resp==nil ){
                showAlert(msg: "You may have connectivity issues :"+error!.localizedDescription)
            }else{
                print(resp?.results()?.first as Any)
                self.addressLbl.text = resp?.results()?.first?.lines![0]
                self.fetchAndDisplayAqi()
            }
        })
       
    }
    func fetchAndDisplayAqi(){
        let aqiHud = JGProgressHUD.init()
        aqiHud.show(in: self.view)
        var finalURL:String = "https://api.airvisual.com/v2/nearest_city?lat="+String(coord.latitude)+"&lon="+String(coord.longitude)
        finalURL += ("&key="+key)
        print(finalURL)
        AF.request(finalURL).response { response in
            if(response.value==nil){
                showAlert(msg: "We could not fetch AQI data at this time.")
                aqiHud.dismiss()
            }else{
                self.data = JSON(response.value as! Any)
                let aqiVal = self.data["data"]["current"]["pollution"]["aqius"].stringValue
                let domPolVal = self.data["data"]["current"]["pollution"]["mainus"].stringValue
                let domPolString = self.returnDetails(domPol: domPolVal)
                let temp = self.data["data"]["current"]["weather"]["tp"].stringValue
                self.aqiLbl.text = aqiVal
                self.domPolLbl.text = domPolString
                self.tempLbl.text = temp + " ℃"
                self.descVal.text = self.getDesc(aqi: Int(aqiVal)!)
                self.aqiLbl.textColor = self.getColor(aqi: Int(aqiVal)!)
                print(self.getColor(aqi: Int(aqiVal)!))
                aqiHud.dismiss()
            }
        }
    }
    
    func returnDetails(domPol:String) -> String{
        switch domPol {
        case "p2":
            return "Fine-sized particulate matter"
        case "p1":
            return "Coarse particulate matter"
        case "o3":
            return "Ozone O3"
        case "n2":
            return "Nitrogen dioxide"
        case "s2":
            return "Sulphur Dioxide"
        case "co":
            return "Carbon Monoxide"
        default:
            return "Error fetching data"
            
        }
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
    func getDesc(aqi:Int) -> String{
        if(aqi<=100){
            return "No health implications. Enjoy your outdoor activites."
        }else if(aqi<=200){
             return "Slight irritation might occur. Members of sensitive groups should reduce outdoor activities."
        }else if(aqi<=300){
            return "Healthy people will be noticeably affected. Children, the elderly, and people with cardiovascular or respiratory problems should restrict outdoor activities."
        }
        else{
            return "Healthy people will experience reduced endurance while performing outdoor activities.Children, the elderly, and the sick should remain indoors and avoid exercise. Healthy individuals should avoid outdoor activities."
        }
    }
    
    @IBAction func showPressed(_ sender: Any) {
        showInfo(msg:"We used findings made in  Characterization of Atmospheric Pollution Index and its affecting factors in Industrial Urban Areas in Northeast China published in the Polish Journal of Environmental Studies in January 2015 to classify AQI bands. The paper is published and available online at researchgate.com")
    }
    
}
