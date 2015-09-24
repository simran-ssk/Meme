//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Simran Khalsa on 9/1/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    let memeTextAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont (name: "HelveticaNeue-CondensedBlack", size: 14)!,
        NSStrokeWidthAttributeName: NSNumber (float: -3)]

    
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView!.reloadData()
           }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableCell
        let meme = memes[indexPath.row]
        
        
        cell.sentMemeImage?.image = meme.origionalImage
        cell.topTextField?.text = meme.topTextField
        cell.bottomTextField?.text = meme.bottomTextField
        cell.sentMemeName?.text = meme.topTextField + "..." + meme.bottomTextField
        
        setTextFieldAttributes(cell)
        
        return cell
    }
    
    func setTextFieldAttributes(cell: MemeTableCell) {
        
        cell.topTextField.defaultTextAttributes = memeTextAttributes
        cell.bottomTextField.defaultTextAttributes = memeTextAttributes
        cell.topTextField.userInteractionEnabled = false
        cell.bottomTextField.userInteractionEnabled = false
        cell.topTextField.textAlignment = NSTextAlignment.Center
        cell.bottomTextField.textAlignment = NSTextAlignment.Center
        
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
