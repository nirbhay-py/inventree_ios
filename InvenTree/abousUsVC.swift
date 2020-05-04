//
//  abousUsVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 08/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase
import SafariServices
class abousUsVC: UIViewController {
    @IBOutlet weak var tf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About Us"
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    @IBAction func submit(_ sender: Any) {
        if(tf.text==""){
            showAlert(msg: "You can't send a blank message!")
        }else{
            let hud = JGProgressHUD.init()
            hud.show(in: self.view)
            let ref = Database.database().reference().child("msgs-node").childByAutoId()
            let dic:[String:String]=[
                "email":globalUser.email,
                "name":globalUser.givenName,
                "msg":tf.text!
            ]
            ref.setValue(dic) {(error,ref) -> Void in
                if(error==nil){
                    hud.dismiss()
                    showSuccess(msg: "Your message has been recorded")
                }else{
                    hud.dismiss()
                    showAlert(msg: "Unfortunately, your message could not be recorded at this time. Please check your connection.")
                }
            }
        }
    }
    
    @IBAction func linkPresses(_ sender: Any) {
        let svc = SFSafariViewController(url: URL(string:"http://inventree.co.in/privacy-policy")!)
        present(svc, animated: true, completion: nil)
    }
    @IBAction func weblink(_ sender: Any) {
        let svc = SFSafariViewController(url: URL(string:"http://inventree.co.in")!)
               present(svc, animated: true, completion: nil)
    }
}
