//
//  DBConstants.swift
//  TwitterClone
//
//  Created by Fenominall on 12/11/21.
//

import Foundation
import Firebase

// Firebase access to database
let DB_REF = Database.database().reference()

// Creating a new structure for users
let REF_USERS = DB_REF.child("users")
// Creating a new structure for tweets
let REF_TWEETS = DB_REF.child("tweets")
// Creating a new structure for tweets-replies
let REF_TWEETS_REPLIES = DB_REF.child("tweet-replies")
// Creating a new structure for user-tweets
let REF_USER_TWEETS = DB_REF.child("user-tweets")
// Creating two new structures for users-follows
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
// Creating two new structures for users-likes
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
// Creating a new structure for notification
let REF_NOTIFICATIONS = DB_REF.child("notifications")
// Creating a new structure for user-replies
let REF_USER_REPLIES = DB_REF.child("user-replies")
// User-usernames
let REF_USERS_USERNAMES = DB_REF.child("users-usernames")

// Creating storage reference for images
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")


// Database link
// https://console.firebase.google.com/u/1/project/twitterclone-4f9c1/database/twitterclone-4f9c1-default-rtdb/data
