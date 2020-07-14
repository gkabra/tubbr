//
//  SpotifyDetailViewController.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 11/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SpotifyDetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageDefaults = UserDefaults.standard
        if imageDefaults != nil{
            let bgImage = imageDefaults.imageForKey(key: "selectedImage")
            if bgImage != nil {
                self.imageView.image = bgImage

            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            self.view.alpha = 1
        }
    }

    @IBAction func backButtonPressed(_ button: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            self.view.alpha = 1
            self.dismiss(animated: true, completion: nil)
        }
    }

}
