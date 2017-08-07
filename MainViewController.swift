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
    
    /** The TextField for entering the user's phone number and Pin **/
    @IBOutlet weak var phoneNoTF: UITextField!
    
    /** The UILabel which appears below the text field **/
    @IBOutlet weak var successLabel: UILabel!


    
    
    //  #pragma mark : Variables
    var isVerified: Bool = false
    
    
    
    // #pragma mark : IB ACTIONS
    @IBAction func didTapSend(_ sender: Any) {
        
        getStatus()
        
        if (self.isVerified == false) {
            if ((phoneNoTF.text?.characters.count)! > 4) {
                self.sendPhoneNumberToFirbase()
                self.successLabel.isHidden = false
                self.successLabel.text = "Sending you a Pin"
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
            self.successLabel.isHidden = false
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
        gets the user's verification status
     
     *verified*
     The user has been successfully verified.
     
     *pending*
     A verification request for this user
     is currently in progress.
     
     *new*
     This user just been created on the SDK service
     
     *failed*
     A previous verification request for this
     user has failed.
     
     *expired*
     A previous verification request for this
     user expired.
     
     *unverified*
     A user's verified status has been revoked,
     possibly due to timeout.
     
     *blacklisted*
     This user has failed too many verification
     requests and is therefore blacklisted.
     
     *error*
     An error ocurred during the last verification
     attempt for this user.
     
     *unknown*
     The user is unknown to the SDK service.
     **/
    
    func getStatus() {
        
        VerifyClient.getUserStatus(countryCode: "GB", number: self.phoneNoTF.text!) { status, error in
            if let error = error {
                // unable to get user status for given device + phone number pair
                
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "Something went wrong"
                alert.addButton(withTitle: "OK")
                alert.show()
                
                return
            }
            switch (status!) {
                
            case "pending":
                self.successLabel.isHidden = false
                self.successLabel.text = "pending"
                self.addPhoneNoOrPinLabel.isHidden = false
                self.addPhoneNoOrPinLabel.text = "enter your PIN when it arrives"
                self.isVerified = false

                
            case "verified":
                self.successLabel.isHidden = false
                self.successLabel.text = "verified!"
                self.addPhoneNoOrPinLabel.isHidden = true
                self.isVerified = true
                
            case "new":
                self.successLabel.isHidden = false
                self.successLabel.text = "your number is new"
                self.addPhoneNoOrPinLabel.isHidden = true
                self.isVerified = false

                
                
            case "failed":
                self.successLabel.isHidden = false
                self.successLabel.text = "something went wrong"
                self.addPhoneNoOrPinLabel.isHidden = true
                self.isVerified = false

                
            case "expired":
                self.successLabel.isHidden = false
                self.successLabel.text = "expired :("
                self.addPhoneNoOrPinLabel.isHidden = true
                self.isVerified = false

                
            case "unverified":
                self.successLabel.isHidden = false
                self.successLabel.text = "not yet verified!"
                self.addPhoneNoOrPinLabel.isHidden = true
                self.isVerified = false

                
            case "blacklisted":
                self.successLabel.isHidden = false
                self.successLabel.text = "your number is not allowed"
                self.addPhoneNoOrPinLabel.isHidden = true
                self.isVerified = false

                
            case "error":
                self.successLabel.isHidden = false
                self.successLabel.text = "error!"
                self.addPhoneNoOrPinLabel.isHidden = true
                self.isVerified = false

                
            case "unknown":
                self.successLabel.isHidden = false
                self.successLabel.text = "nexmo is sending you an SMS right now"
                self.addPhoneNoOrPinLabel.isHidden = true
                self.isVerified = false

                
            default:
                print("did not execute")
                
            }
            
        }
    }
    
    
    /**
     Verifies user phone number and their pin number sent via sms 
     
     return bool: if iterated through all cases of the VerifyUser methods, this means the user is already verified
    **/
    func verifyUser() -> Bool {
        let phoneNoToVerify = phoneNoTF.text
        VerifyClient.getVerifiedUser(countryCode: "GB", phoneNumber: phoneNoToVerify!,
                                     
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
        
        return isVerified
    }
    

}



