//
//  tbC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 10/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
import StoreKit
class tbC: UITabBarController {
    @objc func rateTapped(){
        SKStoreReviewController.requestReview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rate us ⭐️", style: .plain, target: self, action: #selector(rateTapped))
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
