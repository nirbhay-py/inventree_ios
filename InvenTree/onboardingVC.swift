//
//  onboardingVC.swift
//  InvenTree
//
//  Created by Nirbhay Singh on 30/04/20.
//  Copyright © 2020 Nirbhay Singh. All rights reserved.
//

import UIKit
class onboardingVC: UIViewController {
    @IBOutlet weak var const1: NSLayoutConstraint!
    @IBOutlet weak var const2: NSLayoutConstraint!
    @IBOutlet weak var const3: NSLayoutConstraint!
    @IBOutlet weak var const4: NSLayoutConstraint!
    @IBOutlet weak var const5: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        setUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        animate()
    }
    
    func setUp(){
        const1.constant -= self.view.bounds.width
        const2.constant -= self.view.bounds.width
        const3.constant -= self.view.bounds.width
        const4.constant -= self.view.bounds.width
        const5.constant -= self.view.bounds.width
        self.view.layoutIfNeeded()
    }
    func animate(){
        UIView.animate(withDuration: 0.5, animations: {
            self.const1.constant += self.view.bounds.width
            self.const2.constant += self.view.bounds.width
            self.const3.constant += self.view.bounds.width
            self.const4.constant += self.view.bounds.width
            self.const5.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        })
    }
}
