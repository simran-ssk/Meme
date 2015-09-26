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
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController!.tabBar.hidden = true
        memeImageView?.image = meme.memedImage
    
        
    }

 
}
