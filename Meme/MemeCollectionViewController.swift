//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by Simran Khalsa on 9/1/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.memeImageView?.image = meme.memedImage

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        /*let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)*/
        
    }



}
