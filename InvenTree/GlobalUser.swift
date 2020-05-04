//
//  GlobalUser.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 21/02/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import Foundation
import Firebase
import JGProgressHUD
class GlobalUser {
    var name:String!
    var email:String!
    var photoUrl:String!
    var treesPlanted:Int!
    var givenName:String!
    init(name:String,email:String,photoUrl:String,treesPlanted:Int,givenName:String) {
        self.name = name
        self.email = email
        self.photoUrl = photoUrl
        self.treesPlanted = treesPlanted
        self.givenName = givenName
    }
    func refreshUser(vc:UIViewController){
        let hud = JGProgressHUD.init()
        hud.show(in: vc.view)
        let check_ref = Database.database().reference().child("user-node").child(splitString(str: self.email, delimiter: "."))
        check_ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String:AnyObject] ?? nil
            if(value != nil){
                hud.dismiss()
                self.treesPlanted = value!["trees-planted"] as! Int
                self.photoUrl = value!["photoURL"] as! String
            }
        }){ (error) in
            hud.dismiss()
            print(error.localizedDescription)
            showAlert(msg: "Could not fetch your account details. You may have connection issues")
        }
    }
}
