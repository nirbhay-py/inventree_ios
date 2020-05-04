//
//  cellDetailsVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 27/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
class tableCell3:UITableViewCell{
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
}
class cellDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var attendees:[Attendee]=[]
    @IBOutlet weak var indicatorLbl: UILabel!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalDrive.attendees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell3
        let i = indexPath.row
        cell.emailLbl.text = self.attendees[i].email
        if(self.attendees[i].photoUrl != "" || self.attendees[i].photoUrl != "Empty"){
            cell.profilePic.load(url: URL(string: self.attendees[i].photoUrl)!)
        }
        
        cell.nameLbl.text = self.attendees[i].name
        cell.profilePic.roundedImage()
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Planting Hub"
        print(globalDrive.attendees)
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        if(globalDrive.attendees.count==0){
            showAlert(msg: "No one else has joined your drive yet.")
            indicatorLbl.text = "No one else has joined your drive."
            indicatorLbl.textColor = UIColor.systemRed
            tableView.isHidden = true
        }else{
            indicatorLbl.text = "You have \(globalDrive.attendees.count) other attendee(s)"
        }
        self.attendees = globalDrive.attendees
    }
    


}
