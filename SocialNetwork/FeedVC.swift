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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImg: CiricleImage!
    @IBOutlet weak var captionTF: FancyField!
    
    static var imageCache = NSCache<NSString, UIImage>()
    
    var posts: [Post] = []
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? [String:Any] {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell =  tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
           return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImg.image = image
            imageSelected = true
        } else {
            print("MYD: valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    

    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func signoutTapped(_ sender: Any) {
        let keychainRes = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("MYD: ID removed from keychain \(keychainRes)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "SignInVC", sender: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionTF.text, caption != "" else {
            print("MYD: Caption must be entered")
            return
        }
        
        guard let img = addImg.image, imageSelected else {
            print("MYD: Image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            let imageUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUid).putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("MYD: Unable to upload image to firebase")
                } else {
                    print("MYD: Successfully uploaded image to firebase storage")
                    if let downloadUrl = metadata?.downloadURL()?.absoluteString {
                        self.postToFirebase(imgUrl: downloadUrl)
                    }
                }
            })
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: [String:Any] = [
            "caption": captionTF.text!,
            "imageUrl": imgUrl,
            "likes": 0
        ]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionTF.text = ""
        imageSelected = false
        addImg.image = UIImage(named: "add-image")
        tableView.reloadData()
    }
    

}
