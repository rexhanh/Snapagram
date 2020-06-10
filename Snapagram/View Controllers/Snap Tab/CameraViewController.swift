//
//  CameraViewController.swift
//  Snapagram
//
//  Created by RJ Pimentel on 3/11/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    var imagePickerController: UIImagePickerController!
    var pickedImage: UIImage!
    var pickedThread: Thread!
    @IBOutlet weak var pickedImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
        // Do any additional setup after loading the view.
    }
    
    private func setupImagePicker() {
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
    }
    
    // Mark IBActions
    @IBAction func addImagePressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Photo Libarary", style: .default, handler: {action in
            self.present(self.imagePickerController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func postTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSelect", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? selectPostViewController {
            destination.imageToPost = self.pickedImage
        }
    }
}
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.pickedImage = image
            self.pickedImageView.image = self.pickedImage
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
