//
//  selectPostViewController.swift
//  Snapagram
//
//  Created by Yuanrong Han on 3/18/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class selectPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var imageToPost: UIImage!
    @IBOutlet weak var threadCollectionView: UICollectionView!
    @IBOutlet weak var addNewThreadButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        threadCollectionView.delegate = self
        threadCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        postImageView.image = imageToPost
        setupButtons()
        setupTextFields()
    }
    
    private func setupButtons() {
        addNewThreadButton.backgroundColor = Constants.snapagramYellow
        addNewThreadButton.setTitleColor(.white, for: .normal)
        addNewThreadButton.layer.cornerRadius = 20
    }
    
    private func setupTextFields() {
        contentTextField.placeholder = "What do you want to say?"
        locationTextField.placeholder = "Where are you?"
        
        contentTextField.allowsEditingTextAttributes = true
        locationTextField.allowsEditingTextAttributes = true
        
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
            cell.threadBackground.layer.cornerRadius =  cell.threadBackground.frame.width / 2
            cell.threadBackground.layer.borderWidth = 3
            cell.threadBackground.layer.masksToBounds = true
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // segue to preview controller with selected thread
        let chosenThread = feed.threads[indexPath.item]
        chosenThread.addEntry(threadEntry: ThreadEntry(username: feed.username, image: self.imageToPost))
        toMainView()
    }

    @IBAction func postPressed(_ sender: Any) {
        if let location = self.locationTextField.text, let content = self.contentTextField.text {
            let newPost = Post(location: location, image: self.imageToPost, user: feed.username, caption: content, date: Date())
            feed.addPost(post: newPost)
            toMainView()
        }
    }
    @IBAction func addNewThreadPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add a new thread", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {UITextField in UITextField.placeholder = "What is the name of the new thread?"})
        alert.addTextField(configurationHandler: {UITextField in UITextField.placeholder = "What emoji you want to use?"})
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {action in
            if let threadName = alert.textFields?.first?.text,let threademoji = alert.textFields?[1].text {
                let newThread = Thread(name: threadName, emoji: threademoji)
                feed.addThread(thread: newThread)
                self.threadCollectionView.reloadData()
            }
//            let threadName = alert.textFields?.first?.text
//            let threademoji = alert.textFields?[1].text
        }))
        self.present(alert, animated: true)
    }
    
    private func toMainView() {
        let mainViewController = self.storyboard?.instantiateViewController(identifier: Constants.mainViewController) as? UITabBarController
        self.view.window?.rootViewController = mainViewController
        self.view.window?.makeKeyAndVisible()

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
