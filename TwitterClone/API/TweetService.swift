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
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping (Error?, DatabaseReference) -> Void) {
        // Get user uid from the database to need to know who made a tweet
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Structure for uploading to database as a single tweet
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        switch type {
        case .tweet:
            // storing a reference to a tweet structures in Firebase database
            let reference = REF_TWEETS.childByAutoId()
            // By provided "uid" from the current-user, a new tweet structure with a unique "uid"
            // and reference to a current-user "uid" will be created and uploaded to tweet structures tree in database
            reference.updateChildValues(values) { (error, ref) in
                // getting a created tweet by a key provided from
                // a reference of uploaded tweets by a current-user "uid"
                guard let tweetID = ref.key else { return }
                // update user-tweet structure
                REF_USER_TWEETS.child(uid)
                    .updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            // New autoID will be created for a new user-tweets structure with the same values as for
            // the reference to replied tweet`s tweetID
            REF_TWEETS_REPLIES.child(tweet.tweetID)
                .childByAutoId().updateChildValues(values,
                                                   withCompletionBlock: completion)
        }
    
    }
    
    /// Fetching for all tweets of all users in the feed controller
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        
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
    
    /// Fetching for current user tweets in Users profile
    func fetchTweets(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        // fetching tweets for any user tweets by users` "uid"
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            // after getting current fetching user`s tweets` uid, it uses a tweet`s key
            // to go into tweet`s structure and find tweets uid to get the datas
            let tweetID = snapshot.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
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
}
