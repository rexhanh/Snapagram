//
//  FeedData.swift
//  Snapagram
//
//  Created by Arman Vaziri on 3/8/20.
//  Modified by Yuanrong Han on 3/14/20
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// Create global instance of the feed
var feed = FeedData()

class Thread {
    var name: String
    var emoji: String
    var entries: [ThreadEntry]
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var threadEntryAdded: Set = ["place holder"]
    init(name: String, emoji: String) {
        self.name = name
        self.emoji = emoji
        self.entries = []
    }
    
    func addEntry(threadEntry: ThreadEntry) {
        entries.append(threadEntry)
        self.push(threadEntry: threadEntry)
    }
    
    func removeFirstEntry() -> ThreadEntry? {
        if entries.count > 0 {
            return entries.removeFirst()
        }
        return nil
    }
    
    func unreadCount() -> Int {
        return entries.count
    }
    
    func push(threadEntry: ThreadEntry) {
        let threadID = UUID.init().uuidString
        let userName = threadEntry.username
        let threadName = self.name
        if !self.threadEntryAdded.contains(threadID) {
            self.threadEntryAdded.insert(threadID)
            let storageRef = storage.reference(withPath: "threadimages/\(threadID).jpg")
            guard let imageData = threadEntry.image.jpegData(compressionQuality: 0.75) else {return}
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "threadimages/jpeg"
            storageRef.putData(imageData)
            
            var ref: DocumentReference? = nil
            ref = db.collection("threadEntry").addDocument(data:[
                "ThreadID":threadID,
                "UserName":userName,
                "BelongsToThread":threadName
            ]) {err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    
    func fetch() {
        db.collection("threadEntry").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let threadID = document.data()["ThreadID"] as! String
                    let userName = document.data()["UserName"] as! String
                    let parentThreadName = document.data()["BelongsToThread"] as! String
                    if parentThreadName == self.name {
                        let storageRef = self.storage.reference(withPath: "threadimages/\(threadID).jpg")
                        storageRef.getData(maxSize: 4 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("Error occured when getting the storage data.")
                            }
                            if let data = data {
                                let image = UIImage(data: data)!
                                let threadent = ThreadEntry(username: userName, image: image)
                                if !self.threadEntryAdded.contains(threadID) {
                                    self.threadEntryAdded.insert(threadID)
                                    self.entries.append(threadent)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
}

struct ThreadEntry {
    var username: String
    var image: UIImage
}

struct Post {
    var location: String
    var image: UIImage?
    var user: String
    var caption: String
    var date: Date
}

class FeedData {
    var username = "Rex_hanh718"
    
    var threads: [Thread] = [
        Thread(name: "memes", emoji: "😂"),
        Thread(name: "dogs", emoji: "🐶"),
        Thread(name: "fashion", emoji: "🕶"),
        Thread(name: "fam", emoji: "👨‍👩‍👧‍👦"),
        Thread(name: "tech", emoji: "💻"),
        Thread(name: "eats", emoji: "🍱"),
    ]
    
    // Adds dummy posts to the Feed
    var posts: [Post] = [
        Post(location: "New York City", image: UIImage(named: "skyline"), user: "nyerasi", caption: "Concrete jungle, wet dreams tomato 🍅 —Alicia Keys", date: Date()),
        Post(location: "Memorial Stadium", image: UIImage(named: "garbers"), user: "rjpimentel", caption: "Last Cal Football game of senior year!", date: Date()),
        Post(location: "Soda Hall", image: UIImage(named: "soda"), user: "chromadrive", caption: "Find your happy place 💻", date: Date())
    ]
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var fetchedPost: Set = ["place holder"]
    // Adds dummy data to each thread
//    init() {
//        for thread in threads {
//            let entry = ThreadEntry(username: self.username, image: UIImage(named: "garbers")!)
//            thread.addEntry(threadEntry: entry)
//        }
//    }
    
    func addPost(post: Post) {
        posts.append(post)
        push(post: post)
    }
    
    // Optional: Implement adding new threads!
    func addThread(thread: Thread) {
        threads.append(thread)
    }
    
    /*
        Push the Post data
        Post -> Unique ID, post content, post location, post time stamp
     */
    func push(post: Post) {
        let postID = UUID.init().uuidString
        let postText = post.caption
        let postLocation = post.location
        let postTimeStamp = post.date
        
        let storageRef = storage.reference(withPath: "images/\(postID).jpg")
        guard let imageData = post.image?.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(imageData)
        
        var ref: DocumentReference? = nil
        ref = db.collection("posts").addDocument(data:[
            "PostID":postID,
            "UserName":self.username,
            "TimeStamp":postTimeStamp,
            "PostContent":postText,
            "PostLocation":postLocation
        ]) {err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    /*
        Fetch the data from the server
     */
    func fetch() {
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let postId = document.data()["PostID"] as! String
                    let postTimeStamp = document.data()["TimeStamp"] as! Timestamp
                    let postText = document.data()["PostContent"] as! String
                    let postLocation = document.data()["PostLocation"] as! String
                    let userName = document.data()["UserName"] as! String
                    let postDate = Date(timeIntervalSince1970: TimeInterval(postTimeStamp.seconds))
                    let storageRef = self.storage.reference(withPath: "images/\(postId).jpg")
                    storageRef.getData(maxSize: 4 * 1024 * 1024, completion: { (data, error) in
                        if error != nil {
                            print("Error occured when getting the storage data.")
                        }
                        if let data = data {
                            let image = UIImage(data: data)!
                            let post = Post(location: postLocation, image: image, user: userName, caption: postText, date: postDate)
                            if !self.fetchedPost.contains(postId) {
                                self.fetchedPost.insert(postId)
                                self.posts.append(post)
                            }
                        }
                    })
                }
            }
        }
    }
}
