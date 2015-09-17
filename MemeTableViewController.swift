//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Simran Khalsa on 9/1/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView!.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell!
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /*let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }*/
    }
    
    @IBAction func goToMemeEditor(sender: UIBarButtonItem) {
        
        let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("meme") as! MemeEditorViewController
        let navController = UINavigationController(rootViewController: editorController)

        presentViewController(navController, animated: true, completion: nil)
        
        
    }
    
}
