//
//  SpotifyTrackCollectionViewCell.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 10/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit


class SpotifyTrackCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackSubTitle: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    func setupView(){
    }
}

