//
//  addTreeVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 21/02/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import GoogleMaps
import SearchTextField
import JGProgressHUD
import SafariServices

class addTreeVC: UIViewController,CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var searchTxtBox: SearchTextField!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var ageTf: UITextField!
    @IBOutlet weak var diameterTf: UITextField!
    let locationManager = CLLocationManager()
    let hud = JGProgressHUD.init()
    var coord:CLLocationCoordinate2D!
    var imgData:Data!
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var heightTf: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="proceed")
        {
            let destVC = segue.destination as! add2VC
            destVC.age = self.ageTf.text ?? "Empty"
            destVC.species = self.searchTxtBox.text ?? "Empty"
            destVC.diameter = self.diameterTf.text ?? "Empty"
            destVC.height = self.heightTf.text ?? "Empty"
            destVC.imgData = self.imgData
            destVC.coord = self.coord
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add"
        infoLbl.text = "Hi, "+globalUser.givenName+". Follow the instructions below to add a tree to our servers."
        setUpLocation()
        setUpSearchBox()
        self.hideKeyboardWhenTappedAround()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
            }
        })
    }
    
    func setUpSearchBox(){

        let item1 = SearchTextFieldItem(title: "Khejri", subtitle: "Prosopis cineraria")
        let item2 = SearchTextFieldItem(title: "Desert Date", subtitle: "Balanites aegyptiaca")
        let item3 = SearchTextFieldItem(title: "Jujube", subtitle: "Ziziphus jujuba")
        let item4 = SearchTextFieldItem(title:"Castor", subtitle:"Ricinus communis")
        let item5 = SearchTextFieldItem(title:"Sheesham", subtitle:"Tecomella Undulata")
        let item6 = SearchTextFieldItem(title:"Kair", subtitle:"Capparis decidua")
        let item7 = SearchTextFieldItem(title:"Khair", subtitle:"Acacia catechu")
        let item8 = SearchTextFieldItem(title:"Haar Singaar", subtitle:"Nyctanthes arbor-tristis")
        let item9 = SearchTextFieldItem(title:"Bel", subtitle:"Aegle marmelos")
        let item10 = SearchTextFieldItem(title:"Saptaparni", subtitle:"Alstonia Scholars")
        let item11 = SearchTextFieldItem(title:"Ankol", subtitle:"Alangium salvifolium")
        let item12 = SearchTextFieldItem(title:"Agar", subtitle:"Aquilaria agallocha")
        let item13 = SearchTextFieldItem(title:"Hingan, Ingudi", subtitle:"Balanties aegyptiaca")
        let item14 = SearchTextFieldItem(title:"Bhurja, Bhojpatra", subtitle:"Betula utilis")
        let item15 = SearchTextFieldItem(title:"Salai guggul", subtitle:"Bowellia serrata")
        let item16 = SearchTextFieldItem(title:"Chironji", subtitle:"Buchanania cochinchinensis")
        let item17 = SearchTextFieldItem(title:"Palash", subtitle:"Butea monosperma")
        let item18 = SearchTextFieldItem(title:"Dhup", subtitle:"Canarium stricturn")
        let item19 = SearchTextFieldItem(title:"Indian Labernum", subtitle:"Cassia fistula")
        let item20 = SearchTextFieldItem(title:"Guggul", subtitle:"Commiphora wighti")
        let item21 = SearchTextFieldItem(title:"Shisham", subtitle:"Dalbergia")
        let item22 = SearchTextFieldItem(title:"Amla", subtitle:"Emblica officinalis")
        let item23 = SearchTextFieldItem(title:"Kokam", subtitle:"Garcinia indica G. gummi gutta")
        let item24 = SearchTextFieldItem(title:"Dikamali", subtitle:"Gardenia gummifera/ G. resinifera")
        let item25 = SearchTextFieldItem(title:"Gamar, Shivan", subtitle:"Gmelina arborea")
        let item26 = SearchTextFieldItem(title:"Kutaja", subtitle:"Holarrhena pubescens")
        let item27 = SearchTextFieldItem(title:"Chaulmoogra", subtitle:"Juniperus macropoda")
        let item28 = SearchTextFieldItem(title:"Hapushaa", subtitle:"Juniperus macropoda")
        let item29 = SearchTextFieldItem(title:"Jarul", subtitle:"Lagerstroemia speciosa")
        let item30 = SearchTextFieldItem(title:"Milada lakadi", subtitle:"Litsea glutinosa")
        let item31 = SearchTextFieldItem(title:"Indian Kamla", subtitle:"Mallotus philipinensis")
        let item32 = SearchTextFieldItem(title:"Mango", subtitle:"Mangifera Indica (Country variety)")
        let item33 = SearchTextFieldItem(title:"Nagchampa”, subtitle:”Mesua ferrea")
        let item34 = SearchTextFieldItem(title:"Champa", subtitle:"Michelia champaca")
        let item35 = SearchTextFieldItem(title:"Dhup", subtitle:"Canarium stricturn")
        let item36 = SearchTextFieldItem(title:"Bakul", subtitle:"Mimusopselengi")
        let item37 = SearchTextFieldItem(title:"Narkya", subtitle:
            "Nothapodyyates ovata")
        let item38 = SearchTextFieldItem(title:"Surangi", subtitle:"Ochrocarpus longifolius")
        let item39 = SearchTextFieldItem(title:"Tetu", subtitle:"Oroxylon indicum")
        let item40 = SearchTextFieldItem(title:"Karanj", subtitle:"Pongamia pinnata")
        let item41 = SearchTextFieldItem(title:"Agnimantha", subtitle:"Premna integrifolia")
        let item42 = SearchTextFieldItem(title:"Rakta Chandan", subtitle:"Pretocarpus santalinus")
        let item43 = SearchTextFieldItem(title:"Khakha", subtitle:"Salvadora persica")
        let item44 = SearchTextFieldItem(title:"Chandan", subtitle:"Santalum album")
        let item45 = SearchTextFieldItem(title:"Soapnut", subtitle:"Sapindus emarginatus")
        let item46 = SearchTextFieldItem(title:"Sita Ashok", subtitle:"Saraca asoca")
        let item47 = SearchTextFieldItem(title:"Ghantifal", subtitle:"Schrebera swietenioidess")
        let item48 = SearchTextFieldItem(title:"Biba", subtitle:"Semecapus anacardium")
        let item49 = SearchTextFieldItem(title:"Gum Karaya", subtitle:"Sterculia urens")
        let item50 = SearchTextFieldItem(title:"Padal", subtitle:"Stereospermum chelonioides")
        let item51 = SearchTextFieldItem(title:"Kuchala, Nux Vomica", subtitle:"Strychnos nux-vomica")
        let item52 = SearchTextFieldItem(title:"Clearing nut, Kataka Cham Nirmali", subtitle:"Strychnos potatorum")
        let item53 = SearchTextFieldItem(title:"Lodh", subtitle:"Symplocos racemosa")
        let item54 = SearchTextFieldItem(title:"Jamun", subtitle:"Syzygium cumin")
        let item55 = SearchTextFieldItem(title:"T alispatra", subtitle:"T axus wallichiana")
        let item56 = SearchTextFieldItem(title:"Marwar Teak, Rohitak", subtitle:"T ecomella undulata")
        let item57 = SearchTextFieldItem(title:"Arjun", subtitle:"T erminalia arjuna")
        let item58 = SearchTextFieldItem(title:"Behada", subtitle:"T erminalia belerica")
        let item59 = SearchTextFieldItem(title:"Hirda", subtitle:"T erminalia chebula")
        let item60 = SearchTextFieldItem(title:"Ral", subtitle:"Vateria indica")
        let item61 = SearchTextFieldItem(title:"Indian Almond", subtitle:"Terminalia catappa")
        let item62 = SearchTextFieldItem(title:"Banyan", subtitle:"Ficus Brnghalensis")
        let item63 = SearchTextFieldItem(title:"Gulmohar", subtitle:"Delonix regia")
        let item64 = SearchTextFieldItem(title:"Coconut palm", subtitle:"Cocos nucifera")
        let item65 = SearchTextFieldItem(title:"Neem", subtitle:"Azadirachta indica")
        let item66 = SearchTextFieldItem(title:"Sacred Fig", subtitle:"Ficus religiosa")
        let item67 = SearchTextFieldItem(title:"Teak", subtitle:"Tectona grandis")
        let item68 = SearchTextFieldItem(title:"Champa", subtitle:"Plumeria rubra")
        let item69 = SearchTextFieldItem(title:"Asoka", subtitle:"Saraca indica")
        let item70 = SearchTextFieldItem(title:"Baobab", subtitle:"Adansonia digitata")
        let item71 = SearchTextFieldItem(title:"Jackfruit", subtitle:"A. Heterophylla")
        let item72 = SearchTextFieldItem(title:"Papaya", subtitle:"Carica papaya")
        let item73 = SearchTextFieldItem(title:"Royal Palm", subtitle:"Roystonea regia")
        let item74 = SearchTextFieldItem(title:"Bael", subtitle:"Aegle marmelos")
        let item75 = SearchTextFieldItem(title:"Amla", subtitle:"Phyllanthus emblica")
        let item76 = SearchTextFieldItem(title:"White Sandalwood", subtitle:"Santalum album")
        let item77 = SearchTextFieldItem(title:"Rubber fig", subtitle:"Ficus elastica")
        let item78 = SearchTextFieldItem(title:"Common Fig", subtitle:"Ficus carica")
        let item79 = SearchTextFieldItem(title:"Peepal", subtitle:"Ficus religiosa")
        let item80 = SearchTextFieldItem(title:"Bargad", subtitle:"Ficus bengalensis")
        
        

        searchTxtBox.filterItems([item1, item2, item3, item4, item5, item6, item7,item8,item9,item10,item11,item12,item13,item14,item15,item16,item17,item18,item19,item20,item21,item22,item23,item24,item25,item26,item27,item28,item29,item30,item31,item32,item33,item34,item35,item36,item37,item38,item39,item40,item41,item42,item43,item44,item45,item46,item47,item48,item49,item50,item51,item52,item53,item54,item55,item56,item57,item58,item59,item60,item61,item62,item63,item64,item65,item66,item67,item68,item69,item70,item71,item72,item73,item74,item75,item76,item77,item78,item79,item80])
        searchTxtBox.theme.font = UIFont.systemFont(ofSize: 18)
        searchTxtBox.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        searchTxtBox.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        searchTxtBox.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        searchTxtBox.theme.cellHeight = 50

    }
    @IBAction func cameraBtn(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let img = pickedImage.jpeg(.low)
            self.imgData = img
            print(pickedImage.size)
            thumbnail.image = pickedImage
            self.imagePicker.dismiss(animated: true, completion: nil)
        }

    }
    @IBAction func proceedClicked(_ sender: Any) {
        if(self.imgData==nil){
            showAlert(msg: "You cannot proceed without selecting an image to upload.")
        }else{
            self.performSegue(withIdentifier: "proceed", sender: nil)
        }
    }
    func resetFields(){
        self.imgData = nil
        self.searchTxtBox.text = ""
        self.heightTf.text = ""
    }
    @IBAction func openLink(_ sender: Any) {
        
        let svc = SFSafariViewController(url: URL(string:"http://flowersofindia.net/treeid/index.html")!)
        present(svc, animated: true, completion: nil)
    }
}

