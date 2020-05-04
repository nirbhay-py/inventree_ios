//
//  treeKeyVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 08/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit

class treeKeyVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    let pickerData:[String]=["Rajasthan","Delhi"];
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBOutlet weak var tv: UITextView!
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Planting Hub"
        self.hideKeyboardWhenTappedAround()
        picker.dataSource = self
        picker.delegate = self
        tv.isHidden = true
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    @IBAction func goPressed(_ sender: Any) {
        tv.isHidden = false
    }
}
