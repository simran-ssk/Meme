//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Simran Khalsa on 9/1/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell!
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /*let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }*/
    }
    
    @IBAction func createMeme(sender: UIBarButtonItem) {
        
        let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("meme") as! MemeEditorViewController
        let navController = UINavigationController(rootViewController: editorController)
        presentViewController(navController, animated: true, completion: nil)
        
    }
    
}
