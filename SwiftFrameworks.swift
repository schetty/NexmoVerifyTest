//
//  SwiftFrameworks.swift
//  NexmoTest
//
//  Created by naomi schettini on 2017-07-27.
//  Copyright © 2017 naomi schettini. All rights reserved.
//

import Foundation
import NexmoVerify

public class SwiftFrameworks {
    
    public init (){
        print("Class has been initialised")
    }
    
    public func sendSMS(){
    print("this user wants an SMS")
        VerifyClient.getVerifiedUser(countryCode: "US", phoneNumber: "07000000000",
                                     onVerifyInProgress: {
                                        // Called when the verification process begins.
        },
                                     onUserVerified: {
                                        // Called when the user has been successfully verified.
        },
                                     onError: { (error: VerifyError) in
                                        // Called when an error occurs during verification. For example, the user enters the wrong pin.
                                        // See the VerifyError class for more details.
        }
        )
    }
}
