//
//
//  NavigationBarView.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 10/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

protocol NavigationBarDelegate {
    func backButtonPressed(_ button : UIButton)
}

class NavigationBarView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLabel: UILabel!

    var delegate : NavigationBarDelegate?
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = Bundle.main.loadNibNamed("NavigationBarView", owner: self, options: nil)![0] as? UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        view = Bundle.main.loadNibNamed("NavigationBarView", owner: self, options: nil)![0] as? UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.delegate?.backButtonPressed(sender)
    }
   
}
