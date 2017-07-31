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
    @IBOutlet weak var addPhoneNoOrPinLabel: UILabel!
    
    
   // #pragma mark : IB ACTIONS
    @IBAction func didTapSend(_ sender: Any) {
        sendPhoneNumberToFirbase()
        successLabel.text = "Sending you a Pin"
        successLabel.isHidden = false
        let result = verifyUser()
        if (result == true) {
            successLabel.text = "Please enter your pin"
        }
    }

    // #pragma mark : Firebase write to database singeton vars
    var ref : DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successLabel.isHidden = true

    }

    
    func sendPhoneNumberToFirbase() {
        ref =  Database.database().reference()
        if (phoneNoTF.text != "") {
            
            ref?.child("phoneNumbers").setValue(["phoneNo": phoneNoTF.text])
        }
    }
    
    func getPhoneNumber() -> String {
        ref =  Database.database().reference()
        var phoneStr = ""
        ref?.child("phoneNumbers").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            phoneStr = value?["phoneNo"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return phoneStr
    }
    
    /**
     Verifies user phone number and their pin number sent via sms 
    **/
    func verifyUser() -> Bool {
        var isVerified = false
        let phoneNoToVerify = phoneNoTF.text
        VerifyClient.getVerifiedUser(countryCode: "US", phoneNumber: phoneNoToVerify!,
                                     
                                     onVerifyInProgress: {
                                        // Called when the verification process begins.
        },
                                     onUserVerified: {
                                        // Called when the user has been successfully verified.
                                        
                                        let success = "succeeded"
                                        self.addPhoneNoOrPinLabel.text = "Enter Your Pin"
                                        if (self.phoneNoTF.text != "") {
                                            VerifyClient.checkPinCode(self.addPhoneNoOrPinLabel.text!) }
                                        isVerified = true
                                        
        },
                                     onError: { (error: VerifyError) in
                                        // Called when an error occurs during verification. For example, the user enters the wrong pin.
                                        // See the VerifyError class for more details.
                                        
                                        isVerified = false

                                        

        })
        
        return isVerified
    }
    

}

