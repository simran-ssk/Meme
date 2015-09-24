//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by Simran Khalsa on 9/1/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    let memeTextAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont (name: "HelveticaNeue-CondensedBlack", size: 14)!,
        NSStrokeWidthAttributeName: NSNumber (float: -3)]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        let space: CGFloat = 3.0
        let dimesion = (self.view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimesion, dimesion)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.reloadData()
        tabBarController?.tabBar.hidden = false
        
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        
        cell.origionalImage?.image = meme.origionalImage
        cell.topTextField?.text = meme.topTextField
        cell.bottomTextField?.text = meme.bottomTextField
        
        setTextFieldAttributes(cell)
    

        return cell
    }
    
    func setTextFieldAttributes(cell: MemeCollectionViewCell) {
        
        cell.topTextField.defaultTextAttributes = memeTextAttributes
        cell.bottomTextField.defaultTextAttributes = memeTextAttributes
        cell.topTextField.userInteractionEnabled = false
        cell.bottomTextField.userInteractionEnabled = false
        cell.topTextField.textAlignment = NSTextAlignment.Center
        cell.bottomTextField.textAlignment = NSTextAlignment.Center
        
    }
    

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        /*let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)*/
        
    }



}
