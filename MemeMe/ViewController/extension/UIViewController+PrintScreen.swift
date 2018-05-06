//
//  File.swift
//  MemeMe
//
//  Created by Sergio Costa on 29/04/18.
//  Copyright © 2018 Sergio Costa. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func takePrintScreen() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let printScreenImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return printScreenImage
    }
}
