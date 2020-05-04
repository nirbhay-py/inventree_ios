//
//  viewBenVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 10/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit

class viewBenVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let tb:Double = 111.63393 * 65
    let co2:Double = 1.15749 * 65
    let stormwater:Double = 2.47053 * 65
    let ap:Double = 52.41663 * 65
    let energy:Double = 49.26375 * 65
    let avoided:Double = 6.32553 * 65
    
    
    let co:Double = 0.1
    let ozone:Double = 8.4
    let no2:Double = 3.49
    let so2:Double = 0.56
    let pm:Double = 0.8
    let es:Double = 203.58
    let fs:Double = 1.27
    
    
    
    @IBOutlet weak var tbLbl: UILabel!
    @IBOutlet weak var co2Lbl: UILabel!
    @IBOutlet weak var stormwaterlbl: UILabel!
    @IBOutlet weak var aplbl: UILabel!
    @IBOutlet weak var energyusglbl: UILabel!
    @IBOutlet weak var avoidedLbl: UILabel!
    @IBOutlet weak var cmonolbl: UILabel!
    @IBOutlet weak var ozonelbl: UILabel!
    @IBOutlet weak var no2lbl: UILabel!
    @IBOutlet weak var so2lbl: UILabel!
    @IBOutlet weak var pmlbl: UILabel!
    @IBOutlet weak var esavingslbl: UILabel!
    @IBOutlet weak var fuelsavingslbl: UILabel!
    
    var treesCount:Int=0
    @IBOutlet weak var treeBen: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+150)


        treeBen.text = "We have a total of \(treesCount) trees uploaded to our database right now. The total annual  benefits to society from these trees are outlined below."
        
        popLbls()
        // Do any additional setup after loading the view.
    }
    
    func popLbls(){
        tbLbl.text = String((Double(treesCount) * tb).round(to: 2))
        co2Lbl.text = String((Double(treesCount) * co2).round(to: 2))
        stormwaterlbl.text = String((Double(treesCount) * stormwater).round(to: 2))
        aplbl.text = String((Double(treesCount) * ap).round(to: 2))
        energyusglbl.text = String((Double(treesCount) * energy).round(to: 2))
        avoidedLbl.text = String((Double(treesCount) * avoided).round(to: 2))
        cmonolbl.text = String((Double(treesCount) * co).round(to: 2))
        ozonelbl.text = String((Double(treesCount) * ozone).round(to: 2))
        no2lbl.text = String((Double(treesCount) * no2).round(to: 2))
        so2lbl.text = String((Double(treesCount) * so2).round(to: 2))
        pmlbl.text = String((Double(treesCount) * pm).round(to: 2))
        esavingslbl.text = String((Double(treesCount) * es).round(to: 2))
        fuelsavingslbl.text = String((Double(treesCount) * fs).round(to: 2))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
