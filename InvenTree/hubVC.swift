//
//  hubVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 27/03/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit

class hubVC: UIViewController {

    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        self.title = "Planting Hub"
//        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
        navigationItem.hidesBackButton = true

    }
    

}
