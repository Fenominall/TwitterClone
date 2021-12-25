//
//  TweetService.swift
//  TwitterClone
//
//  Created by Fenominall on 12/19/21.
//

import Foundation
import Firebase

// MARK: - Service for uploading tweets to Firebase database
struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        // Get user uid from the database to need to know who made a tweet
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Structure for uploading to database as a single tweet
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        // storing a reference to a tweet structures in Firebase database
        let reference = REF_TWEETS.childByAutoId()
        // By provided "uid" from the current-user, a new tweet structure with a unique "uid"
        // and reference to a current-user "uid" will be created and uploaded to tweet structures tree in database
        reference.updateChildValues(values) { (error, ref) in
            // getting a created tweet by a key provided from
            // a reference of uploaded tweets by a current-user "uid"
            guard let tweetID = ref.key else { return }
            // update user-tweet structure
            REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            // Constructing a fetched tweet structure into dictionary
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            // Getting uid key from a tweet
            let tweetID = snapshot.key
            // getting a user unique id reference from the database
            guard let uid = dictionary["uid"] as? String else { return }
            // Fetching user by received uid to get the corresponding data
            UserService.shared.fetchUser(uid: uid) { user in
                // Creating a tweet with the received data
                // Because a user reference is used to create a tweet I will be able to use user data for tweets
                let tweet = Tweet(user: user,tweetID: tweetID, dictionary:  dictionary)
                // adding a tweet to the tweets list
                tweets.append(tweet)
                completion(tweets)
            }
            
        }
    }
}
