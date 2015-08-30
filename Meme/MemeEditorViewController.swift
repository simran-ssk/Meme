//
//  MemeEditorViewController.swift
//
//
//  Created by Simran Khalsa on 8/25/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit
import AVFoundation

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    var imagePickerView = UIImageView()
    
    let memeTextAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont (name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber (float: -5)]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        scrollView.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        print("viewWillTransistion")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeToKeyboardNotfications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if !(imagePickerView.image == nil){
            shareButton.enabled = true
        }else{
            shareButton.enabled = false
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
        
    }
    
    func subscribeToKeyboardNotfications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func save() -> Meme {
        
        var meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, origionalImage: imagePickerView.image!, memedImage: generatedMemedImage())
        return meme
        
    }
    
    func generatedMemedImage() -> UIImage {
        
        //Hide toolbar and nav
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //Render view to an Image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and nav
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        return memedImage
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imagePickerView.removeFromSuperview()
            imagePickerView = UIImageView()
            imagePickerView.image = image
            imagePickerView.sizeToFit()
            imagePickerView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            
            
            scrollView.contentSize = imagePickerView.bounds.size
            scrollView.addSubview(imagePickerView)
            
            setZoomParameters()
            centerScrollViewContents()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }else{
            print("Nothing here!")
        }
        
    }
    
    func setZoomParameters() {
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
        
    }
    
    
    func centerScrollViewContents() {
        
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imagePickerView.frame
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }else{
            contentsFrame.origin.y = 0
        }
        
        if contentsFrame.size.width < boundsSize.width{
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        }else{
            contentsFrame.origin.x = 0
        }
        
        imagePickerView.frame = contentsFrame
        
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        centerScrollViewContents()
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imagePickerView
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func pickAnImagefromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImgaefromCamera(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        imagePickerView.removeFromSuperview()
        topTextField.text = nil
        bottomTextField.text = nil
        shareButton.enabled = false
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        let newMeme = save()
        let memedImage = newMeme.memedImage
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(nextController, animated: true, completion: nil)
        
    }
    
    
}


