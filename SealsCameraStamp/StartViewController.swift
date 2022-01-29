//
//  StartViewController.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/10.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class StartViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    @IBAction func onAlbum(_ sender: AnyObject) {
        print(sender)
        self.onImage(sender: "" as AnyObject)
        /*
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        */
    }
    
    func onImage(sender:AnyObject){
        
        print("on image")
        //rightMenuConstraint.constant -= 200
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = true
            
            imagePicker.navigationBar.isTranslucent = false
            imagePicker.navigationBar.barStyle = .default
            imagePicker.navigationBar.tintColor = UIColor.black
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
            print(info)
        
            if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                selectImage(picker: picker, image:pickedImage)
            }
            //picker.dismiss(animated: true, completion: nil)
        }
 /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectImage(picker: picker, image:pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    */
    
    func selectImage(picker: UIImagePickerController, image:UIImage) {
        
        // 初回ボタンの選択はフィルタに
        PublicDatas.getPublicDatas().setData(value: 0 as AnyObject, key: "button")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BaseViewController") as! BaseViewController
        //vc._image = pickedImage
        vc.image = image
        self.navigationController!.pushViewController(vc, animated: true)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
