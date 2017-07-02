//
//  Post.swift
//  SocialNetwork
//
//  Created by the Luckiest on 7/2/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        _caption = caption
        _imageUrl = imageUrl
        _likes = likes
    }
    
    init(postKey: String, postData: [String:Any]) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        _postRef = DataService.ds.REF_POSTS.child(postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes! += 1
        } else {
            _likes! -= 1
        }
        
        _postRef.child("likes").setValue(likes)
    }
    
    
}
