//
//  resetPswdVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 28/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
class resetPswdVC: UIViewController {

    @IBOutlet weak var mainTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func done(_ sender: Any) {
        if(mainTf.text==""){
            showAlert(msg: "You can't leave this field empty.")
        }else{
            let hud = JGProgressHUD.init()
            hud.show(in: self.view)
            Auth.auth().sendPasswordReset(withEmail: mainTf.text!) { error in
                if(error != nil){
                    hud.dismiss()
                    showAlert(msg: error!.localizedDescription)
                    self.performSegue(withIdentifier: "back", sender: nil)
                }else{
                    hud.dismiss()
                    showSuccess(msg: "Reset mail sent!")
                    self.performSegue(withIdentifier: "back", sender: nil)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
