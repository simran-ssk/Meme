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
    var savedIndex: Int? = nil
    
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
        
        //performSegueWithIdentifier("memeEditor", sender: self)
        
        let memeEditorController = self.storyboard?.instantiateViewControllerWithIdentifier("meme") as! MemeEditorViewController
        memeEditorController.savedMeme = self.meme
        memeEditorController.savedIndex = self.savedIndex
        let navController = UINavigationController(rootViewController: memeEditorController)
        presentViewController(navController, animated: true, completion: nil)

    }

    
 
}
