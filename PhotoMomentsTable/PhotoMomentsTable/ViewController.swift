//
//  ViewController.swift
//  PhotoMomentsTable
//
//  Created by Simone on 1/22/17.
//  Copyright © 2017 Simone. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    var asset: PHAsset!
    @IBOutlet weak var fullPhotoView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let manager = PHImageManager()
        manager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), contentMode: .aspectFill, options: nil, resultHandler: { (result: UIImage?, _) in
            
            if let image = result {
                self.fullPhotoView?.image = image
            }
                
        })
    }
    
}

