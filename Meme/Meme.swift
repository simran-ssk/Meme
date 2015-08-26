//
//  Meme.swift
//  Meme
//
//  Created by Simran Khalsa on 8/25/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit

struct Meme {
    
    var topTextField: String
    var bottomTextField: String
    var origionalImage: UIImage
    var memedImage: UIImage
    
    init(topTextField: String, bottomTextField: String, origionalImage: UIImage, memedImage: UIImage){
        self.topTextField = topTextField
        self.bottomTextField = bottomTextField
        self.origionalImage = origionalImage
        self.memedImage = memedImage
    }
    
}