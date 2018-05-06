//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sergio Costa on 06/05/18.
//  Copyright © 2018 Sergio Costa. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    var meme : Meme? = nil
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memeImage.image = meme?.memedImage
    }
}
