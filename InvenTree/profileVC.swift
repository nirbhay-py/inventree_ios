//
//  profileVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 30/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase



class profileVC: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var treesPlantedLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var tblbl: UILabel!
    let c02:Double = 1.15749 * 65
    let stormwater:Double = 2.47053 * 65
    let ap:Double = 52.41663 * 65
    let energy:Double = 49.26375 * 65
    let avoided:Double = 6.32553 * 65
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Profile"
        globalUser.refreshUser(vc: self)
        self.hideKeyboardWhenTappedAround()
        let trees = Double(globalUser.treesPlanted!)
        if(globalUser.photoUrl != ""){
            profilePic.load(url: URL(string: globalUser.photoUrl)!)
            profilePic.roundedImage()
        }
        
        nameLbl.text = globalUser.name
        treesPlantedLbl.text = "You have added " + String(Int(trees)) + " tree(s)"
        let co2res = (trees * c02).round(to:2)
        let stormres = (trees * (stormwater)).round(to:2)
        let apres = (trees * (ap)).round(to:2)
        let energyres = (trees * (energy)).round(to:2)
        let avoidedres = (trees * (avoided)).round(to:2)
        let total = co2res + stormres + apres + energyres + avoidedres
        
        tblbl.text = String("₹"+String((total).round(to: 2)))
        // Do any additional setup after loading the view.
        if(trees<11){
            titleLbl.text = "Seedling"
            descLbl.text = "Based on your statistics, you have just started your journey into the universe of trees with InvenTree, much like a little seedling. We hope you stay put for the entire journey and contribute in every way you can."
        }else if(trees<101){
            titleLbl.text = "Plant"
            descLbl.text = "Based on your statistics, you have become a dedicated member of the InvenTree community and are constantly adding valuable data to our servers, cementing your presence in this world like a growing plant. Continue on this road and become a key factor in saving the world!"
        }else{
            titleLbl.text = "Tree"
            descLbl.text = "Based on your statistics, you’re an invaluable part of the InvenTree community! You are committed to bringing a massive change to your life, and that of everyone around you, much like a large tree. Keep inspiring those around you to follow in your footsteps!"
        }
    }
    @IBAction func showDetails(_ sender: Any) {
        let trees = Double(globalUser.treesPlanted!)
        let co2res = (trees * c02).round(to:2)
        let stormres = (trees * (stormwater)).round(to:2)
        let apres = (trees * (ap)).round(to:2)
        let energyres = (trees * (energy)).round(to:2)
        let avoidedres = (trees * (avoided)).round(to:2)
        let total = co2res + stormres + apres + energyres + avoidedres
        let str = " Total benefits: ₹\(total.round(to: 2))\n CO2 Sequestered: ₹\(co2res)\n Stormwater runoff avoided: ₹\(stormres)\n Air pollution removed: ₹\(apres)\n Total energy usage: ₹\(energyres)\n Total energy emissions avoided: ₹\(avoidedres)"
        showInfo(msg: str)
    }
    
    
}
