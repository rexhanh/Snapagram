//
//  FeedViewController.swift
//  Snapagram
//
//  Created by Arman Vaziri on 3/8/20.
//  Modified by Yuanrong Han on 3/14/20
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var threadCollectionView: UICollectionView!
    @IBOutlet var postTableView: UITableView!
    var pickedImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        if feed.fetchedPost.count != 0 {
            feed.fetch()
        }
        for thread in feed.threads {
            if thread.threadEntryAdded.count != 0 {
                thread.fetch()
            }
        }
        self.postTableView.addSubview(refreshControl)
        threadCollectionView.delegate = self
        threadCollectionView.dataSource = self
        postTableView.delegate = self
        postTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        threadCollectionView.reloadData()
        postTableView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.threads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let thread = feed.threads[index]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "threadCell", for: indexPath) as? ThreadCollectionViewCell {
            cell.threadEmojiLabel.text = thread.emoji
            cell.threadNameLabel.text = thread.name
            cell.threadUnreadCountLabel.text = String(thread.unreadCount())
            
            cell.threadBackground.layer.cornerRadius =  cell.threadBackground.frame.width / 2
            cell.threadBackground.layer.borderWidth = 3
            cell.threadBackground.layer.masksToBounds = true
            
            cell.threadUnreadCountLabel.layer.cornerRadius = cell.threadUnreadCountLabel.frame.width / 2
            cell.threadUnreadCountLabel.layer.masksToBounds = true
            
            if thread.unreadCount() == 0 {
                cell.threadUnreadCountLabel.alpha = 0
            } else {
                cell.threadUnreadCountLabel.alpha = 1
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // segue to preview controller with selected thread
        let chosenThread = feed.threads[indexPath.item]

        if chosenThread.unreadCount() > 0 {
            performSegue(withIdentifier: "feedToPreview", sender: chosenThread)
        } else {
            presentAlertViewController(title: "Hmmm...", message: "This thread has no entries — add some yourself!")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 475
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenPost = feed.posts[indexPath.item]
        performSegue(withIdentifier: "feedToPostView", sender: chosenPost)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell {
            // configure cell
            let currentPost = feed.posts[indexPath.row]
            
            if let image = currentPost.image {
                cell.postImageView.image = image
            }
            cell.locationLabel.text = currentPost.location
            cell.timeLabel.text = formatDate(date: currentPost.date)
            cell.posterLabel.text = currentPost.user
            cell.captionLabel.text = currentPost.caption
            return cell
        }
        return UITableViewCell()
    }
    
    func presentAlertViewController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func formatDate(date: Date) -> String {
        // returns a concise string corresponding to time since post
        
        let minutesAgo =  -Int((date.timeIntervalSinceNow / 60))
        if minutesAgo < 60 {
            return "\(minutesAgo) minutes ago"
        }
        return "\(minutesAgo / 60) hours ago"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "feedToPreview" {
                if let dest = segue.destination as? PreviewViewController, let chosenThread = sender as? Thread  {
                    dest.chosenThread = chosenThread
                }
            }
            if identifier == "feedToPostView" {
                if let dest = segue.destination as? PostViewController, let chosenPost = sender as? Post {
                    dest.postImage = chosenPost.image
                }
            }
        }
    }
    
    @IBAction func refreshAllPressed(_ sender: Any) {
        sleep(2)
        self.threadCollectionView.reloadData()
        self.postTableView.reloadData()
    }
    // Mark -- Refresh Handler
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(FeedViewController.handlePostRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Constants.snapagramBlue
        return refreshControl
    }()
    
    @objc func handlePostRefresh(_ refreshControl: UIRefreshControl) {
        self.postTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}
