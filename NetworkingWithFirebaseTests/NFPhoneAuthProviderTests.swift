//
//  NFPhoneAuthProviderTests.swift
//  NetworkingWithFirebaseTests
//
//  Created by Gokul Sai Katragadda on 4/8/20.
//  Copyright © 2020 AppFactory. All rights reserved.
//

import XCTest
import FirebaseAuth

@testable import NetworkingWithFirebase

class NFPhoneAuthProviderTests: XCTestCase {
    var subject: NFPhoneAuthProvidable!
    var fakePhoneAuthProvider: FakeFIRPhoneAuthProvider!
    var fakeAuthProvider: FakeFIRAuthProvider!

    override func setUp() {
        fakePhoneAuthProvider = FakeFIRPhoneAuthProvider()
        fakeAuthProvider = FakeFIRAuthProvider()
        subject = NFPhoneAuthProvider(firPhoneAuthProvider: fakePhoneAuthProvider,
                                      firAuthProvider: fakeAuthProvider)
    }

    
    func testVerifyPhoneNumberShouldCallFirebaseAuth() {
        subject.verify("123456789")
    }
    
    

}

class FakeFIRPhoneAuthProvider: FIRPhoneAuthProvider {
    var phoneNumberReceived = ""
    func verifyPhoneNumber(_ phoneNumber: String, uiDelegate UIDelegate: AuthUIDelegate?, completion: VerificationResultCallback?) {
        phoneNumberReceived = phoneNumber
//        completion?("", "" as! Error)
    }
}

class FakeFIRAuthProvider: FIRAuthProvider {
    func signIn(with credential: AuthCredential, completion: AuthDataResultCallback?) {
        
    }
    
    
}


