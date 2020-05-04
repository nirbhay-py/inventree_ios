//
//  editProfileVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 28/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
class editProfileVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    var imgData:Data!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Profile"
        mainImg.load(url: URL(string: globalUser.photoUrl)!)
        mainImg.roundedImage()
        nameLbl.text =  globalUser.givenName
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "logout", sender: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
    }
    @IBAction func takePic(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func choosePic(_ sender: Any) {
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
            self.uploadImg()
        }
    }
    
    func uploadImg(){
        let localHud = JGProgressHUD.init()
        localHud.show(in: self.view)
        var downloadUrl:URL!
        let storage = Storage.storage()
        let ref = Database.database().reference().child("user-node").child(splitString(str: globalUser.email, delimiter: "."))
        let st_ref = storage.reference().child("user-imgs").child(ref.key!)
        _ = st_ref.putData(self.imgData, metadata: nil) { (metadata, error) in
                       if(error != nil){
                           showAlert(msg: error!.localizedDescription)
                           localHud.dismiss()
                       }else{
                          st_ref.downloadURL { (url, error) in
                            if(error != nil){
                                showAlert(msg: error!.localizedDescription)
                                localHud.dismiss()
                            }else if(url != nil){
                               print("URL fetched with success.\n")
                               downloadUrl = url!
                               let updateDic = [
                                    "photoURL":downloadUrl.absoluteString
                                ]
                               ref.updateChildValues(updateDic) { (error, ref) -> Void in
                                   if(error == nil){
                                    globalUser.photoUrl = downloadUrl.absoluteString
                                    self.mainImg.load(url: downloadUrl)
                                    self.mainImg.load(url: downloadUrl)
                                    localHud.dismiss()
                                   }
                                   else{
                                       localHud.dismiss()
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var pswdTf: UITextField!
    @IBAction func updatePswd(_ sender: Any) {
        if(pswdTf.text==""){
            showAlert(msg: "Can't leave this field blank.")
        }
        else if(pswdTf.text!.count<8){
            showAlert(msg: "Choose a longer password!")
        }else{
            let hud = JGProgressHUD.init()
            hud.show(in: self.view)
            Auth.auth().currentUser?.updatePassword(to: pswdTf.text!) { (error) in
                if(error==nil){
                    hud.dismiss()
                    showSuccess(msg: "Updated with success")
                }else{
                    hud.dismiss()
                    showAlert(msg: "An error occured. You may be having connectivity issues or you may need to sign-in again in order to complete this operation.")
                }
            }
        }
    }
}
