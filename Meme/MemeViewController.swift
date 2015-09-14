//
//  MemeViewController.swift
//  Meme
//
//  Created by Simran Khalsa on 9/13/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit

class MemeViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: nil)
    }
    
}
