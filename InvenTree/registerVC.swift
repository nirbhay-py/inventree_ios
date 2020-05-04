//
//  registerVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 26/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class registerVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var pswdTf: UITextField!
    @IBOutlet weak var verifyTf: UITextField!
    let imagePicker = UIImagePickerController()
    var imgData:Data!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func uploadImg(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let img = pickedImage.jpeg(.low)
            self.imgData = img
            print(pickedImage.size)
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func createAcc(_ sender: Any) {
        var photoURL:String=""
        let hud = JGProgressHUD.init()
        if(nameTf.text == ""||emailTf.text==""||pswdTf.text==""||verifyTf.text==""){
            showAlert(msg: "You can't leave these fields empty.")
        }else if(pswdTf.text!.count < 8){
            showAlert(msg: "You need to choose a longer password.")
        }else if(pswdTf.text != verifyTf.text){
            showAlert(msg: "Your passwords don't match")
        }else if(self.imgData==nil){
            showAlert(msg: "Please choose a profile picture to upload.")
        }else if (!(isValidEmail(emailTf.text!))){
            showAlert(msg: "That doesn't look like a valid email.")
        }else{
            hud.show(in: self.view)
            Auth.auth().createUser(withEmail: emailTf.text!, password: pswdTf.text!) { authResult, error in
                if(error != nil){
                    hud.dismiss()
                    showAlert(msg: "An error occured while signing up. \(error)")
                }else{
                    //user has been created.
                    // step-1 create node in firebase db
                    // step-2 init userclass instance
                    // step-3 perform segue
                    var downloadUrl:URL!
                    let storage = Storage.storage()
                    let ref = Database.database().reference().child("user-node").child(splitString(str: self.emailTf.text!, delimiter: "."))
                    let st_ref = storage.reference().child("user-imgs").child(ref.key!)
                    _ = st_ref.putData(self.imgData, metadata: nil) { (metadata, error) in
                                   if(error != nil){
                                       showAlert(msg: error!.localizedDescription)
                                       hud.dismiss()
                                   }else{
                                      st_ref.downloadURL { (url, error) in
                                        if(error != nil){
                                            showAlert(msg: error!.localizedDescription)
                                            hud.dismiss()
                                        }else if(url != nil){
                                           print("URL fetched with success.\n")
                                           downloadUrl = url!
                                            photoURL = downloadUrl.absoluteString
                                           let userDic:[String:Any]=[
                                            "email":self.emailTf.text,
                                            "name":self.nameTf.text,
                                            "trees-planted":0,
                                            "givenName":self.nameTf.text,
                                            "photoURL":downloadUrl.absoluteString
                                           ];
                                           ref.setValue(userDic) { (error, ref) -> Void in
                                               if(error == nil){
                                                globalUser.name = self.nameTf.text!
                                                globalUser.email = self.emailTf.text!
                                                globalUser.givenName = self.nameTf.text!
                                                globalUser.photoUrl = photoURL
                                                globalUser.treesPlanted = 0
                                                hud.dismiss()
                                                showSuccess(msg: "Signed in with success!")
                                                self.performSegue(withIdentifier: "toOnboard", sender: self)
                                               }
                                               else{
                                                   hud.dismiss()
                                                   showAlert(msg: error!.localizedDescription)
                                               }
                                           }
                                        }
                                    else{
                                    showAlert(msg: "Check your network, you may have issues.")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    @IBAction func takePic(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
           navigationController?.setNavigationBarHidden(false, animated: animated)
       }
       override func viewWillDisappear(_ animated: Bool) {
           navigationController?.setNavigationBarHidden(true, animated: animated)
       }
}
