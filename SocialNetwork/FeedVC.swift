//
//  FeedVC.swift
//  SocialNetwork
//
//  Created by the Luckiest on 6/29/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
import FirebaseAuth

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func signoutTapped(_ sender: Any) {
        let keychainRes = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("MYD: ID removed from keychain \(keychainRes)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "SignInVC", sender: nil)
    }

}
