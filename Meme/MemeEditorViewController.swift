//
//  MemeEditorViewController.swift
//
//
//  Created by Simran Khalsa on 8/25/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit
import AVFoundation

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.grayColor()
        scrollView.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        setTextFieldAttributes()
        setTextPlaceholderAttributes()
        navigationController?.setToolbarHidden(false, animated: true)    
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotfications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if !(imagePickerView.image == nil){
            shareButton.enabled = true
        }else{
            shareButton.enabled = false
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        centerScrollViewContents()
        setTextFieldAttributes()
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        textField.placeholder = nil
        return true
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        setTextPlaceholderAttributes()
    
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
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
        
        //create Meme
        let meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, origionalImage:
            imagePickerView.image!, memedImage: generatedMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        return meme
        
    }
    
    func generatedMemedImage() -> UIImage {
        
        //Hide toolbar and nav
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //Render view to an Image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and nav
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
        
        return memedImage
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func setTextFieldAttributes() {
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
    }
    
    func setTextPlaceholderAttributes() {
        
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont (name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: NSNumber (float: -5)])
        
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont (name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: NSNumber (float: -5)])
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
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
            dismissViewControllerAnimated(true, completion: nil)
            
        }else{
            print("Nothing here!", terminator: "")
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
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func pickAnImagefromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImgaefromCamera(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
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
        
        nextController.completionWithItemsHandler = {(type: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(nextController, animated: true, completion: nil)

    }
    
}


