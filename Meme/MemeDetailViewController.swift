//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Simran Khalsa on 9/13/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet var memeImageView: UIImageView!
    var rightButton: UIBarButtonItem!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editMeme")
        self.navigationItem.rightBarButtonItem = rightButton

        
        tabBarController!.tabBar.hidden = true
        memeImageView?.image = meme.memedImage
    
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! MemeEditorViewController
        
        controller.savedMeme = self.meme
    }

    
    func editMeme() {
        
        performSegueWithIdentifier("memeEditor", sender: self)
        
        /*let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("memeEditor") as! UINavigationController
        /*let memeEditorController = self.storyboard?.instantiateViewControllerWithIdentifier("meme") as! MemeEditorViewController
        memeEditorController.imagePickerView.image = meme.origionalImage
        memeEditorController.topTextField?.text = meme.topTextField
        memeEditorController.bottomTextField?.text = meme.bottomTextField
        let navController = UINavigationController(rootViewController: memeEditorController)*/
        presentViewController(editorController, animated: true, completion: nil)*/

    }

    
 
}
