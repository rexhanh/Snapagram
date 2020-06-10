//
//  PostViewController.swift
//  Snapagram
//
//  Created by Yuanrong Han on 3/17/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    var postImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        postImageView.image = postImage
        // Do any additional setup after loading the view.
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
