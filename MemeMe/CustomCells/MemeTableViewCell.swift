//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Sergio Costa on 01/05/18.
//  Copyright © 2018 Sergio Costa. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topDescription: UILabel!
    @IBOutlet weak var bottomDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
