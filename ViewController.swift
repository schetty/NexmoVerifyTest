//
//  ViewController.swift
//  NexmoTest
//
//  Created by naomi schettini on 2017-07-25.
//  Copyright © 2017 naomi schettini. All rights reserved.
//

import UIKit
import NexmoVerify
import Firebase

class ViewController: UIViewController {
    
  //  #pragma mark : IB OUTLETS
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var successLabel: UILabel!
   
    
   // #pragma mark : IB ACTIONS
    @IBAction func didTapSend(_ sender: Any) {
    }
    
    
   // #pragma mark : Firebase write to database singeton vars
    var ref: DatabaseReference!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

    }


}

