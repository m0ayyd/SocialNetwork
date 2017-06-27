//
//  ViewController.swift
//  SocialNetwork
//
//  Created by the Luckiest on 6/27/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth


class SignInVC: UIViewController {
    @IBOutlet weak var emailTF: FancyField!
    @IBOutlet weak var passwordTF: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("MYD: Unable to authenticate with facebook - \(error!)")
            } else if(result?.isCancelled == true) {
                print("MYD: User cancel authentication")
            } else {
                print("MYD: Authenticated with facebook")
                let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credentials)
            }
        }
    }
    
    
    func firebaseAuth(_ credentials: AuthCredential) {
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("MYD: Unable to authenticate with firebase - \(error!)")
            } else {
                print("MYD: Successfully authenticated with firebase")
            }
        }
    }

    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailTF.text, let password = passwordTF.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("MYD: Email user authenticated with firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("MYD: Unable with authenticate firebase using email")
                        } else {
                            print("MYD: Successfully authenticated with firebase")
                        }
                    })
                }
            })
        }
    }

}

