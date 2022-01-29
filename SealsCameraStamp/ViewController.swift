//
//  ViewController.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/03.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate {

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func openEditor(_ sender: UIBarButtonItem?) {
        guard let image = imageView.image else {
            return
        }
        // Uncomment to use crop view directly
        //        let imgView = UIImageView(image: image)
        //        imgView.clipsToBounds = true
        //        imgView.contentMode = .ScaleAspectFit
        //
        //        let cropView = CropView(frame: imageView.frame)
        //
        //        cropView.opaque = false
        //        cropView.clipsToBounds = true
        //        cropView.backgroundColor = UIColor.clearColor()
        //        cropView.imageView = imgView
        //        cropView.showCroppedArea = true
        //        cropView.cropAspectRatio = 1.0
        //        cropView.keepAspectRatio = true
        //
        //        view.insertSubview(cropView, aboveSubview: imageView)
        
        // Use view controller
        let controller = CropViewController()
        controller.delegate = self
        controller.image = image
        
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonAction(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.showCamera()
        }
        actionSheet.addAction(cameraAction)
        let albumAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            self.openPhotoAlbum()
        }
        actionSheet.addAction(albumAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        present(controller, animated: true, completion: nil)
    }
    
    func openPhotoAlbum() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    private func updateEditButtonEnabled() {
        editButton.isEnabled = self.imageView.image != nil
    }
    
    // MARK: - CropView
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage) {
        //        controller.dismissViewControllerAnimated(true, completion: nil)
        //        imageView.image = image
        //        updateEditButtonEnabled()
    }
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        controller.dismiss(animated: true, completion: nil)
        imageView.image = image
        updateEditButtonEnabled()
    }
    
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
        updateEditButtonEnabled()
    }
    
    // MARK: - UIImagePickerController delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        imageView.image = image
        
        dismiss(animated: true) { [unowned self] in
            self.openEditor(nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

