//
//  NFPhoneAuthProvider.swift
//  NetworkingWithFirebase
//
//  Created by Gokul Sai Katragadda on 4/8/20.
//  Copyright © 2020 AppFactory. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth

public enum NFPhoneAuthError: Error {
    case invalidPhoneNumber
    case quotaExceeded
    case recaptchafailed
    case invalidSMSCode
    case sessionExpired
    case generic(description: String)
}

public struct NFPhoneAuthUser {
    let name: String
    let phoneNumber: String
    let photoURL: String?
}

public protocol NFPhoneAuthProvidable {
    func verify(_ phoneNumber: String) -> Future<Void, NFPhoneAuthError>
    func verifySMSCode(code: String) -> Future<Void, NFPhoneAuthError>
    func set(displayName: String, picture: Data) -> Future<NFPhoneAuthUser, NFPhoneAuthError>
}

protocol FIRPhoneAuthProvider {
    func verifyPhoneNumber(_ phoneNumber: String, uiDelegate UIDelegate: AuthUIDelegate?, completion: VerificationResultCallback?)
}

protocol FIRAuthProvider {
    func signIn(with credential: AuthCredential, completion: AuthDataResultCallback?)
}

extension PhoneAuthProvider: FIRPhoneAuthProvider {}
extension Auth: FIRAuthProvider {}

class NFPhoneAuthProvider: NFPhoneAuthProvidable {
    let firPhoneAuthProvider: FIRPhoneAuthProvider
    let firAuthProvider: FIRAuthProvider
    
    var verificationID: String?

    init(firPhoneAuthProvider: FIRPhoneAuthProvider,
         firAuthProvider: FIRAuthProvider) {
        self.firPhoneAuthProvider = firPhoneAuthProvider
        self.firAuthProvider = firAuthProvider
    }
    
    convenience init() {
        self.init(firPhoneAuthProvider: PhoneAuthProvider.provider(),
                  firAuthProvider: Auth.auth())
    }
    
    func set(displayName: String, picture: Data) -> Future<NFPhoneAuthUser, NFPhoneAuthError> {
        return Future<NFPhoneAuthUser, NFPhoneAuthError>.init { promise in
            promise(.failure(.generic(description: "")))
            
        }
    }
    
    func verify(_ phoneNumber: String) -> Future<Void, NFPhoneAuthError> {
        return Future<Void, NFPhoneAuthError> { [weak self] promise in
            self?.firPhoneAuthProvider.verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    promise(.failure(.invalidPhoneNumber))
                }
                
                if let id = verificationID {
                    //sms is sent to user, get the verification code from user
                    self?.verificationID = id
                    promise(.success(()))
                }
            }
        }
    }
    
    func verifySMSCode(code: String) -> Future<Void, NFPhoneAuthError> {
        return Future<Void, NFPhoneAuthError> { (promise) in
            promise(.failure(.invalidPhoneNumber))
        }
    }
}

private extension NFPhoneAuthProvider {
    func signIn(credential: PhoneAuthCredential) {
        firAuthProvider.signIn(with: credential) { (authResult, error) in
            if let error = error {
                
            }
            
            if let authResult = authResult {
                let user = authResult.user
            }
        }
    }
}
