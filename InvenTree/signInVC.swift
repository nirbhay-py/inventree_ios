//
//  signInVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 21/02/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import JGProgressHUD


var globalUser:GlobalUser = GlobalUser(name: "", email: "", photoUrl: "", treesPlanted: 0, givenName: "")

class signInVC: UIViewController

{

    @IBOutlet weak var mv: UIView!
    
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var pswdTf: UITextField!
    
    @IBOutlet weak var loginBtn: DesignableButton!
    
    @IBOutlet weak var signUpBtn: DesignableButton!
    
    @IBOutlet weak var forgotpswdBtn: UIButton!
    
    @IBOutlet weak var infoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let firebaseAuth = Auth.auth()
//        do {
//          try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//          print ("Error signing out: %@", signOutError)
//       }
        self.hideKeyboardWhenTappedAround()
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
           if(Auth.auth().currentUser != nil){
               print("user not nil")

               let localHud = JGProgressHUD.init()
               localHud.show(in: self.view,animated: true)
               //MARK:FETCH DATA FROM FIREBASE, INITIALISE A USERCLASS OBJECT AND PASS IT IN THE SEGUE
               var email = Auth.auth().currentUser?.email
               email = splitString(str: email!, delimiter: ".")
               let ref = Database.database().reference().child("user-node").child(email!)
               ref.observeSingleEvent(of: .value, with: {(snapshot) in
                   let value = snapshot.value as? NSDictionary
                   let givenName=value!["givenName"] as! String
                   let name = value!["name"] as! String
                   let email = value!["email"] as! String
                   let photoURL = value!["photoURL"] as! String
                   let treesPlanted = value!["trees-planted"] as! Int
                   globalUser = GlobalUser(name: name, email: email, photoUrl: photoURL, treesPlanted: treesPlanted, givenName: givenName)
                   localHud.dismiss()
                   self.performSegue(withIdentifier: "toDashboard", sender: self)
               }){ (error) in
                   print(error.localizedDescription)
                   showAlert(msg: error.localizedDescription)
               }
           }
       }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }    
    @IBAction func loginPressed(_ sender: Any) {
        print("loginPressed")
        if(emailTf.text != "" && pswdTf.text != ""){
            let hud = JGProgressHUD.init()
            hud.show(in: self.view)
            Auth.auth().signIn(withEmail: emailTf.text!, password: pswdTf.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
                if(error != nil){
                    hud.dismiss()
                    showAlert(msg: "An error occured. \(error)")
                }else{
                    var email = self!.emailTf.text!
                    email = splitString(str: email, delimiter: ".")
                    let ref = Database.database().reference().child("user-node").child(email)
                    ref.observeSingleEvent(of: .value, with: {(snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let givenName=value!["givenName"] as! String
                        let name = value!["name"] as! String
                        let email = value!["email"] as! String
                        let photoURL = value!["photoURL"] as! String
                        let treesPlanted = value!["trees-planted"] as! Int
                        globalUser = GlobalUser(name: name, email: email, photoUrl: photoURL, treesPlanted: treesPlanted, givenName: givenName)
                        hud.dismiss()
                        self!.performSegue(withIdentifier: "toDashboard", sender: self)
                    }){ (error) in
                        print(error.localizedDescription)
                        showAlert(msg:"An error occured. Your email address may be badly formatted, or the email-password combination may be incorrect. Please re-try.")
                    }
                }
        }
        }else{
            showAlert(msg: "You can't leave these fields blank.")
        }
    }
    @IBAction func showSignInInfo(_ sender: Any) {
        showInfo(msg: "In order to protect the integrity of our database and prevent any tampering with our users' data, we require users to be signed in via our secure and custom authentication system. Rest assured, your data will never be shared with anyone else.")
    }
}
