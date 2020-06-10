//
//  PreviewViewController.swift
//  Snapagram
//
//  Created by Nikhil Yerasi on 3/10/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet var threadImageView: UIImageView!
    
    var chosenThread: Thread!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewNextEntry()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewNextEntry()
    }
    
    func viewNextEntry() {
        if let nextEntry = chosenThread.removeFirstEntry() {
            threadImageView.image = nextEntry.image
        } else {
            // A function to go back to the "root" of the navigation controller, in this case the Feed
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
