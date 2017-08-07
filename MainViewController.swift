//
//  MainViewController.swift
//  NexmoTest
//
//  Created by naomi schettini on 2017-07-25.
//  Copyright © 2017 naomi schettini. All rights reserved.
//

import UIKit
import NexmoVerify
import Firebase

class MainViewController: UIViewController, UITextViewDelegate {
    
    //  #pragma mark : IB OUTLETS
    
    /** The UILabel which provides instructions to the user above the text field **/
    @IBOutlet weak var addPhoneNoOrPinLabel: UILabel!
    
    /** The UILabel which appears below the text field **/
    @IBOutlet weak var successLabel: UILabel!

    /** The TextField for entering the user's phone number and Pin **/
    @IBOutlet weak var phoneNoTF: UITextField!
    
    
    //  #pragma mark : Variables
    var isVerified: Bool = false
    
    
    
    // #pragma mark : IB ACTIONS
    @IBAction func didTapSend(_ sender: Any) {
        self.isVerified = verifyUser()
        if (isVerified == false) {
            if ((phoneNoTF.text?.characters.count)! > 4) {
                self.sendPhoneNumberToFirbase()
                self.successLabel.text = "Sending you a Pin"
                self.successLabel.isHidden = false
                let result = self.verifyUser()
                if (result == true) {
                    self.successLabel.text = "Please enter your pin"
                }
            }
            else if (phoneNoTF.text?.characters.count == 4){
                let response = VerifyClient.checkPinCode(phoneNoTF.text!)
                if (response != nil) {
                    successLabel.isHidden = false
                }
            }
                
            else {
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "Something went wrong"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
        }
        
        else if (isVerified == true) {
            self.successLabel.text = "You've been verified already!"
            self.addPhoneNoOrPinLabel.isHidden = true

        }
        
        else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Something went wrong"
            alert.addButton(withTitle: "OK")
            alert.show()
        }
        
    }
            
    /**
        Clears the TextField after Editing
    **/
    func textViewDidBeginEditing(_ textView: UITextView) {
        phoneNoTF.text = ""
    }

    /**
    Firebase write to database singeton vars
    **/
    var ref : DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successLabel.isHidden = true
        phoneNoTF.delegate = self as? UITextFieldDelegate
    }

    /* 
     Sends phone number entered to Firebase
    */
    func sendPhoneNumberToFirbase() {
        ref =  Database.database().reference()
        if (phoneNoTF.text != "") {
            
            ref?.child("phoneNumbers").setValue(["phoneNo": phoneNoTF.text])
        }
    }
    
    /*
     Sends isVerified bool to Firebase
     */
    func sendVerificationToFirbase() {
        
        ref =  Database.database().reference()
        if (phoneNoTF.text != "") {
            ref?.child("phoneNumbers").child(phoneNoTF.text!).child("isVerified").setValue(["isVerified": self.isVerified])
        }
    }
    
    /**
     Retrieves phone Numbers from FireBase
     **/
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
     
     return bool: if iterated through all cases of the VerifyUser methods, this means the user is already verified
    **/
    func verifyUser() -> Bool {
        let phoneNoToVerify = phoneNoTF.text
        VerifyClient.getVerifiedUser(countryCode: "US", phoneNumber: phoneNoToVerify!,
                                     
                                     onVerifyInProgress: {
                                        // Called when the verification process begins.
                                        self.addPhoneNoOrPinLabel.text = "Enter Your Pin"
        },
                                     onUserVerified: {
                                        // Called when the user has been successfully verified.
    
                                        self.addPhoneNoOrPinLabel.text = "Enter Your Pin"
                                        if (self.phoneNoTF.text != "") {
                                            VerifyClient.checkPinCode(self.addPhoneNoOrPinLabel.text!) }
                                        self.isVerified = true
                                        self.sendVerificationToFirbase()
                                        
        },
                                     onError: { (error: VerifyError) in
                                        // Called when an error occurs during verification. For example, the user enters the wrong pin.
                                        // See the VerifyError class for more details.
                                        
                                        self.isVerified = false

                                        

        })
        
        return isVerified == true
    }
    

}



