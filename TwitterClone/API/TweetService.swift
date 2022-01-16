//
//  TweetService.swift
//  TwitterClone
//
//  Created by Fenominall on 12/19/21.
//

import Foundation
import Firebase

typealias FetchTweetsCompletion = (([Tweet]) -> Void)

// MARK: - Service for uploading tweets to Firebase database
struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration,
                     completion: @escaping (DatabaseCompletion)) {
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
            // New autoID will be created for a new tweet-replies structure with the same values as for
            // the reference to replied tweet`s tweetID
            REF_TWEETS_REPLIES.child(tweet.tweetID)
                .childByAutoId().updateChildValues(values,
                                                   withCompletionBlock: completion)
        }
        
    }
    
    /// Fetching for all tweets of all users in the feed controller
    func fetchTweets(completion: @escaping (FetchTweetsCompletion)) {
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
    func fetchTweets(forUser user: User,
                     completion: @escaping (FetchTweetsCompletion)) {
        var tweets: [Tweet] = []
        // fetching tweets for any user tweets by users` "uid"
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            // after getting current fetching user`s tweets` uid, it uses a tweet`s key
            // to go into tweet`s structure and find tweets uid to get the datas
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    /// Fetching a single tweet by tweetID, completion returns a constructed with a dictionary Tweet
    func fetchTweet(withTweetID tweetID: String, completion: @escaping (Tweet) -> Void) {
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(uid: uid) { user in
                // Creating a tweet with the received data
                // Because a user reference is used to create a tweet I will be able to use user data for tweets
                let tweet = Tweet(user: user,tweetID: tweetID, dictionary:  dictionary)
                completion(tweet)
            }
        }
    }
    
    /// Fetching user replies for tweets by uid
    func fetchTweetsReplies(forTweet tweet: Tweet,
                            completion: @escaping (FetchTweetsCompletion)) {
        // creating new list of tweets to store tweet`s replies
        var tweets: [Tweet] = []
        // accessing "tweet-replies" database structure to find a tweet by ID
        REF_TWEETS_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            // constructing a dictionary values for a tweet structure
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            // getting a replied tweet UID reference
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    /// Fetching user`s likes from Database
    func fetchLikes(forUser user: User, completion: @escaping (FetchTweetsCompletion)) {
        // creating new list of tweets to store tweets` likes
        var tweets = [Tweet]()
        // Accessing "user-likes" structure in the database:
        // - Find a user by a uid
        // - Taking all likes on the user provided in the snapshot
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            // retrieving tweet`s ID
            let tweetID = snapshot.key
            // fetching a tweet in a "tweets" structure by tweetID
            self.fetchTweet(withTweetID: tweetID) { receivedTweet in
                // creating a mutable copy of receivedTweet to be able to modify it
                var tweet = receivedTweet
                // after liked tweets were fetched, setting didLike to true, so that all liked tweets` like label will be shown as red
                tweet.didLike = true
                // adding each received tweet to tweets list
                tweets.append(tweet)
                // returning tweets list in a completion that can be used later
                completion(tweets)
            }
        }
    }
    
    
    func likeTweet(tweet: Tweet, completion: @escaping (DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // if tweet was liked and than it liked one more time
        // the count for tweet.likes will be decreased with 1 otherwise count increased by 1
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        // settings the likes value on the "tweets" structure in Database
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            // remove like data from Firebase (unlike Tweet)
            // Accessing user-likes to remove like structure
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { (error, reference) in
                // by provided tweetID removing value from tweet-likes
                REF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        } else {
            // add like data to Firebase (like Tweet)
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { (error, reference) in
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping (Bool) -> ()) {
        // getting current user uid
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // Access user uid in user-likes structure
        REF_USER_LIKES.child(currentUid)
            // searching all user-likes
            .child(tweet.tweetID)
            // observing all the value and return bool if it exists or not
            .observeSingleEvent(of: .value) { snapshot in
                completion(snapshot.exists())
        }
    }
}
