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
    var savedMeme: Meme?
    var savedIndex: Int? = nil
    var flag1: Bool = true
    var flag2: Bool = true
    
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
        
        if !(savedMeme == nil) {
            setSavedMeme(savedMeme!)
        }
        
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.toolbarHidden = false
        
        setTextFieldAttributes()
        
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
        
    }

    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField == topTextField {
            if flag1 {
                textField.text = nil
                flag1 = false
            }
        }
        if textField == bottomTextField {
            if flag2 {
                bottomTextField.text = nil
                flag2 = false

            }
        }
        return true
        
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
    
    func save(meme: Meme) {
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        if savedIndex == nil {
            appDelegate.memes.append(meme)
        } else {
            appDelegate.memes[savedIndex!] = meme
        }
    
    }
    
    func generatedMemedImage() -> UIImage {
        
        //Hide toolbar and nav
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = UIColor.clearColor()
        
        //Render view to an Image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and nav
        view.backgroundColor = UIColor.grayColor()
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
        topTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.adjustsFontSizeToFitWidth = true
        
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
    
    func setSavedMeme(savedMeme: Meme) {
        
        let image = savedMeme.origionalImage
        
        imagePickerView.removeFromSuperview()
        imagePickerView = UIImageView()
        imagePickerView.image = image
        imagePickerView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        scrollView.contentSize = imagePickerView.bounds.size
        scrollView.addSubview(imagePickerView)
        setZoomParameters()
        centerScrollViewContents()
        scrollView.contentInset = savedMeme.contentInset
        scrollView.zoomScale = savedMeme.zoomScale
        scrollView.contentOffset = savedMeme.contentOffset
        topTextField.text = savedMeme.topTextField
        bottomTextField.text = savedMeme.bottomTextField

        
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
        
         presentTabBarController()
        
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        //create Meme
        let meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, origionalImage:
            imagePickerView.image!, memedImage: generatedMemedImage(), zoomScale: scrollView.zoomScale, contentInset: scrollView.contentInset, contentOffset: scrollView.contentOffset)

        let memedImage = meme.memedImage
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        nextController.completionWithItemsHandler = {(type: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                
                if completed {
                    self.save(meme)
                    self.presentTabBarController()
                }
                
            }
        }
        
        presentViewController(nextController, animated: true, completion: nil)

    }
    
    func presentTabBarController() {
        
        let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.presentViewController(tabBarController, animated: true, completion: nil)
        
    }
    
}


